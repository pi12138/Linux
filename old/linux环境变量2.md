# linux环境变量

## 环境变量

### 全局环境变量

- 使用 env 或 printenv 查看所有全局变量
- `printenv var_name` 打印指定变量内容
- `echo $var_name` 打印指定变量内容

### 局部环境变量

- set 命令会显示为某个特定进程设置的所有环境变量，包括局部变量、全局变量以及用户定义变量。

## 删除环境变量

- `unset var_name` 删除指定环境变量
