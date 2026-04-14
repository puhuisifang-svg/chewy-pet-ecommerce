#!/bin/bash
# ==============================================================
# Chewy Pet - 服务健康检查脚本
# 用途：检查所有服务运行状态，发现问题时输出详情
# ==============================================================

set -e

SERVER_HOST="${SERVER_HOST:-localhost}"
PASS=0
FAIL=0
WARN=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_http() {
  local name="$1"
  local url="$2"
  local expect_code="${3:-200}"

  STATUS=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 "$url" 2>/dev/null)
  if [ "$STATUS" = "$expect_code" ]; then
    echo -e "${GREEN}✅ $name${NC}: HTTP $STATUS ($url)"
    PASS=$((PASS + 1))
  elif [ "$STATUS" = "000" ]; then
    echo -e "${RED}❌ $name${NC}: 连接失败 ($url)"
    FAIL=$((FAIL + 1))
  else
    echo -e "${YELLOW}⚠️  $name${NC}: HTTP $STATUS (期望 $expect_code) ($url)"
    WARN=$((WARN + 1))
  fi
}

check_process() {
  local name="$1"
  local pattern="$2"
  if pgrep -f "$pattern" > /dev/null 2>&1; then
    local pid=$(pgrep -f "$pattern" | head -1)
    echo -e "${GREEN}✅ $name${NC}: 运行中 (PID $pid)"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}❌ $name${NC}: 进程不存在"
    FAIL=$((FAIL + 1))
  fi
}

check_docker() {
  local name="$1"
  local container="$2"
  if docker ps --format '{{.Names}}' 2>/dev/null | grep -q "^${container}$"; then
    local status=$(docker inspect --format='{{.State.Status}}' "$container" 2>/dev/null)
    local health=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "no-healthcheck")
    echo -e "${GREEN}✅ $name${NC}: $status ($health)"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}❌ $name${NC}: 容器未运行"
    FAIL=$((FAIL + 1))
  fi
}

check_port() {
  local name="$1"
  local port="$2"
  if ss -tlnp 2>/dev/null | grep -q ":${port} " || netstat -tlnp 2>/dev/null | grep -q ":${port} "; then
    echo -e "${GREEN}✅ $name${NC}: 端口 $port 监听中"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}❌ $name${NC}: 端口 $port 未监听"
    FAIL=$((FAIL + 1))
  fi
}

echo "============================================"
echo "  Chewy Pet 服务健康检查"
echo "  $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"
echo ""

echo "--- Docker 容器状态 ---"
check_docker "MySQL"    "chewy-mysql"
check_docker "Redis"    "chewy-redis"
check_docker "Nacos"    "chewy-nacos"
echo ""

echo "--- 进程状态 ---"
check_process "后端 Java"  "chewy-pet-backend.*\.jar"
check_process "Nginx"      "nginx: master"
echo ""

echo "--- 端口监听 ---"
check_port "MySQL"   "3306"
check_port "Redis"   "6379"
check_port "Nacos"   "8848"
check_port "Backend" "8080"
check_port "Nginx"   "80"
echo ""

echo "--- HTTP 接口检查 ---"
BASE="http://${SERVER_HOST}"
check_http "Nacos 健康"       "${BASE}:8848/nacos/v1/console/health/readiness"
check_http "后端商品接口"     "${BASE}:8080/api/products?page=1&size=1"
check_http "前台商城"         "${BASE}:80/"
check_http "管理后台"         "${BASE}:9000/"
echo ""

echo "--- 商品数据检查 ---"
PRODUCT_RESP=$(curl -s --connect-timeout 5 --max-time 10 "${BASE}:8080/api/products?page=1&size=1" 2>/dev/null)
if echo "$PRODUCT_RESP" | grep -q '"code":200'; then
  TOTAL=$(echo "$PRODUCT_RESP" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('data',{}).get('total','?'))" 2>/dev/null || echo "?")
  if [ "$TOTAL" -gt 10 ] 2>/dev/null; then
    echo -e "${GREEN}✅ 商品数据${NC}: 共 $TOTAL 条真实数据"
    PASS=$((PASS + 1))
  else
    echo -e "${YELLOW}⚠️  商品数据${NC}: 仅 $TOTAL 条，可能是Mock数据"
    WARN=$((WARN + 1))
  fi
else
  echo -e "${RED}❌ 商品数据${NC}: 接口无响应或报错"
  FAIL=$((FAIL + 1))
fi
echo ""

echo "--- 日志文件 ---"
LOG_DIR="/var/log/chewy"
if [ -d "$LOG_DIR" ]; then
  for f in "$LOG_DIR"/*.log; do
    [ -f "$f" ] || continue
    SIZE=$(du -sh "$f" 2>/dev/null | cut -f1)
    ERRORS=$(tail -100 "$f" 2>/dev/null | grep -c "ERROR\|Exception" || echo 0)
    if [ "$ERRORS" -gt 0 ]; then
      echo -e "${YELLOW}⚠️  $(basename $f)${NC}: $SIZE, 最近100行有 $ERRORS 个ERROR"
      WARN=$((WARN + 1))
    else
      echo -e "${GREEN}✅ $(basename $f)${NC}: $SIZE, 无ERROR"
      PASS=$((PASS + 1))
    fi
  done
else
  echo -e "${YELLOW}⚠️  日志目录 $LOG_DIR 不存在${NC}"
  WARN=$((WARN + 1))
fi
echo ""

echo "============================================"
TOTAL_CHECKS=$((PASS + FAIL + WARN))
echo "检查完成: 共 $TOTAL_CHECKS 项"
echo -e "  ${GREEN}通过: $PASS${NC}  ${RED}失败: $FAIL${NC}  ${YELLOW}警告: $WARN${NC}"
echo "============================================"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
