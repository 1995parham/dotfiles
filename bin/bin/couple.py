#!/usr/bin/env python3

import datetime
import sys


def calculate_time_difference(
    start_date: datetime.datetime, end_date: datetime.datetime
):
    diff = end_date - start_date

    years, days = divmod(diff.days, 365)
    hours, remainder = divmod(diff.seconds, 3600)
    minutes, _ = divmod(remainder, 60)

    return years, days, hours, minutes


def in_marriage():
    since = datetime.datetime.strptime(
        f"09 may 2024 14:45:00+0330", "%d %b %Y %H:%M:%S%z"
    )
    now = datetime.datetime.now(datetime.timezone.utc)

    years, days, hours, minutes = calculate_time_difference(since, now)

    if years == 0:
        print(f"💍 {days} days {hours} hours {minutes} minutes")
    else:
        print(f"💍 {years} years {days} days {hours} hours {minutes} minutes")
    print("How long we were married? (marriage office 221)")


def in_relationship():
    start_date = datetime.datetime.strptime(
        "13 feb 2020 22:26:00+0330", "%d %b %Y %H:%M:%S%z"
    )
    now = datetime.datetime.now(datetime.timezone.utc)

    years, days, hours, minutes = calculate_time_difference(start_date, now)

    if years == 0:
        print(f"🧡 {days} days {hours} hours {minutes} minutes")
    else:
        print(f"🧡 {years} years {days} days {hours} hours {minutes} minutes")
    print("How long we were together?")


def to_birthday():
    this_year = datetime.datetime.now().year
    next_year = this_year + 1

    to = datetime.datetime.strptime(
        f"12 oct {this_year} 19:20:00+0330", "%d %b %Y %H:%M:%S%z"
    )
    now = datetime.datetime.now(datetime.timezone.utc)

    if to < now:
        to = datetime.datetime.strptime(
            f"12 oct {next_year} 19:20:00+0330", "%d %b %Y %H:%M:%S%z"
        )

    _, days, hours, minutes = calculate_time_difference(now, to)

    print(f"🎂 {days} days {hours} hours {minutes} minutes")
    print("How much left until her birthday?")


def main():
    in_relationship()

    print()

    to_birthday()


if __name__ == "__main__":
    if len(sys.argv) != 2:
        main()
    else:
        option = sys.argv[1]
        if option == "birthday":
            to_birthday()
        elif option == "relationship":
            in_relationship()
        elif option == "marriage":
            in_marriage()
