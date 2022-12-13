#!/usr/bin/env python3

import subprocess
import os

####################################
# 更新 win hosts 文件便于 win 访问 wsl2
####################################

WIN_HOSTS_FILE = "/mnt/c/Windows/System32/drivers/etc/hosts"
WSL2_IP = "ifconfig eth0 | grep -w inet | awk '{print $2}'"
DEFAULT_HOST = "wsl2"

def get_ip():
    code, output = subprocess.getstatusoutput(WSL2_IP)
    if code != 0:
        print(output)
        os._exit(1)
    return output


def main():
    ip = get_ip()
    ip_line = "{ip} wsl2\n".format(ip=ip)
    with open(WIN_HOSTS_FILE, "r") as f:
        lines = []
        exist = False
        for line in f.readlines():
            if line.find("wsl2") != -1:
                exist = True
                lines.append(ip_line)
            else:
                lines.append(line)
        
        if exist is False:
            lines.append(ip_line)
    
    with open(WIN_HOSTS_FILE, "w") as f:
        # print(lines)
        f.writelines(lines)


if __name__ == "__main__":
    main()