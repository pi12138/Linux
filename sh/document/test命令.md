# test命令

- test命令一般会和逻辑判断一起使用

## test命令

- 基本格式
- `test condition`
- condition 是test命令要测试的一系列的参数和值

- 和逻辑判断一起使用
- ```
	if test condition
	then
		commands
	fi
  ```
- 如果不写test命令的condition部分，它会以非0状态吗退出，并执行else语句块。

## 使用[]

- bash shell 提供[]来代替test
- 基本格式
- `[ condition ]`
- 两个方括号和条件之间的空格必须有，否则会报错

## test命令的主要作用

- 数值比较
- 字符串比较
- 文件比较

## 符合条件测试

- [ condition1 ] && [ condition2 ]	相当于and运算符
- [ condition1 ] || [ condition2 ]	相当于or运算符

## if-then高级特性

- bash shell提供了可以在if-then语句中使用的高级特性
- 用于数学表达式的双括号(( expression ))
- 用于高级字符串处理的双方括号[[ expression ]]

## case命令

- 命令格式
- ```
	case variable in 
	pattern1 | pattern2) commands1;; 
	pattern3) commands2;; 
	*) default commands;; 
	esac 
  ```



