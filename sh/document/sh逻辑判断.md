# sh逻辑判断

## if-then

- 命令格式
- ```
	if command
	then 
		commands
	fi	
  ```
- 执行流程：
	- 如果if后面的命令执行成功（退出状态码为0)则执行then和fi中间的语句
	- shell命令执行成功后退出状态码为0，可以使用`$?`查看
- 也可以这样写
- ```
	if command; then
		commands
	fi
  ```
- if 后面的命令出现问题会输出这个问题，但是这个脚本并不会终止

## if-then-else

- 命令格式
- ```
	if command
	then 
		commands
	else
		commands
	fi
  ```

## if-then-elif-then-else

- 命令格式：
- ```
	if command1
	then 
 		commands
	elif command2
	then 
		more commands
	fi 
  ```
