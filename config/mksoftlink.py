#!/bin/env python3

import os 
from typing import List
import subprocess

def run_command(command):
    try:
        # 调用系统命令
        result = subprocess.run(
            command,
            stdout=subprocess.PIPE,   # 捕获标准输出
            stderr=subprocess.PIPE,   # 捕获标准错误
            text=True,                # 返回字符串而不是字节
            check=True                # 如果命令返回非零值，则抛出异常
        )
        return result.stdout, result.stderr, result.returncode
    except subprocess.CalledProcessError as e:
        # 捕获错误并返回输出和错误信息
        return e.stdout, e.stderr, e.returncode

class Config:
    def __init__(self, src_dir, dst_dir):
        self.src_dir = src_dir
        self.dst_dir = dst_dir


CUR_DIR = os.path.abspath('.')
ZELLIJ = Config(
    os.path.join(CUR_DIR, "zellij"),
    os.path.join(os.path.expanduser("~"), ".config/zellij")
)
HELIX = Config(
    os.path.join(CUR_DIR, "helix"),
    os.path.join(os.path.expanduser("~"), ".config/helix")
)
ALACRITTY = Config(
    os.path.join(CUR_DIR, "alacritty"),
    os.path.join(os.path.expanduser("~"), ".config/alacritty")
)


class LinkFile:
    def __init__(self, src, dst):
        self.src = src
        self.dst = dst
    
    def __str__(self):
        return f"{self.dst} -> {self.src}"

    def __repr__(self):
        return self.__str__()
    
    def exec(self):
        stdout, stderr, returncode = run_command(["ln", "-s", self.src, self.dst])
        if returncode != 0:
            print(stdout)
            print(stderr)

NUMBER_TO_CFG = {
    1: ZELLIJ,
    2: HELIX,
    3: ALACRITTY,
}

def main():
    print("请输入要建立软连接的应用:\n\t1.zellij\n\t2.helix\n\t3.alacritty\n")
    numbers = input("输入编号(多个编号用逗号分割): ")

    list_config: List[Config] = []
    for number in numbers.split(","):
        list_config.append(NUMBER_TO_CFG[int(number)])
    
    linkfile_list: List[str] = []
    for cfg in list_config:
        linkfile_list.append(LinkFile(
            cfg.src_dir,
            cfg.dst_dir
        ))
    
    print(f"即将生成 {len(linkfile_list)} 个软链接")
    for i in linkfile_list:
        print("\t", i)
    inp = input("是否继续(输入yes继续):")
    if inp.lower() == "yes":
        for i in linkfile_list:
            i.exec()

if __name__ == "__main__":
    main()