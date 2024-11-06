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

    # 丢弃本地的未提交更改
    log "Discarding local changes..."
    git reset --hard
    git clean -fd

    # 拉取远程仓库的最新代码
    log "Pulling latest changes from remote repository..."
    if git pull origin main; then
        log_success "Code updated successfully."
    else
        log_error "Failed to update code from remote repository."
        exit 1
    fi
}

# 定义杀进程的函数
kill_process() {
    local port=$1
    PID=$(lsof -t -i:$port)

    if [ -n "$PID" ]; then
        log "Killing the builder process $PID running on port $port..."
        kill -9 $PID
        log_success "Builder process $PID killed successfully."
    else
        log "No builder process found running on port $port."
    fi
}

# 定义服务检查的函数
check_builder() {
    local port=$1
    local max_retries=$2
    local sleep_interval=$3
    local retry_count=0

    log "Checking if any builder process is running on port $port..."

    while (( retry_count < max_retries )); do
        if lsof -i:$port >/dev/null; then
            log_success "Builder process started on port $port successfully."
            return 0
        else
            log "Builder process not available yet, retrying in $sleep_interval seconds..."
            sleep $sleep_interval
            (( retry_count++ ))
        fi
    done

    log_error "Builder process failed to start on port $port after $(( max_retries * sleep_interval )) seconds."
    return 1
}

# 定义启动服务的函数
start_builder() {
    local log_file=$1

    log "Starting the builder process in the background..."
    nohup npm run server > "$log_file" 2>&1 &
    disown
    log_success "Builder process started in the background with output redirected to $log_file"
}

# 部署 Nginx 静态文件的函数
deploy_nginx() {
    local src_dir="/opt/Hexo.Github.IO/public/*"
    local dest_dir="/var/www/x.vip.cpolar.top"

    log "Deleting existing files in $dest_dir..."
    rm -rf "${dest_dir:?}/"*
    log_success "Old files in $dest_dir deleted successfully."

    log "Moving new static files from $src_dir to $dest_dir..."
    if mv $src_dir $dest_dir; then
        log_success "New static files moved to $dest_dir successfully."
    else
        log_error "Failed to move files to $dest_dir."
        exit 1
    fi

    log "Setting permissions for $dest_dir..."
    chmod -R 755 "$dest_dir"
    log_success "Permissions set for $dest_dir."
}

# 检查 Nginx 是否正常工作
check_nginx() {
    local port=8080
    local max_retries=10
    local sleep_interval=5
    local retry_count=0

    log "Checking if Nginx is serving on port $port..."

    while (( retry_count < max_retries )); do
        response=$(curl -s "http://localhost:$port" | grep "杨海波")
        if [[ -n "$response" ]]; then
            log_success "Nginx is successfully serving the content on port $port."
            return 0
        else
            log "Nginx not serving expected content yet, retrying in $sleep_interval seconds..."
            sleep $sleep_interval
            (( retry_count++ ))
        fi
    done

    log_error "Nginx failed to serve expected content on port $port after $(( max_retries * sleep_interval )) seconds."
    return 1
}

# 主函数，调用各个步骤
main() {
    # 定义工作端口和日志文件
    local port=4000
    local log_file="server.log"
    local max_retries=99
    local sleep_interval=5

    # 更新代码
    update_code

    # 终止现有进程
    kill_process $port

    # 启动构建服务
    start_builder "$log_file"

    # 检查构建服务是否启动
    if ! check_builder $port $max_retries $sleep_interval; then
        exit 1
    fi

    # 等待一段时间后再次杀掉构建服务进程
    sleep $sleep_interval
    kill_process $port

    # 部署 Nginx 静态文件
    deploy_nginx

    # 检查 Nginx 是否正常工作
    if ! check_nginx; then
        exit 1
    fi

    # 更新脚本的执行权限
    chmod 777 ./restart.sh
    log_success "Execution permission for restart.sh has been set."
}

# 调用主函数
main
