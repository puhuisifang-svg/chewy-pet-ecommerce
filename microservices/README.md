# Chewy Pet - 微服务架构 (Sprint 2)

## 模块说明

| 模块 | 端口 | 职责 |
|------|------|------|
| chewy-gateway | 8080 | API 网关，路由分发，Nacos 动态路由 |
| chewy-user-service | 8081 | 用户注册/登录/地址管理 |
| chewy-product-service | 8082 | 商品/分类/库存管理（含BUG-002修复） |
| chewy-order-service | 8083 | 订单创建/查询/取消，Feign调product/cart |
| chewy-payment-service | 8084 | Stripe支付，Feign调order更新状态 |
| chewy-cart-service | 8085 | 购物车管理，提供内部清空接口 |
| chewy-admin-service | 8086 | 管理后台（订单/商品管理） |
| chewy-common | - | 公共库（Result/异常/JwtUtil/实体基类） |

## 快速启动

### 1. 启动基础设施
```bash
cd docker
docker-compose -f docker-compose-infra.yml up -d
```

### 2. 访问 Nacos 控制台
http://localhost:8848/nacos
默认账号：nacos/nacos

### 3. 启动各服务（开发模式）
```bash
cd microservices
mvn clean install -DskipTests

# 各服务独立启动
cd chewy-gateway && mvn spring-boot:run
cd chewy-user-service && mvn spring-boot:run
# ... 以此类推
```

## 服务间调用（OpenFeign）

```
前端 → Gateway(8080) → 各服务

order-service → [Feign] → product-service (扣减库存)
order-service → [Feign] → cart-service (清空购物车)
payment-service → [Feign] → order-service (更新订单支付状态)
```

## 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| NACOS_SERVER | 127.0.0.1:8848 | Nacos 地址 |
| MYSQL_HOST | localhost | MySQL 地址 |
| MYSQL_USER | root | MySQL 用户 |
| MYSQL_PASSWORD | root123 | MySQL 密码 |
| REDIS_HOST | localhost | Redis 地址 |
