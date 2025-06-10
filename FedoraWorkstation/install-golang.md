# 安装 golang

- 不选择使用包管理器，直接去官网下载安装

## Download

- `wget https://go.dev/dl/go1.24.4.linux-amd64.tar.gz`

## Install

- `sudo rm -rf /usr/local/go && sudo tar -xzvf go1.24.4.linux-amd64.tar.gz -C /usr/local`
- `sudo ln -sf /usr/local/go/bin/go /usr/bin/go && sudo ln -sf /usr/local/go/bin/gofmt /usr/bin/gofmt`


## Proxy

- `go env -w GO111MODULE=on && go env -w GOPROXY=https://goproxy.cn,direct` 