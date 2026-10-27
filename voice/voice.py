"""voice: dictation and read-aloud, offline.

    voice dictate   first call starts recording, the second transcribes it
                    with whisper (openvino, on the arc gpu) and types the text
                    into the focused window, and copies it too. the model loads
                    while you speak, so only the transcription is waited for
    voice speak     reads the selection (or the clipboard) aloud with piper,
                    in a persian voice when the text is persian; a second call
                    stops it
    voice fetch     downloads the models (huggingface, once)
    voice transcribe <wav>   prints the transcript of a 16 kHz wav file

the hyprland bindings are in hyprland/hypr/config/binds.lua. models live in
~/.local/share/voice, compiled gpu blobs in ~/.cache/voice.

the npu (intel ai boost) is not the default: arch's intel-npu-driver leaves
out intel's graph compiler (libnpu_driver_compiler.so), so the npu cannot
compile a model and openvino fails with ZE_RESULT_ERROR_UNSUPPORTED_FEATURE.

environment:
    VOICE_DEVICE    openvino device for whisper: GPU (default), NPU or CPU
    VOICE_WHISPER   huggingface repo of an openvino whisper export
    VOICE_LANGUAGE  whisper language token, e.g. fa or en (default: detect)
"""

import os
import re
import signal
import subprocess
import sys
import time
import wave
from pathlib import Path

DATA = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "voice"
CACHE = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "voice"
RUNTIME = Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp")) / "voice"

WHISPER = os.environ.get("VOICE_WHISPER", "OpenVINO/whisper-large-v3-turbo-int8-ov")
DEVICE = os.environ.get("VOICE_DEVICE", "GPU")
LANGUAGE = os.environ.get("VOICE_LANGUAGE", "")

# piper voices from rhasspy/piper-voices: gyro for persian, lessac for english
VOICES = {
    "fa": "fa/fa_IR/gyro/medium/fa_IR-gyro-medium.onnx",
    "en": "en/en_US/lessac/medium/en_US-lessac-medium.onnx",
}
PERSIAN = re.compile("[؀-ۿ]")
RATE = 16000


def notify(summary, body="", replace=None):
    """a desktop notification, returning its id so the next one replaces it."""
    cmd = ["notify-send", "-a", "voice", "-p", summary, body]
    if replace:
        cmd += ["-r", str(replace)]
    out = subprocess.run(cmd, capture_output=True, text=True, check=False)
    return out.stdout.strip() or None


def pid_alive(path):
    """the pid in path when that process still runs, else None."""
    try:
        pid = int(path.read_text())
        os.kill(pid, 0)
        return pid
    except (FileNotFoundError, ValueError, ProcessLookupError):
        path.unlink(missing_ok=True)
        return None


def whisper_dir():
    return DATA / "whisper" / WHISPER.split("/")[-1]


def fetch():
    from huggingface_hub import hf_hub_download, snapshot_download

    print(f"whisper: {WHISPER}")
    snapshot_download(WHISPER, local_dir=whisper_dir())
    for path in VOICES.values():
        for name in (path, path + ".json"):
            print(f"piper: {name}")
            hf_hub_download("rhasspy/piper-voices", name, local_dir=DATA / "piper")


def pipeline():
    import openvino_genai

    CACHE.mkdir(parents=True, exist_ok=True)
    try:
        return openvino_genai.WhisperPipeline(str(whisper_dir()), DEVICE, CACHE_DIR=str(CACHE))
    except RuntimeError:
        # no such device, or a driver problem: the cpu always works
        return openvino_genai.WhisperPipeline(str(whisper_dir()), "CPU", CACHE_DIR=str(CACHE))


def transcribe(wav, pipe=None):
    import numpy as np

    with wave.open(str(wav)) as w:
        audio = np.frombuffer(w.readframes(w.getnframes()), dtype=np.int16)
    speech = (audio.astype(np.float32) / 32768.0).tolist()

    options = {"task": "transcribe", "max_new_tokens": 440}
    if LANGUAGE:
        options["language"] = f"<|{LANGUAGE}|>"
    return str((pipe or pipeline()).generate(speech, **options)).strip()


