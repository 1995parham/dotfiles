#!/usr/bin/python3
# In The Name Of God
# ========================================
# [] File Name : copyrighter.py
#
# [] Creation Date : 02-05-2015
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
__author__ = 'Parham Alvani'

# updates the copyright information for input files

import sys
import time
import os

c_header = """/*
 * In The Name Of God
 * ========================================
 * [] File Name : ${filename}
 *
 * [] Creation Date : ${date}
 *
 * [] Created By : Parham Alvani (parham.alvani@gmail.com)
 * =======================================
*/
/*
 * Copyright (c) 2015 Parham Alvani.
*/
"""

py_header = """# In The Name Of God
# ========================================
# [] File Name : ${filename}
#
# [] Creation Date : ${date}
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
__author__ = 'Parham Alvani'
"""

php_header = """<?php
/**
 * In The Name Of God
 * File: ${filename}
 * User: Parham Alvani (parham.alvani@gmail.com)
 * Date: ${date}
 * Time: ${time}
 */
"""


def update_source_c(srcfile):
    """

    :param srcfile: name of target C source file
    :return: nothing
    """
    print("Updating %s\n" % srcfile)
    file_header = c_header.replace("${filename}", os.path.split(srcfile)[1])
    file_date_header = file_header.replace("${date}", time.strftime("%d-%m-%Y"))
    file_data = open(srcfile, "r").read()
    file = open(srcfile, "w")
    file.write(file_date_header + file_data)
    return


def update_source_py(srcfile):
    """

    :param srcfile: name of target python source file
    :return: nothing
    """
    print("Updating %s\n" % srcfile)
    file_header = py_header.replace("${filename}", os.path.split(srcfile)[1])
    file_date_header = file_header.replace("${date}", time.strftime("%d-%m-%Y"))
    file_data = open(srcfile, "r").read()
    file = open(srcfile, "w")
    file.write(file_date_header + file_data)
    return


def update_source_php(srcfile):
    """

    :param srcfile: name of target PHP source file
    :return: nothing
    """
    print("Updating %s\n" % srcfile)
    file_header = php_header.replace("${filename}", os.path.split(srcfile)[1])
    time_file_header = file_header.replace("${time}", time.strftime("%H:%M"))
    time_file_date_header = time_file_header.replace("${date}", time.strftime("%d-%m-%Y"))
    file_data = open(srcfile, "r").read()
    file = open(srcfile, "w")
    file.write(time_file_date_header + file_data)
    return


def update_source(srcfile):
    """

    :param srcfile: name of target source file
    :return: nothing
    """
    options = {
        '.c': update_source_c,
        '.h': update_source_c,
        '.S': update_source_c,
        '.s': update_source_c,
        '.v': update_source_c,
        '.py': update_source_py,
        '.php': update_source_php
    }
    if os.path.splitext(srcfile)[-1] in options:
        options[os.path.splitext(srcfile)[-1]](srcfile)


while len(sys.argv) > 1:
    filename = sys.argv.pop()
    update_source(filename)
exit()