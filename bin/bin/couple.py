#!/usr/bin/env python3

import datetime
import sys


def calculate_time_difference(
    start_date: datetime.datetime, end_date: datetime.datetime
):
    diff = end_date - start_date

    days = diff.days
    hours, remainder = divmod(diff.seconds, 3600)
    minutes, _ = divmod(remainder, 60)

    return days, hours, minutes


def in_marriage():
    since = datetime.datetime.strptime(
        f"09 may 2024 14:45:00+0330", "%d %b %Y %H:%M:%S%z"
    )
    now = datetime.datetime.now(datetime.timezone.utc)

    days, hours, minutes = calculate_time_difference(since, now)

    print(f"💍 {days} days {hours} hours {minutes} minutes")
    print("How long we were married? (marriage office 221)")


def in_relationship():
    start_date = datetime.datetime.strptime(
        "13 feb 2020 22:26:00+0330", "%d %b %Y %H:%M:%S%z"
    )
    now = datetime.datetime.now(datetime.timezone.utc)

    days, hours, minutes = calculate_time_difference(start_date, now)

    print(f"🧡 {days} days {hours} hours {minutes} minutes")
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

    days, hours, minutes = calculate_time_difference(now, to)

    print(f"🎂 {days} days {hours} hours {minutes} minutes")
    print("How much left until her birthday?")


def since_first_family_meeting():
    start_date = datetime.datetime.strptime(
        "18 nov 2022 15:30:00+0330", "%d %b %Y %H:%M:%S%z"
    )
    now = datetime.datetime.now(datetime.timezone.utc)

    days, hours, minutes = calculate_time_difference(start_date, now)

    print(f"{days} days {hours} hours {minutes} minutes")
    print("How much since our first family meeting?")


def since_first_family_dinner():
    start_date = datetime.datetime.strptime(
        "31 mar 2023 19:00:00+0330", "%d %b %Y %H:%M:%S%z"
    )
    now = datetime.datetime.now(datetime.timezone.utc)

    days, hours, minutes = calculate_time_difference(start_date, now)

    print(f"{days} days {hours} hours {minutes} minutes")
    print("How much since our first family dinner?")


def main():
    in_relationship()

    print()

    to_birthday()

    print()

    since_first_family_meeting()

    print()

    since_first_family_dinner()


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
        elif option == "first_family_meeting":
            since_first_family_meeting()
        elif option == "first_family_dinner":
            since_first_family_dinner()
