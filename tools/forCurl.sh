#!/bin/bash

for ((i=0; i<$1; i++))
do
    curl http://10.1.117.7:7777/home
    echo "Hello World-" | nc 10.1.117.7 10100
done
