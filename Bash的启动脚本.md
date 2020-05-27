# Bash的启动脚本

## Bash的几种模式

### 登陆式

- 即某个用户由/bin/login登陆进系统后启动的shell

### 非登陆式

- 不想要登陆而是由某些程序启动的shell.比如切换用户时; 或者执行/bin/bash时.

### 如何区分

- 输入echo $0, 如果输出的字符中前缀为"-", 表示登陆模式

## 登陆模式下Bash启动脚本的顺序

1. /etc/profile
2. /etc/profile调用/etc/profile.d下的所有脚本
3. 然后执行~/.bash_profile, ~/.bash_login, ~/.profile中的一个
4. ~/.bash_profile调用~/.bashrc
5. ~/.bashrc调用/etc/bashrc

## 非登陆模式下Bash启动脚本

1. 调用~/.bashrc
2. ~/.bashrc调用/etc/bashrc
3. /etc/bashrc调用/etc/profile.d目录下的脚本
