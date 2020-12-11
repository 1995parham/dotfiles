#! /usr/bin/env python2
import subprocess


def get_from_gopass(account):
    return subprocess.check_output(
        "gopass show -o %s" % account, shell=True
    ).splitlines()[0]
