#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
█▀▀ ▄▀█ █▀▀ █▀▀ █▀▀ █ █▄░█ █▀▀ ▀
█▄▄ █▀█ █▀░ █▀░ ██▄ █ █░▀█ ██▄ ▄
-- -- -- -- -- -- -- -- -- -- --
The script allows you to view the status of a process.
And also pause the process (kill -STOP pid)
and run it again (kill -CONT pid).

Here it monitors the work of the xidlehook process.
The script returns a process status icon.
It is mainly needed to stop the screensaver with
Qtile WM widget panel.
It's called "caffeine" after the popular widget gnome-shell

Dependencies:
-- -- -- -- 
- psutil
- xidlehook
- dunst
- NerdFonts for icons
"""


# █▀▄▀█ █▀▀ ▀█▀ ▄▀█ ▀
# █░▀░█ ██▄ ░█░ █▀█ ▄
# -------------------
__author__ = "MOIS3Y"
__credits__ = ["Stepan Zhukovsky"]
__license__ = "GPL v3.0"
__version__ = "0.1.0"
__maintainer__ = "Stepan Zhukovsky"
__email__ = "stepan@zhukovsky.me"
__status__ = "Production"


import sys
import argparse
import subprocess
import psutil


def find_process(name):
    for process in psutil.process_iter():
        if name.lower() in process.name().lower():
            return process


def toggle_process(process):
    pid = str(process.pid)
    status = process.status()
    flag = '-STOP'
    if status == 'stopped':
        flag = '-CONT'

    subprocess.run(['kill', flag, pid])


def make_caffeine_notify(process):
    if process.status() != 'stopped':
        subprocess.run([
            'dunstify',
            'Caffeine',
            'xidlehook - started'
        ])
    else:
        subprocess.run([
            'dunstify',
            'Caffeine',
            'xidlehook - paused'
        ])


def make_caffeine_icon(process):
    if process.status() != 'stopped':
        return '󰾪 '  # nf-md-coffee_off
    else:
        return '󰅶 '  # nf-md-coffee


def caffeine(name, toggle=False, is_notify=False):
    try:
        # xidlehook:
        process = find_process(name)
        # --toggle:
        if toggle:
            toggle_process(process)
            process = find_process(name)
            if is_notify:
                make_caffeine_notify(process)
            return make_caffeine_icon(process)
        else:
            return make_caffeine_icon(process)
    except AttributeError:
        return '󰾫 '  # nf-md-coffee_off_outline


def main():
    # -- -- -- -- parser -- -- -- --
    parser = argparse.ArgumentParser(
        description="caffeine app for xidlehook"
    )
    parser.add_argument(
        '--toggle',
        '-t',
        help='toggle xidlehook status',
        action='store_true'
    )
    parser.add_argument(
        '--notify',
        '-n',
        help='send notification message',
        action='store_true'
    )
    parser.add_argument(
        '--version',
        '-v',
        action='store_true',
        help='show version'
    )
    args = parser.parse_args()
    # Show version:
    if args.version:
        print(__version__)
        sys.exit(0)
        
    # -- -- -- -- caffeine -- -- -- --
    print(caffeine('xidlehook', args.toggle, args.notify), end='')


if __name__ == "__main__":
    main()
