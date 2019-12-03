#!/bin/bash
# learn if-then

if pwd
then
		echo "这是在then-fi之间的命令"
		a=$[1+5]
		echo $a
fi

if ls -al; then
		echo $(date)
fi

if aaa
then
		echo "if后面的命令有问题"
fi

echo "这是if之外的命令"

error

echo "error end"