def dictate():
    """toggle: start a dictation session, or tell the running one to finish."""
    RUNTIME.mkdir(parents=True, exist_ok=True)
    pid = pid_alive(RUNTIME / "dictate.pid")
    if pid is not None:
        os.kill(pid, signal.SIGUSR1)
        return
    subprocess.Popen([sys.executable, os.path.abspath(__file__), "session"], start_new_session=True)


def session():
    """one dictation: record and load the model at once, and on SIGUSR1 stop,
    transcribe and type. loading takes ~3 s, so it is hidden behind speaking."""
    pidfile, wav = RUNTIME / "dictate.pid", RUNTIME / "dictate.wav"
    signal.pthread_sigmask(signal.SIG_BLOCK, {signal.SIGUSR1})
    pidfile.write_text(str(os.getpid()))
    try:
        rec = subprocess.Popen(
            ["pw-record", "--rate", str(RATE), "--channels", "1", "--format", "s16", str(wav)],
        )
        nid = notify("🎙 listening", "press the dictation key again to stop")
        pipe = pipeline()
        signal.sigwait({signal.SIGUSR1})

        # stop the recorder and let it finish the wav header
        rec.send_signal(signal.SIGINT)
        rec.wait(timeout=5)
        nid = notify("✍ transcribing", "", nid)
        started = time.monotonic()
        text = transcribe(wav, pipe)
        # whisper answers silence with a lone "." or similar
        if not any(c.isalnum() for c in text):
            notify("🎙 heard nothing", "", nid)
            return

        subprocess.run(["wl-copy", text], check=False)
        subprocess.run(["wtype", "--", text], check=False)
        notify(f"✓ {time.monotonic() - started:.1f}s", text, nid)
    finally:
        pidfile.unlink(missing_ok=True)
        wav.unlink(missing_ok=True)


def speak():
    RUNTIME.mkdir(parents=True, exist_ok=True)
    pidfile = RUNTIME / "speak.pid"

    pid = pid_alive(pidfile)
    if pid is not None:
        try:
            os.killpg(pid, signal.SIGTERM)
        except ProcessLookupError:
            os.kill(pid, signal.SIGTERM)
        pidfile.unlink(missing_ok=True)
        return

    text = ""
    for args in (["wl-paste", "--primary", "--no-newline"], ["wl-paste", "--no-newline"]):
        out = subprocess.run(args, capture_output=True, text=True, check=False)
        if out.returncode == 0 and out.stdout.strip():
            text = out.stdout.strip()
            break
    if not text:
        notify("🔈 nothing selected")
        return

    from piper import PiperVoice

    voice = PiperVoice.load(str(DATA / "piper" / VOICES["fa" if PERSIAN.search(text) else "en"]))
    # its own process group, so the second call stops pw-play with it
    try:
        os.setpgid(0, 0)
    except PermissionError:
        pass
    pidfile.write_text(str(os.getpid()))
    try:
        play = None
        for chunk in voice.synthesize(text):
            if play is None:
                play = subprocess.Popen(
                    ["pw-play", "--rate", str(chunk.sample_rate), "--channels", "1", "--format", "s16", "-"],
                    stdin=subprocess.PIPE,
                )
            play.stdin.write(chunk.audio_int16_bytes)
        if play:
            play.stdin.close()
            play.wait()
    finally:
        pidfile.unlink(missing_ok=True)


def main():
    commands = {"dictate": dictate, "session": session, "speak": speak, "fetch": fetch}
    if len(sys.argv) == 3 and sys.argv[1] == "transcribe":
        print(transcribe(sys.argv[2]))
    elif len(sys.argv) == 2 and sys.argv[1] in commands:
        commands[sys.argv[1]]()
    else:
        print(__doc__)
        sys.exit(1)


if __name__ == "__main__":
    main()
