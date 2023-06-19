#!/bin/bash

set -e

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root (or with sudo)" 
    exit 1
fi

install_user=$1
if [ -z "$install_user" ]; then
    echo "need input username"
    echo "example: sudo ./install_docker_ubuntu.sh username"
    exit 1
fi

curl -fsSL get.docker.com -o get-docker.sh
/bin/sh get-docker.sh --mirror Aliyun

systemctl enable docker
systemctl start docker
groupadd docker
usermod -aG docker $install_user