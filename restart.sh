#!/bin/bash

# 定义更新代码的函数，确保在调用之前已经定义
update_code() {
    echo "Starting to update code..."

    # 丢弃本地的未提交更改
    echo "Discarding local changes..."
    git reset --hard          # 重置所有未提交的更改
    git clean -fd             # 删除未跟踪的文件和文件夹

    # 拉取远程仓库的最新代码
    echo "Pulling latest changes from remote repository..."
    git pull origin main

    echo "Code updated successfully."
}

# 调用更新代码的函数
update_code

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

# 重新启动进程，并将其放到后台
echo "Starting the server in the background..."
nohup npm run server > server.log 2>&1 &

# 将后台运行的任务从 shell 中移除
disown

echo "Server restarted successfully and running in the background."

# 每次重新拉取之后都需要更新脚本的执行权限
chmod 777 ./restart.sh
echo "The execution permission for restart.sh has been changed."


