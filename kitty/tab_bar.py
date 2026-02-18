import datetime
import zoneinfo

from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_tab_with_powerline
from kitty.utils import color_as_int

TEHRAN_TZ = zoneinfo.ZoneInfo("Asia/Tehran")


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    end = draw_tab_with_powerline(
        draw_data, screen, tab, before, max_tab_length, index, is_last, extra_data
    )

    if is_last:
        opts = get_options()
        clock = datetime.datetime.now(TEHRAN_TZ).strftime(" %H:%M ")
        bg = color_as_int(opts.tab_bar_background)
        fg = color_as_int(opts.active_tab_background)
        right_start = screen.columns - len(clock)

        if right_start > end:
            screen.cursor.x = right_start
            screen.cursor.bg = as_rgb(bg)
            screen.cursor.fg = as_rgb(fg)
            screen.cursor.bold = True
            screen.draw(clock)

    return end


timer_id = None


def on_load(boss, *a):
    global timer_id
    timer_id = boss.call_after(1.0, _refresh, boss)


def _refresh(boss):
    global timer_id
    boss.patch_tab_bar()
    timer_id = boss.call_after(1.0, _refresh, boss)
