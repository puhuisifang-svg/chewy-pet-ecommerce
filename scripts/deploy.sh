#!/bin/bash
# ============================================================
# Chewy Pet - Sprint 2 一键部署脚本
# 用法：bash deploy.sh [up|down|restart|status|logs]
# ============================================================

set -e

COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"
PROJECT="chewy"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_env() {
    if [ ! -f "$ENV_FILE" ]; then
        log_warn ".env 文件不存在，从 .env.example 复制..."
        cp .env.example .env
        log_error "请编辑 .env 文件填写真实配置后重新运行"
        exit 1
    fi
    # 检查必填变量
    source "$ENV_FILE"
    [ -z "$STRIPE_SECRET_KEY" ] && log_error "STRIPE_SECRET_KEY 未配置" && exit 1
    [ -z "$MYSQL_ROOT_PASSWORD" ] && log_error "MYSQL_ROOT_PASSWORD 未配置" && exit 1
    log_info "环境变量检查通过"
}

pull_latest() {
    log_info "拉取最新代码..."
    git pull origin develop
    log_info "代码已更新至: $(git log --oneline -1)"
}

build_images() {
    log_info "构建所有服务镜像..."
    docker compose -f "$COMPOSE_FILE" build --parallel
    log_info "镜像构建完成"
}

deploy_up() {
    log_info "启动所有服务..."
    docker compose -f "$COMPOSE_FILE" up -d
    log_info "等待服务健康检查..."
    sleep 20
    status
}

deploy_down() {
    log_warn "停止所有服务..."
    docker compose -f "$COMPOSE_FILE" down
}

deploy_restart() {
    deploy_down
    deploy_up
}

status() {
    log_info "服务状态："
    docker compose -f "$COMPOSE_FILE" ps
}

show_logs() {
    SERVICE=${2:-""}
    docker compose -f "$COMPOSE_FILE" logs -f --tail=100 $SERVICE
}

verify() {
    log_info "验证服务可用性..."
    echo ""
    # 前台
    STOREFRONT=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/ 2>/dev/null)
    [ "$STOREFRONT" = "200" ] && echo -e "  ${GREEN}✅${NC} 前台商城 http://47.238.64.8       → HTTP $STOREFRONT" \
                               || echo -e "  ${RED}❌${NC} 前台商城 http://47.238.64.8       → HTTP $STOREFRONT"
    # 管理后台
    ADMIN=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9000/ 2>/dev/null)
    [ "$ADMIN" = "200" ] && echo -e "  ${GREEN}✅${NC} 管理后台 http://47.238.64.8:9000  → HTTP $ADMIN" \
                          || echo -e "  ${RED}❌${NC} 管理后台 http://47.238.64.8:9000  → HTTP $ADMIN"
    # API Gateway
    GATEWAY=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/actuator/health 2>/dev/null)
    echo -e "  Gateway  http://localhost:8080       → HTTP $GATEWAY"
    # Nacos
    NACOS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos 2>/dev/null)
    echo -e "  Nacos    http://localhost:8848/nacos → HTTP $NACOS"
    echo ""
}

case "${1:-up}" in
    up)       check_env && pull_latest && build_images && deploy_up && verify ;;
    down)     deploy_down ;;
    restart)  check_env && pull_latest && build_images && deploy_restart && verify ;;
    status)   status ;;
    verify)   verify ;;
    logs)     show_logs "$@" ;;
    build)    check_env && build_images ;;
    *)        echo "用法: $0 [up|down|restart|status|verify|logs|build]" ;;
esac
