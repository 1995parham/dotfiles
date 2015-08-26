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

import time
import os
import argparse

c_header = """/*
 * In The Name Of God
 * ========================================
 * [] File Name : ${FILE}
 *
 * [] Creation Date : ${DATE}
 *
 * [] Created By : ${USER} (${EMAIL})
 * =======================================
*/
/*
 * Copyright (c) ${YEAR} ${USER}.
*/
"""

py_header = """# In The Name Of God
# ========================================
# [] File Name : ${FILE}
#
# [] Creation Date : ${DATE}
#
# [] Created By : ${USER} (${EMAIL})
# =======================================
__author__ = '$[USER}'
"""

php_header = """<?php
/**
 * In The Name Of God
 * File: ${FILE}
 * User: ${USER} (${EMAIL})
 * Date: ${DATE}
 * Time: ${TIME}
 */
"""

java_header = """/*
 * In The Name Of God
 * ========================================
 * [] File Name : ${FILE}
 *
 * [] Creation Date : ${DATE}
 *
 * [] Created By : ${USER} (${EMAIL})
 * =======================================
*/
/**
 * @author ${USER}
 */
"""


class Config:
    def __init__(self):
        self.user = ""
        self.email = ""


config = Config()


def header_parser(header: str, filename: str) -> str:
    """

    :param header: header for parsing
    :param filename : filename for replacing ${filename} and ${path}
    :return: parsed version of input header
    """
    new_header = str(header)
    new_header = new_header.replace("${FILE}", os.path.split(filename)[1])
    new_header = new_header.replace("${PATH}", filename)
    new_header = new_header.replace("${TIME}", time.strftime("%H:%M"))
    new_header = new_header.replace("${DATE}", time.strftime("%d-%m-%Y"))
    new_header = new_header.replace("${YEAR}", time.strftime("%Y"))
    new_header = new_header.replace("${USER}", config.user)
    new_header = new_header.replace("${EMAIL}", config.email)
    return new_header


def update_source(srcfile: str) -> None:
    """

    :param srcfile: name of target source file
    :return: nothing
    """
    options = {
        '.c': c_header,
        '.h': c_header,
        '.S': c_header,
        '.s': c_header,
        '.v': c_header,
        '.go': c_header,
        '.py': py_header,
        '.php': php_header,
        '.java': java_header,
    }
    if os.path.splitext(srcfile)[-1] in options:
        header = options[os.path.splitext(srcfile)[-1]]
        print("Updating %s" % srcfile)
        header = header_parser(header, srcfile)
        file_data = open(srcfile, "r").read()
        file = open(srcfile, "w")
        file.write(header + file_data)
        return


parser = argparse.ArgumentParser(description="Copyright header adder script")
parser.add_argument('files', metavar='F', type=str, nargs='+', help='Target files')
parser.add_argument('--type', dest='type', choices=['default', 'file', 'manual'], default="default",
                    help='Select type of headers sources')
parser.add_argument('--user', dest='user', type=str, default='Parham Alvani')
parser.add_argument('--email', dest='email', type=str, default='parham.alvani@gmail.com')
parser.add_argument('--c-header', dest='c_file', type=argparse.FileType('r'), help='C-header source file')
parser.add_argument('--py-header', dest='py_file', type=argparse.FileType('r'), help='Python-header source file')
parser.add_argument('--php-header', dest='php_file', type=argparse.FileType('r'), help='PHP-header source file')

args = parser.parse_args()

config.email = args.email
config.user = args.user

if args.type == 'file':
    if args.c_file is not None:
        c_header = args.c_file.read()
    if args.php_file is not None:
        php_header = args.php_file.read()
    if args.py_file is not None:
        py_header = args.py_file.read()

while len(args.files) > 0:
    filepath = args.files.pop()
    update_source(filepath)
exit()
