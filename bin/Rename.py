#!/usr/bin/python3
# In The Name Of God
# ========================================
# [] File Name : renamer.py
#
# [] Creation Date : 18-04-2015
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
__author__ = 'Parham Alvani'

import sys
import os
import shutil

if len(sys.argv) > 1:
    path = sys.argv[1]
else:
    path = "."

index = 1
print("{0:=^80}".format("Renaming start"))
for file in sorted(os.listdir(path)):
    extension = os.path.splitext(file)[1]
    if extension.lower() == ".jpg":
        name = "{0}.jpg".format(index)
        index += 1
        shutil.move(file, name)
        print("mv {0} {1}".format(file, name))
print("{0:=^80}".format("Renaming end"))
