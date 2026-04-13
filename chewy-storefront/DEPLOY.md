# Nginx Deployment Guide

## chewy-storefront（前台商城 - 端口 80）

```nginx
server {
    listen 80;
    server_name _;

    root /var/www/chewy-storefront;
    index index.html;

    # Vue Router history mode
    location / {
        try_files $uri $uri/ /index.html;
    }

    # API 代理（可选，避免跨域）
    location /api/ {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    gzip on;
    gzip_types text/plain text/css application/json application/javascript;
}
```

### 部署步骤

```bash
# 在服务器上执行
cd /var/www
git clone https://github.com/puhuisifang-svg/chewy-pet-ecommerce.git
cd chewy-pet-ecommerce/chewy-storefront
npm install
npm run build
cp -r dist/* /var/www/chewy-storefront/
```

---

## chewy-admin（管理后台 - 端口 9000）

```nginx
server {
    listen 9000;
    server_name _;

    root /var/www/chewy-admin;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    gzip on;
    gzip_types text/plain text/css application/json application/javascript;
}
```

### 部署步骤

```bash
cd chewy-pet-ecommerce/chewy-admin
npm install
npm run build
cp -r dist/* /var/www/chewy-admin/
```
