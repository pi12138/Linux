#!/usr/bin/env python3

"""
用来同步本地文件到远程, 使用 json 配置文件
"""


import json
import os
import subprocess
import sys


class Config:
    SOURCE_DIR = ''
    TARGET_DIR = ''


def get_diff_file_list():
    cmd = 'git diff master --name-only'
    status, output = subprocess.getstatusoutput(cmd)
    file_name_list = output.split('\n')
    return file_name_list


def get_config(config_file_path=None) -> Config:
    if config_file_path is None:
        config_file_path = './.rsync-config.json'

    with open(config_file_path, 'r') as f:
        data: dict = json.loads(f.read())

    config = Config()
    for key, value in data.items():
        setattr(config, key, value)
    return config


def main():
    rsync_cmd_list = []