#!/bin/bash

# 定义工作端口
PORT=4000

# 查找并杀掉之前的进程
PID=$(lsof -t -i:$PORT)

if [ -n "$PID" ]; then
    echo "Killing process $PID running on port $PORT..."
    kill -9 $PID
    echo "Process $PID killed."
else
    echo "No process found running on port $PORT."
fi

# 重新启动进程
echo "Starting the server..."
npm run server &

echo "Server restarted successfully."
