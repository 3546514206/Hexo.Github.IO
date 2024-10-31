#!/bin/bash

# 定义颜色
RED='\033[0;31m'       # 错误信息
GREEN='\033[0;32m'     # 成功信息
YELLOW='\033[0;33m'    # 一般信息
BLUE='\033[0;34m'      # 日志级别
CYAN='\033[0;36m'      # 时间戳
NC='\033[0m'           # 无色

# 获取当前时间戳
log_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# 定义日志输出函数
log() {
    printf "[${CYAN}%-19s${NC}] [${YELLOW}%6d${NC}] [${BLUE}%-7s${NC}] %s\n" "$(log_timestamp)" "$$" "INFO" "$1"
}

# 定义成功日志输出函数
log_success() {
    printf "[${CYAN}%-19s${NC}] [${YELLOW}%6d${NC}] [${GREEN}%-7s${NC}] %s\n" "$(log_timestamp)" "$$" "SUCCESS" "$1"
}

# 定义错误日志输出函数
log_error() {
    printf "[${CYAN}%-19s${NC}] [${YELLOW}%6d${NC}] [${RED}%-7s${NC}] %s\n" "$(log_timestamp)" "$$" "ERROR" "$1"
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
        log_success "Code updated successfully."
    else
        log_error "Failed to update code from remote repository."
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
    log_success "Process $PID killed successfully."
else
    log "No process found running on port $PORT."
fi

# 重新启动进程，并将其放到后台
log "Starting the server in the background..."
nohup npm run server > server.log 2>&1 &

# 将后台运行的任务从 shell 中移除
disown

# 检查服务是否成功启动
log "Checking if the service is running on port $PORT..."
MAX_RETRIES=99
RETRY_COUNT=0
SLEEP_INTERVAL=5

while (( RETRY_COUNT < MAX_RETRIES )); do
    if lsof -i:$PORT >/dev/null; then
        log_success "Service started on port $PORT successfully."
        break
    else
        log "Service not available yet, retrying in $SLEEP_INTERVAL seconds..."
        sleep $SLEEP_INTERVAL
        (( RETRY_COUNT++ ))
    fi
done

# 检查重试次数，确定服务状态
if (( RETRY_COUNT == MAX_RETRIES )); then
    log_error "Service failed to start on port $PORT after $(( MAX_RETRIES * SLEEP_INTERVAL )) seconds."
    exit 1
fi

# 每次重新拉取之后都需要更新脚本的执行权限
chmod 777 ./restart.sh
# log_success "The execution permission for restart.sh has been changed."
