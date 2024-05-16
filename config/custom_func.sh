# 定义了一些共用func

# func
function proxy_on() {
    export http_proxy=http://127.0.0.1:7890
    export https_proxy=$http_proxy
    echo -e "终端代理已开启。"
}

function proxy_off() {
    unset http_proxy https_proxy
    echo -e "终端代理已关闭。"
} 


CLASH_LOG_PATH="/tmp/clash.log"
CLASH_PID_PATH="/tmp/clash.pid"
CLASH_PID=0


function clash_open() {
    nohup clash > $CLASH_LOG_PATH 2>&1 &
	pid=$!
	echo $pid > $CLASH_PID_PATH
    echo "clash 已经启动. pid: $pid"
}

function clash_pid() {
	if [ -e $CLASH_PID_PATH ]; then
		echo "从 $CLASH_PID_PATH 中获取 pid"
		pid=$(cat $CLASH_PID_PATH)
	else
		echo "未找到 $CLASH_PID_PATH, 尝试使用端口号查找 clash pid"
		pid=`netstat -tuple | grep 7890 | awk '{print \$NF}' | awk -F '/' '{print \$1}' | tr '\n' ' ' | awk '{print \$1}'`
	fi
	CLASH_PID=$pid
	echo "clash pid: $CLASH_PID"
}


function clash_close() {
	clash_pid
	if [ -z $CLASH_PID ]; then
		echo "未找到 clash pid 无法关闭"
		return 0
	fi

	kill $CLASH_PID
	if [ -e $CLASH_PID_PATH ]; then
		rm $CLASH_PID_PATH
	fi
}
