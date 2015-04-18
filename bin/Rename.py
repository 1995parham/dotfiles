#!/usr/bin/python3
# In The Name Of God
# ========================================
# [] File Name : renamer
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
for file in sorted(os.listdir(path)):
    extension = os.path.splitext(file)[1]
    if extension.lower() == ".jpg":
        name = "%d.jpg" % index
        index += 1
        shutil.move(file, name)
        print("mv %s %s" % (file, name))