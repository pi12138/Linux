#!/usr/bin/env python3

"""
用来同步本地文件到远程, 使用 json 配置文件
"""


import json
import os
import subprocess
import sys


RSYNC_FORMAT = 'rsync -avr --exclude={{{exclude}}} {source} {target}'


class Config:
    SOURCE_DIR = './'  # 源目录
    TARGET_DIR = ''  # 目标目录
    EXCLUDE_RULES = ''  # 排除文件规则


class Rsync:
    def __init__(self, config, target_file):
        self.config = config
        self.target_file = target_file

    def run(self):
        source_file = f"{self.config.SOURCE_DIR.rstrip('/')}/{self.target_file}"
        target_file = f"{self.config.TARGET_DIR.rstrip('/')}/{self.target_file}"

        cmd = RSYNC_FORMAT.format(
            source=source_file,
            target=target_file,
            exclude=self.config.EXCLUDE_RULES
        )
        print(f'rsync file: {self.target_file}')
        status, output = subprocess.getstatusoutput(cmd)
        if status != 0:
            print(f'rsync error: {output}')


def get_diff_file_list():
    cmd = 'git diff master --name-only'
    status, output = subprocess.getstatusoutput(cmd)
    if status != 0:
        print(f'git diff error: {output}')
    file_name_list = output.split('\n')
    return file_name_list


def get_config(config_file_path=None) -> Config:
    if config_file_path is None:
        config_file_path = './.rsync-config.json'

    with open(config_file_path, 'r') as f:
        data: dict = json.loads(f.read())

    config = Config()
    for key, value in data.items():
        setattr(config, key.upper(), value)
    return config


def main():
    diff_file_list = get_diff_file_list()
    config = get_config()

    for file_name in diff_file_list:
        rsync = Rsync(config, file_name)
        rsync.run()


if __name__ == '__main__':
    main()
