# chewy-storefront

PawShop 前台商城（北美宠物用品独立站）

## 技术栈

- Vue 3 + Vite 5
- Vue Router 4（History 模式）
- Pinia（购物车 / 结算状态）
- Element Plus（UI 组件）
- Axios（API 请求）

## 页面路由

| 路由 | 页面 |
|------|------|
| `/` | 首页 |
| `/products` | 商品列表（支持分页/搜索/筛选） |
| `/product/:id` | 商品详情 |
| `/cart` | 购物车 |
| `/checkout/shipping` | 结算 Step1：配送地址 |
| `/checkout/delivery` | 结算 Step2：配送方式 |
| `/checkout/payment` | 结算 Step3：支付 |
| `/order/confirm/:id` | 订单确认 |
| `/account` | 用户中心 |

## 开发

```bash
npm install
npm run dev        # http://localhost:5173
npm run build      # 生产构建 → dist/
```

## 环境变量

- `.env.development` → `VITE_API_BASE_URL=http://localhost:8080`
- `.env.production`  → `VITE_API_BASE_URL=http://47.238.64.8:8080`

## 部署

参考 `DEPLOY.md`（Nginx 端口 80）
