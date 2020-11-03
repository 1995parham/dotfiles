#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : owghat.sh
#
# [] Creation Date : 03-11-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

curl -Ls https://api.keybit.ir/owghat/?city=%D8%AA%D9%87%D8%B1%D8%A7%D9%86 | jq .result
