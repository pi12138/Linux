#!/bin/bash

## 这个脚本是为了当不希望将 C 盘完全挂载到 WSL2 中,且又想使用 vscode wsl 插件时使用
## /etc/wsl.conf:
## [automount]
## enabled=false
## mountFsTab=true
##
## usage:
## sudo ./add_fstab_mount.sh C:/Users/username


if [ $# -ne 1 ]; then
  echo "Usage: sudo $0 <WindowsUserProfilePath>"
  echo "Example: sudo $0 C:/Users/username"
  exit 1
fi

WIN_USER_PATH="$1"

# 两个要挂载的 Windows 路径
SRC1="$WIN_USER_PATH/.vscode/extensions"
SRC2="$WIN_USER_PATH/vscode-remote-wsl"

# WSL 中挂载点路径，假设挂载到 /mnt/c/ 下对应目录
DST1="/mnt/c/${WIN_USER_PATH#C:/}/.vscode/extensions"
DST2="/mnt/c/${WIN_USER_PATH#C:/}/vscode-remote-wsl"

# 替换路径中的反斜杠（如果有）
SRC1="${SRC1//\\//}"
SRC2="${SRC2//\\//}"

# 挂载选项
MOUNT_TYPE="drvfs"
OPTIONS="defaults,ro"

FSTAB="/etc/fstab"

function add_entry() {
  local src="$1"
  local dst="$2"
  local entry="$src $dst $MOUNT_TYPE $OPTIONS 0 0"

  if grep -Fq "$entry" "$FSTAB"; then
    echo "挂载条目已存在: $entry"
  else
    echo "添加挂载条目: $entry"
    echo -e "\n# Added by add_fstab_mount.sh" | tee -a "$FSTAB" >/dev/null
    echo "$entry" | tee -a "$FSTAB" >/dev/null
  fi
}

# 主目录中对应的 /mnt/c/ 路径，去除前缀改写为小写并替换斜杠（保证路径正确）
function convert_path() {
  local p="$1"
  # 去掉开头的 C:/，转小写
  local np="${p#C:/}"
  np=$(echo "$np" | tr 'A-Z' 'a-z' | sed 's|\\|/|g')
  echo "$np"
}

# 重新计算目标路径
DST1="/mnt/c/$(convert_path "$SRC1")"
DST2="/mnt/c/$(convert_path "$SRC2")"

# 创建目标目录（必要时）
mkdir -p "$DST1"
mkdir -p "$DST2"

add_entry "$SRC1" "$DST1"
add_entry "$SRC2" "$DST2"

echo "完成！现在退出 WSL, 然后执行 wsl --shutdown 后重新启动 WSL"
