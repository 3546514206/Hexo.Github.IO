#!/bin/bash

# 获取当前时间戳
log_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# 定义日志输出函数
log() {
    echo "[INFO] [$(log_timestamp)] [$$] $1"
}

# 定义更新代码的函数
update_code() {
    log "Starting to update code..."

    # 丢弃本地的未提交更改
    log "Discarding local changes..."
    git reset --hard          # 重置所有未提交的更改
    git clean -fd             # 删除未跟踪的文件和文件夹

    # 拉取远程仓库的最新代码
    log "Pulling latest changes from remote repository..."
    if git pull origin main; then
        log "Code updated successfully."
    else
        log "Failed to update code from remote repository."
        exit 1
    fi
}

# 调用更新代码的函数
update_code

# 定义工作端口
PORT=4000

# 查找并杀掉之前的进程
PID=$(lsof -t -i:$PORT)

if [ -n "$PID" ]; then
    log "Killing process $PID running on port $PORT..."
    kill -9 $PID
    log "Process $PID killed."
else
    log "No process found running on port $PORT."
fi

# 重新启动进程，并将其放到后台
log "Starting the server in the background..."
nohup npm run server > server.log 2>&1 &

# 将后台运行的任务从 shell 中移除
disown

log "Server restarted successfully and running in the background."

# 每次重新拉取之后都需要更新脚本的执行权限
chmod 777 ./restart.sh
log "The execution permission for restart.sh has been changed."
