# chewy-admin

PawShop 管理后台

## 技术栈

- Vue 3 + Vite 5
- Vue Router 4
- Pinia
- Element Plus
- Axios

## 功能模块

| 模块 | 功能 |
|------|------|
| Dashboard | KPI 统计 + 近期订单 |
| 商品管理 | 新增/编辑/启用禁用商品 |
| 库存管理 | 快速调整库存数量 |
| 订单管理 | 查看/更新订单状态 |

## 开发

```bash
npm install
npm run dev        # http://localhost:9000
npm run build      # 生产构建 → dist/
```

## 环境变量

- `.env.development` → `VITE_API_BASE_URL=http://localhost:8080`
- `.env.production`  → `VITE_API_BASE_URL=http://47.238.64.8:8080`

## 部署

Nginx 监听端口 9000，参考 chewy-storefront/DEPLOY.md
