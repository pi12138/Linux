# sh数学计算

- 在shell编程中可以使用expr命令或者[]中括号进行数学计算

## expr命令

- expr 1 + 5

- 注意：某些符号expr命令不支持，使用是会出现问题，需要在运算符前加上反斜杠\进行转义，比如说乘号*

## []方括号

- [ operation ]
- 方括号执行shell比expr命令方便
- 使用方括号来计算公式，不用担心shell会误解其他符号
- bash shell数学运算符只支持整数运算
- z shell 提供了完整的浮点数运算操作

## bash shell 浮点数解决方案

- `variable=$(echo "options; expression" | bc)`
- `option`部分可以设置变量
- `expression`部分可以定义数学表达式
- 这种方式执行简单的浮点数计算还较为容易，如果要执行多个表达式可以使用下面这种方式

- `variable=$(bc << EOF 
   options 
   statements 
   expressions 
   EOF 
   ) 
  `
