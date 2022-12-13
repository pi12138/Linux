#!/usr/bin/env bash
# 添加一个开发者帐号，具有root权限（centos）

set -e

if [ "$(whoami)" = "root" ]; then
    echo "当前是root用户"
else
    echo "该脚本必须以root用户身份执行"
    exit
fi


DEFAULT_USER_NAME="dev"
if [ "$1" ]; then
    USER_NAME=$1
else
    USER_NAME=$DEFAULT_USER_NAME
fi

echo "即将创建用户$USER_NAME"

adduser $USER_NAME
passwd $USER_NAME

chmod u+w /etc/sudoers
echo "$USER_NAME    ALL=(ALL)   NOPASSWD:ALL" >> /etc/sudoers
chmod u-w /etc/sudoers

