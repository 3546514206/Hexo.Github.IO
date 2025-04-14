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

log_success() {
    printf "[${CYAN}%-19s${NC}] [${YELLOW}%6d${NC}] [${GREEN}%-7s${NC}] %s\n" "$(log_timestamp)" "$$" "SUCCESS" "$1"
}

log_error() {
    printf "[${CYAN}%-19s${NC}] [${YELLOW}%6d${NC}] [${RED}%-7s${NC}] %s\n" "$(log_timestamp)" "$$" "ERROR" "$1"
}

# 更新代码的函数
update_code() {
    log "Starting to update code..."
    log "Discarding local changes..."

    git reset --hard           # 重置所有未提交的更改
    git clean -fd              # 删除未跟踪的文件和文件夹

    log "Pulling latest changes from remote repository..."
    if git pull origin main; then
        log_success "Code updated successfully."
    else
        log_error "Failed to update code from remote repository."
        exit 1
    fi
}

# 杀掉指定端口的进程
kill_process_on_port() {
    local port=$1
    PID=$(lsof -t -i:$port)

    if [ -n "$PID" ]; then
        log "Killing process $PID running on port $port..."
        kill -9 $PID
        log_success "Process $PID killed successfully."
    else
        log "No process found running on port $port."
    fi
}

# 启动服务并放到后台
start_service() {
    log "Starting the server in the background..."
    nohup npm run server > server.log 2>&1 &
    disown
    log_success "Server started in the background with output redirected to server.log"
}

# 检查服务是否在指定端口上成功启动
check_service() {
    local port=$1
    local max_retries=$2
    local sleep_interval=$3
    local retry_count=0

    log "Checking if the service is running on port $port..."
    while (( retry_count < max_retries )); do
        if lsof -i:$port >/dev/null; then
            log_success "Service started on port $port successfully."
            return 0
        else
            log "Service not available yet, retrying in $sleep_interval seconds..."
            sleep $sleep_interval
            (( retry_count++ ))
        fi
    done

    log_error "Service failed to start on port $port after $(( max_retries * sleep_interval )) seconds."
    return 1
}

# 更新脚本的执行权限
update_script_permission() {
    chmod 777 ./restart.sh
#    log_success "The execution permission for restart.sh has been changed."
}

# 进入工作目录
cd_workspace(){
  cd '/home/setsunayang/Documents/Github/Hexo.Github.IO/' || exit
}

# 主函数
main() {
    # 定义工作端口和重试参数
    local port=4000
    local max_retries=99
    local sleep_interval=5

    cd_workspace

    # 更新代码
    update_code

    # 杀掉在指定端口运行的进程
    kill_process_on_port $port

    # 启动服务
    start_service

    # 检查服务是否成功启动
    if ! check_service $port $max_retries $sleep_interval; then
        exit 1
    fi

    # 更新脚本的执行权限
    update_script_permission
}

# 调用主函数
main
