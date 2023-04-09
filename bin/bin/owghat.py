#!/usr/bin/env python3

import datetime
import math
import re

"""
--------------------- Copyright Block ----------------------

praytimes.py: Prayer Times Calculator (ver 2.3)
Copyright (C) 2007-2011 PrayTimes.org

Python Code: Saleem Shafi, Hamid Zarrabi-Zadeh
Original js Code: Hamid Zarrabi-Zadeh

License: GNU LGPL v3.0

TERMS OF USE:
    Permission is granted to use this code, with or
    without modification, in any website or application
    provided that credit is given to the original work
    with a link back to PrayTimes.org.

This program is distributed in the hope that it will
be useful, but WITHOUT ANY WARRANTY.

"""


class PrayTimeMethod:
    def __init__(self, name: str, params: dict[str, float | str]):
        self.name = name
        self.params = params


class PrayTimes:
    # Time Names
    time_names = {
        "imsak": "Imsak",
        "fajr": "Fajr",
        "sunrise": "Sunrise",
        "dhuhr": "Dhuhr",
        "asr": "Asr",
        "sunset": "Sunset",
        "maghrib": "Maghrib",
        "isha": "Isha",
        "midnight": "Midnight",
    }

    # Calculation Methods
    METHODS = {
        "MWL": PrayTimeMethod(
            name="Muslim World League",
            params={"fajr": 18, "isha": 17},
        ),
        "ISNA": PrayTimeMethod(
            name="Islamic Society of North America (ISNA)",
            params={"fajr": 15, "isha": 15},
        ),
        "Egypt": PrayTimeMethod(
            name="Egyptian General Authority of Survey",
            params={"fajr": 19.5, "isha": 17.5},
        ),
        "Makkah": PrayTimeMethod(
            name="Umm Al-Qura University, Makkah",
            params={"fajr": 18.5, "isha": "90 min"},
        ),  # fajr was 19 degrees before 1430 hijri
        "Karachi": PrayTimeMethod(
            name="University of Islamic Sciences, Karachi",
            params={"fajr": 18, "isha": 18},
        ),
        "Tehran": PrayTimeMethod(
            name="Institute of Geophysics, University of Tehran",
            params={
                "fajr": 17.7,
                "isha": 14,
                "maghrib": 4.5,
                "midnight": "Jafari",
            },
        ),  # isha is not explicitly specified in this method
        "Jafari": PrayTimeMethod(
            name="Shia Ithna-Ashari, Leva Institute, Qum",
            params={
                "fajr": 16,
                "isha": 14,
                "maghrib": 4,
                "midnight": "Jafari",
            },
        ),
    }

    # Default Parameters in Calculation Methods
    default_params = {"maghrib": "0 min", "midnight": "Standard"}

    # ---------------------- Default Settings --------------------

    timeFormat = "24h"
    timeSuffixes = ["am", "pm"]
    invalidTime = "-----"

    numIterations = 1
    offsets: dict = {}

    # ---------------------- Initialization -----------------------

    def __init__(self, method: str = "MWL"):
        # set methods defaults
        for _, config in self.METHODS.items():
            for name, value in self.default_params.items():
                if name not in config.params or config.params[name] is None:
                    config.params[name] = value

        # do not change anything here; use adjust method instead
        self.settings: dict[str, float | str] = {
            "imsak": "10 min",
            "dhuhr": "0 min",
            "asr": "Standard",
            "highLats": "NightMiddle",
        }
        # initialize settings
        self.calc_method = method if method in self.METHODS else "MWL"
        params = self.METHODS[self.calc_method].params
        for name, value in params.items():
            self.settings[name] = value

        # init time offsets
        for name in self.time_names:
            self.offsets[name] = 0

    # return prayer times for a given date
    def get_times(
        self,
        date: datetime.date,
        coords: tuple[float, float, float],
        timezone: float,
        dst: bool = False,
        format: str | None = None,
    ):
        self.lat = coords[0]
        self.lng = coords[1]
        self.elv = coords[2]
        if format is not None:
            self.timeFormat = format
        _date: tuple[int, int, int] = (date.year, date.month, date.day)
        self.timeZone = timezone + (1 if dst else 0)

        self.jDate = self.julian(_date[0], _date[1], _date[2]) - self.lng / (
            15 * 24.0
        )
        return self.compute_times()

    # convert float time to the given format (see timeFormats)
    def get_formatted_time(self, time, format, suffixes=None):
        if math.isnan(time):
            return self.invalidTime
        if format == "Float":
            return time
        if suffixes is None:
            suffixes = self.timeSuffixes

        time = self.fixhour(time + 0.5 / 60)  # add 0.5 minutes to round
        hours = math.floor(time)

        minutes = math.floor((time - hours) * 60)
        suffix = suffixes[0 if hours < 12 else 1] if format == "12h" else ""
        formattedTime = (
            "%02d:%02d" % (hours, minutes)
            if format == "24h"
            else "%d:%02d" % ((hours + 11) % 12 + 1, minutes)
        )
        return formattedTime + suffix

    # ---------------------- Calculation Functions -----------------------

    # compute mid-day time
    def mid_day(self, time):
        eqt = self.sunPosition(self.jDate + time)[1]
        return self.fixhour(12 - eqt)

    # compute the time at which sun reaches a specific angle below horizon
    def sunAngleTime(self, angle, time, direction=None):
        try:
            decl = self.sunPosition(self.jDate + time)[0]
            noon = self.mid_day(time)
            t = (
                1
                / 15.0
                * self.arccos(
                    (-self.sin(angle) - self.sin(decl) * self.sin(self.lat))
                    / (self.cos(decl) * self.cos(self.lat))
                )
            )
            return noon + (-t if direction == "ccw" else t)
        except ValueError:
            return float("nan")

    # compute asr time
    def asrTime(self, factor, time):
        decl = self.sunPosition(self.jDate + time)[0]
        angle = -self.arccot(factor + self.tan(abs(self.lat - decl)))
        return self.sunAngleTime(angle, time)

    # compute declination angle of sun and equation of time
    # Ref: http://aa.usno.navy.mil/faq/docs/SunApprox.php
    def sunPosition(self, jd):
        D = jd - 2451545.0
        g = self.fixangle(357.529 + 0.98560028 * D)
        q = self.fixangle(280.459 + 0.98564736 * D)
        L = self.fixangle(q + 1.915 * self.sin(g) + 0.020 * self.sin(2 * g))

        e = 23.439 - 0.00000036 * D

        RA = self.arctan2(self.cos(e) * self.sin(L), self.cos(L)) / 15.0
        eqt = q / 15.0 - self.fixhour(RA)
        decl = self.arcsin(self.sin(e) * self.sin(L))

        return (decl, eqt)

    # convert Gregorian date to Julian day
    # Ref: Astronomical Algorithms by Jean Meeus
    def julian(self, year, month, day):
        if month <= 2:
            year -= 1
            month += 12
        A = math.floor(year / 100)
        B = 2 - A + math.floor(A / 4)
        return (
            math.floor(365.25 * (year + 4716))
            + math.floor(30.6001 * (month + 1))
            + day
            + B
            - 1524.5
        )

    # compute prayer times at given julian date
    def computePrayerTimes(self, times):
        times = self.day_portion(times)
        params = self.settings

        imsak = self.sunAngleTime(
            self.eval(params["imsak"]), times["imsak"], "ccw"
        )
        fajr = self.sunAngleTime(
            self.eval(params["fajr"]), times["fajr"], "ccw"
        )
        sunrise = self.sunAngleTime(
            self.rise_set_angle(self.elv), times["sunrise"], "ccw"
        )
        dhuhr = self.mid_day(times["dhuhr"])
        asr = self.asrTime(self.asrFactor(params["asr"]), times["asr"])
        sunset = self.sunAngleTime(
            self.rise_set_angle(self.elv), times["sunset"]
        )
        maghrib = self.sunAngleTime(
            self.eval(params["maghrib"]), times["maghrib"]
        )
        isha = self.sunAngleTime(self.eval(params["isha"]), times["isha"])
        return {
            "imsak": imsak,
            "fajr": fajr,
            "sunrise": sunrise,
            "dhuhr": dhuhr,
            "asr": asr,
            "sunset": sunset,
            "maghrib": maghrib,
            "isha": isha,
        }

    # compute prayer times
    def compute_times(self):
        times = {
            "imsak": 5,
            "fajr": 5,
            "sunrise": 6,
            "dhuhr": 12,
            "asr": 13,
            "sunset": 18,
            "maghrib": 18,
            "isha": 18,
        }
        # main iterations
        for _ in range(self.numIterations):
            times = self.computePrayerTimes(times)
        times = self.adjustTimes(times)
        # add midnight time
        if self.settings["midnight"] == "Jafari":
            times["midnight"] = (
                times["sunset"]
                + self.time_diff(times["sunset"], times["fajr"]) / 2
            )
        else:
            times["midnight"] = (
                times["sunset"]
                + self.time_diff(times["sunset"], times["sunrise"]) / 2
            )

        times = self.tune_times(times)
        return self.modify_formats(times)

    # adjust times in a prayer time array
    def adjustTimes(self, times):
        params = self.settings
        tzAdjust = self.timeZone - self.lng / 15.0
        for t, _ in times.items():
            times[t] += tzAdjust

        if params["highLats"] != "None":
            times = self.adjust_high_lats(times)

        if self.isMin(params["imsak"]):
            times["imsak"] = times["fajr"] - self.eval(params["imsak"]) / 60.0
        # need to ask about 'min' settings
        if self.isMin(params["maghrib"]):
            times["maghrib"] = (
                times["sunset"] - self.eval(params["maghrib"]) / 60.0
            )

        if self.isMin(params["isha"]):
            times["isha"] = times["maghrib"] - self.eval(params["isha"]) / 60.0
        times["dhuhr"] += self.eval(params["dhuhr"]) / 60.0

        return times

    # get asr shadow factor
    def asrFactor(self, asrParam):
        methods = {"Standard": 1, "Hanafi": 2}
        return (
            methods[asrParam] if asrParam in methods else self.eval(asrParam)
        )

    # return sun angle for sunset/sunrise
    def rise_set_angle(self, elevation: float = 0):
        elevation = 0 if elevation is None else elevation
        return 0.833 + 0.0347 * math.sqrt(elevation)  # an approximation

    # apply offsets to the times
    def tune_times(self, times):
        for name, _ in times.items():
            times[name] += self.offsets[name] / 60.0
        return times

    # convert times to given time format
    def modify_formats(self, times):
        for name, _ in times.items():
            times[name] = self.get_formatted_time(times[name], self.timeFormat)
        return times

    # adjust times for locations in higher latitudes
    def adjust_high_lats(self, times):
        params = self.settings
        nightTime = self.time_diff(
            times["sunset"], times["sunrise"]
        )  # sunset to sunrise
        times["imsak"] = self.adjust_high_lats_time(
            times["imsak"],
            times["sunrise"],
            self.eval(params["imsak"]),
            nightTime,
            "ccw",
        )
        times["fajr"] = self.adjust_high_lats_time(
            times["fajr"],
            times["sunrise"],
            self.eval(params["fajr"]),
            nightTime,
            "ccw",
        )
        times["isha"] = self.adjust_high_lats_time(
            times["isha"],
            times["sunset"],
            self.eval(params["isha"]),
            nightTime,
        )
        times["maghrib"] = self.adjust_high_lats_time(
            times["maghrib"],
            times["sunset"],
            self.eval(params["maghrib"]),
            nightTime,
        )
        return times

    # adjust a time for higher latitudes
    def adjust_high_lats_time(self, time, base, angle, night, direction=None):
        portion = self.night_portion(angle, night)
        diff = (
            self.time_diff(time, base)
            if direction == "ccw"
            else self.time_diff(base, time)
        )
        if math.isnan(time) or diff > portion:
            time = base + (-portion if direction == "ccw" else portion)
        return time

    # the night portion used for adjusting times in higher latitudes
    def night_portion(self, angle, night):
        method = self.settings["highLats"]
        portion = 1 / 2.0  # midnight
        if method == "AngleBased":
            portion = 1 / 60.0 * angle
        if method == "OneSeventh":
            portion = 1 / 7.0
        return portion * night

    # convert hours to day portions
    def day_portion(self, times):
        for i in times:
            times[i] /= 24.0
        return times

    # compute the difference between two times
    def time_diff(self, time1, time2):
        return self.fixhour(time2 - time1)

    # convert given string into a number
    def eval(self, st):
        val = re.split("[^0-9.+-]", str(st), 1)[0]
        return float(val) if val else 0

    # detect if input contains 'min'
    def isMin(self, arg):
        return isinstance(arg, str) and arg.find("min") > -1

    def sin(self, d):
        return math.sin(math.radians(d))

    def cos(self, d):
        return math.cos(math.radians(d))

    def tan(self, d):
        return math.tan(math.radians(d))

    def arcsin(self, x):
        return math.degrees(math.asin(x))

    def arccos(self, x):
        return math.degrees(math.acos(x))

    def arctan(self, x):
        return math.degrees(math.atan(x))

    def arccot(self, x):
        return math.degrees(math.atan(1.0 / x))

    def arctan2(self, y, x):
        return math.degrees(math.atan2(y, x))

    def fixangle(self, angle):
        return self.fix(angle, 360.0)

    def fixhour(self, hour):
        return self.fix(hour, 24.0)

    def fix(self, a, mode):
        if math.isnan(a):
            return a
        a = a - mode * (math.floor(a / mode))
        return a + mode if a < 0 else a


if __name__ == "__main__":
    pray_times = PrayTimes("Tehran")

    print("Prayer Times for today in Iran/Tehran\n" + ("=" * 41))
    times = pray_times.get_times(
        datetime.date.today(),
        (35.69439, 51.42151, 0),
        +3.50,
    )
    for i in [
        "Fajr",
        "Dhuhr",
        "Maghrib",
        "Midnight",
    ]:
        print(f"{i}: {times[i.lower()]}")
