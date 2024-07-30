# 用户相关命令

## 新建用户

- `useradd -m username` 创建一个名为 username 的账户，且为其在 `/home` 目录下新建用户目录文件夹

## 设置密码

- `passwd username` 为 username 这个用户设置密码，接下来需要输入两次密码

## 批量设置用户密码

- `echo 用户名:密码 | chpasswd`
- `chpasswd < password.txt`
- `password.txt` 文件内容格式应该为 `用户名:密码`

## 删除用户

- `userdel -r username` 删除一个用户且,删除其 Home 目录

## 添加用户到组

- `usermod -aG sudo {username}` 添加用户到 `sudo` 组
- centos 的 sudo 组名叫 wheel

## 查看当前用户所处组

- `groups {username}`