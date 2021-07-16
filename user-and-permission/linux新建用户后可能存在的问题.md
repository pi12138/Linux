# linux新建用户后可能存在的问题

## 执行useradd命令后未在/home目录下生成新用户的文件夹

- 单纯的使用`useradd new_user`创建新的用户后是不会默认生成用户文件夹的
- 执行`useradd -m new_user`

## 新建用户后，新用户没有shell命令的自动补全

- 使用root用户查看文件`/etc/passwd`
- 在该文件中找到新建的用户
- 会发现新建的用户默认启动shell为`/bin/sh`
- 将其改为`/bin/bash`

## 新建用户后，新用户无法使用sudo命令

- 使用root用户赋予文件`/etc/sudoers`文件读写权限
- 在文件中添加`new_user    ALL=(ALL:ALL) ALL`(具体写法可以参照文件中其他用户写法)
- 保存写入的内容
- 撤销文件的写权限