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


def to_departure():
    to = datetime.datetime.strptime(f"20 jun 2024 00:00:00", "%d %b %Y %H:%M:%S")
    now = datetime.datetime.now()

    days, hours, minutes = calculate_time_difference(now, to)

    print(f"{days} days {hours} hours {minutes} minutes")
    print("How much left until/since her depature?")


def in_relationship():
    start_date = datetime.datetime.strptime("13 feb 2020 22:26:00", "%d %b %Y %H:%M:%S")
    now = datetime.datetime.now()

    days, hours, minutes = calculate_time_difference(start_date, now)

    print(f"{days} days {hours} hours {minutes} minutes")
    print("How long we were together?")


def to_birthday():
    this_year = datetime.datetime.now().year
    next_year = this_year + 1

    to = datetime.datetime.strptime(f"12 oct {this_year} 19:20:00", "%d %b %Y %H:%M:%S")
    now = datetime.datetime.now()

    diff = to - now

    if diff.days < 0:
        to = datetime.datetime.strptime(
            f"12 oct {next_year} 19:20:00", "%d %b %Y %H:%M:%S"
        )
        diff = to - now

    days, hours, minutes = calculate_time_difference(now, to)

    print(f"{days} days {hours} hours {minutes} minutes")
    print("How much left until her birthday?")


def since_first_family_meeting():
    start_date = datetime.datetime.strptime("18 nov 2022 15:30:00", "%d %b %Y %H:%M:%S")
    now = datetime.datetime.now()

    days, hours, minutes = calculate_time_difference(start_date, now)

    print(f"{days} days {hours} hours {minutes} minutes")
    print("How much since our first family meeting?")


def since_first_family_dinner():
    start_date = datetime.datetime.strptime("31 mar 2023 19:00:00", "%d %b %Y %H:%M:%S")
    now = datetime.datetime.now()

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
        elif option == "departure":
            to_departure()
        elif option == "first_family_meeting":
            since_first_family_meeting()
