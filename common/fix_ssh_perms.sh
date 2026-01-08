#!/bin/bash
# fix_ssh_perms.sh
# 检查并修复 ~/.ssh 下文件权限

SSH_DIR="$HOME/.ssh"

if [ ! -d "$SSH_DIR" ]; then
    echo "$SSH_DIR 不存在"
    exit 1
fi

echo "检查并修复 $SSH_DIR 下的权限..."

# 1. 目录本身
chmod 700 "$SSH_DIR"
echo "设置 $SSH_DIR 为 700"

# 2. 公钥文件 (*.pub)
find "$SSH_DIR" -type f -name "*.pub" -exec chmod 644 {} \; -exec echo "设置 {} 为 644" \;

# 3. 私钥文件（排除 *.pub）
find "$SSH_DIR" -type f ! -name "*.pub" -exec chmod 600 {} \; -exec echo "设置 {} 为 600" \;

# 4. authorized_keys 和 config
for file in authorized_keys config; do
    if [ -f "$SSH_DIR/$file" ]; then
        chmod 600 "$SSH_DIR/$file"
        echo "设置 $SSH_DIR/$file 为 600"
    fi
done

echo "检查完成！"

