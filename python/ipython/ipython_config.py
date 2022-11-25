# Configuration file for ipython.

# Configure matplotlib for interactive use with
# the default matplotlib backend.
#  Choices: any of ['auto', 'agg', 'gtk', 'gtk3', 'gtk4',
# 'inline', 'ipympl', 'nbagg', 'notebook',
# 'osx', 'pdf', 'ps', 'qt', 'qt4', 'qt5',
# 'qt6', 'svg', 'tk', 'widget', 'wx'] (case-insensitive) or None
#  Default: None
import importlib

spam_spec = importlib.util.find_spec("matplotlib")
found = spam_spec is not None

if found:
    c.InteractiveShellApp.matplotlib = "inline"


# Whether to display a banner upon starting IPython.
# Default: True
c.TerminalIPythonApp.display_banner = True

# The part of the banner to be printed after the profile
# Default: ''
c.InteractiveShell.banner2 = r"""
 _  ___   ___  ____                   _
/ |/ _ \ / _ \| ___| _ __   __ _ _ __| |__   __ _ _ __ ___
| | (_) | (_) |___ \| '_ \ / _` | '__| '_ \ / _` | '_ ` _ \
| |\__, |\__, |___) | |_) | (_| | |  | | | | (_| | | | | | |
|_|  /_/   /_/|____/| .__/ \__,_|_|  |_| |_|\__,_|_| |_| |_|
                    |_|
"""

# Set the color scheme (NoColor, Neutral, Linux, or LightBG).
# Choices: any of ['Neutral', 'NoColor',
# 'LightBG', 'Linux'] (case-insensitive)
# Default: 'Neutral'
c.InteractiveShell.colors = "Linux"

# Autoformatter to reformat Terminal code. Can be `'black'` or `None`
# Default: 'black'
c.TerminalInteractiveShell.autoformatter = "black"

# Shortcut style to use at the prompt. 'vi' or 'emacs'.
# Default: 'emacs'
c.TerminalInteractiveShell.editing_mode = "vi"

# Add shortcuts from 'emacs' insert mode to 'vi' insert mode.
# Default: True
c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = True

# Enable vi (v) or Emacs (C-X C-E) shortcuts
# to open an external editor. This is
# in addition to the F2 binding, which is always enabled.
# Default: False
c.TerminalInteractiveShell.extra_open_editor_shortcuts = True

c.InteractiveShellApp.exec_lines = [
    "import numpy as np",
    "import pandas as pd",
]
