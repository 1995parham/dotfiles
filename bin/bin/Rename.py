#!/usr/bin/env python3
# In The Name Of God
# ========================================
# [] File Name : renamer.py
#
# [] Creation Date : 18-04-2015
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
__author__ = 'Parham Alvani'

import os
import shutil
import cmd
import imghdr

try:
    import termcolor
except ImportError:
    termcolor = None


class Rename(cmd.Cmd):
    def __init__(self):
        super(Rename, self).__init__()
        self.path = '.'
        self.mode = 'pictures'
        self.sc = 1
        self.intro = """
{0:*^80}
{1:=^80}
Renamer version 2.1, Copyright (C) 2015 Parham Alvani (parham.alvani@gmail.com)
Renamer comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
This is free software, and you are welcome to redistribute it
under certain conditions; type `show c' for details.
""".format("Welcome", "Renamer program for organizing pictures and tv series")

    def do_rename(self, line: str):
        print("{0:=^80}".format("Renaming start"))
        print("Mode: {0:<80}".format(self.mode))
        print("Path: {0:<80}".format(self.path))
        print("Sequence Counter: {0:<80}".format(self.sc))

        if self.mode == 'pictures':
            index = self.sc
            for file in sorted(os.listdir(self.path)):
                if not os.path.isdir(file):
                    extension = imghdr.what(file)
                else:
                    extension = None
                if extension:
                    name = "{0}.{1}".format(index, extension)
                    index += 1
                    if os.path.exists(os.path.join(self.path, name)):
                        result = input(
                            "{0} is exists, do you wish to continue ? (Yes / No)".format(os.path.join(self.path, name)))
                        if result != 'Yes':
                            break
                    shutil.move(os.path.join(self.path, file), os.path.join(self.path, name))
                    print("mv {0} {1}".format(os.path.join(self.path, file), os.path.join(self.path, name)))

        if self.mode == 'tv-series':
            series = input("TV-Series Name: ")
            season = input("TV-Series Season#: ")
            index = self.sc
            for file in sorted(os.listdir(self.path)):
                extension = os.path.splitext(file)[1]
                if extension.lower() == ".mkv":
                    name = "Episode {0}/{1} S{2:0>2}E{0:0>2}.mkv".format(index, series, season)
                    os.mkdir(os.path.join(self.path, "Episode {0}".format(index)))
                    index += 1
                    shutil.move(os.path.join(self.path, file), os.path.join(self.path, name))
                    print("mv {0} {1}".format(os.path.join(self.path, file), os.path.join(self.path, name)))

        print("{0:=^80}".format("Renaming end"))

    def do_shell(self, line: str):
        os.system(line)

    def do_quit(self, line: str):
        print("Thank you for using Renamer")
        return True

    def do_mode(self, line: str):
        if line.lower() == 'pictures':
            self.mode = 'pictures'
        elif line.lower() == 'tv-series':
            self.mode = 'tv-series'
        else:
            print("*** Unknown mode: {0}".format(line))

    def do_path(self, line: str):
        if os.path.isdir(line):
            self.path = line
        else:
            print("*** Invalid path: {0}".format(line))

    def do_sc(self, line: str):
        try:
            self.sc = int(line)
        except ValueError as e:
            self.sc = 1
            print("*** Invalid number: {0}".format(str(e)))

    @property
    def prompt(self):
        prompt = "Renamer at {0} > [{1}] ".format(self.path, self.mode)
        if termcolor:
            prompt = termcolor.colored(prompt, color="red", attrs=['bold'])
        return prompt

    do_EOF = do_quit


cli = Rename()
cli.cmdloop()
