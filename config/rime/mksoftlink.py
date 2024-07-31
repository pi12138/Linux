#!/bin/env python3

import os 


class LinkFile:
    def __init__(self, src, dst):
        self.src = src
        self.dst = dst
    
    def __str__(self):
        return f"{self.dst} -> {self.src}"

    def __repr__(self):
        return self.__str__()
    
    def exec(self):
        os.system(f"ln -sf {self.src} {self.dst}")

def main():
    current_dir = os.path.abspath('.')
    dst_dir = os.path.join(os.path.expanduser("~"), ".config/ibus/rime")
    
    filename_list = os.listdir(current_dir)
    linkfile_list = []
    for filename in filename_list:
        if filename.endswith("custom.yaml") is False:
            continue
        linkfile_list.append(LinkFile(
            os.path.join(current_dir, filename),
            os.path.join(dst_dir, filename)
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