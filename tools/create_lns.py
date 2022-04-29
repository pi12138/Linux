#!/usr/bin/env python3

"""
快速创建软连接

usage:
    create_lns from_filename to_path [to_filename]
"""

import sys
import subprocess


def main():
    if len(sys.argv) not in [3, 4]:
        raise Exception('参数数量错误')

    from_filename, to_path = sys.argv[1], sys.argv[2]
    if len(sys.argv) == 4:
        to_filename = sys.argv[3]
    else:
        to_filename = from_filename
    
    _, from_path = subprocess.getstatusoutput('pwd')
    code, output = subprocess.getstatusoutput(
        f'sudo ln -s {from_path}/{from_filename} {to_path}/{to_filename}'
    )
    print(code, output)
    

main()
