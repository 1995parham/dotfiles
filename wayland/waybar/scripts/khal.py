#!/usr/bin/env python
"""
show scheduled events from khal in the waybar
using the waybar json-based custom scripts.
"""

import json
import subprocess
import dataclasses


@dataclasses.dataclass
class WaybarResponse:
    text: str = ""
    tooltip: str = ""

    def json(self) -> str:
        return json.dumps(dataclasses.asdict(self))


data = WaybarResponse()

try:
    # getting the next 7 days events from khal
    khal_output = subprocess.check_output(
        "khal list now 7days --format "
        '"{start-end-time-style} {title} ({categories})"',
        shell=True,
        env={"TZ": "Asia/Tehran"},
    ).decode("utf-8")
except FileNotFoundError:
    exit(1)

# khal output has the following form:
# Today, 16.02.2023
# 09:30-09:45 Daily Standup
# 09:30-11:30 Technical Planning
# 20:30-24:00 Gym

lines: list[str] = []

for line in khal_output.split("\n"):
    # first lines should be bold so check the line is not empty
    # and make the lines that shows the date bold.
    if len(line) and line[0].isalpha():
        line = "\n<b>" + line + "</b>"
    lines.append(line)

output = "\n".join(lines).strip()

# shows the first today event in the status line
if "Today" in output:
    data.text = output.split("\n")[1] + " "
else:
    data.text = "Have fun" + " "
data.tooltip = output

print(data.json())
