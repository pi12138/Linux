#!/bin/bash

# learn test command


var1=""
var2="word" 

# 借助test判断变量中是否有内容
if test $var1
then
		echo "run then $var1"
else
		echo "run else $var1"
fi

if test $var2
then
		echo "run then $var2"
else
		echo "run else $var2"
fi


# 数值比较
if [ 2 -gt 1 ]
then 
		echo "2 > 1"
else
		echo "error"
fi


# 字符串比较
if [ "word" = "word" ]
then
		echo "word"
else
		echo "error"
fi

path=$(pwd)

# 文件比较
if [ -d $path ]
then
		echo "$path"
else
		echo "error"
fi


if [ -e $path ] && [ -d $path ]
then
		echo "$path存在且为一个目录"
else
		echo "$path不存在或者不是一个目录"
fi
