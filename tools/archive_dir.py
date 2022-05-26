#!/usr/bin/env python3

"""
根据日期归档文件夹
"""

import subprocess
import os
import sys
from collections import defaultdict


def get_date_to_filename(dir_path):
    cmd = "ls -l --time-style=\"+%Y-%m\" {dir_path} | grep ^- | awk '{{print $6,$7}}'"
    status, output = subprocess.getstatusoutput(
        cmd.format(dir_path=dir_path)
    )
    if status != 0:
        print(output)

    date_to_filename_list = defaultdict(list)
    for line in output.split('\n'):
        date, filename = line.split(' ')
        date_to_filename_list[date].append(filename)

    return date_to_filename_list


def check_or_create_folder(date_list):
    for date in date_list:
        os.makedirs(date, exist_ok=True)


def move_file(date_to_filename_list):
    cmd_list = []
    for date, filename_list in date_to_filename_list.items():
        for filename in filename_list:
            cmd_list.append(
                f'mv {filename} {date}/'
            )

    for cmd in cmd_list:
        status, output = subprocess.getstatusoutput(cmd)
        if status != 0:
            print(output)


def main():
    dir_path = sys.argv[1]
    date_to_filename_list = get_date_to_filename(dir_path)
    check_or_create_folder(date_to_filename_list.keys())
    move_file(date_to_filename_list)


if __name__ == "__main__":
    main()
