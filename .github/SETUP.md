# GitHub Actions - 所需 Secrets 配置

在仓库 Settings → Secrets and variables → Actions 中添加以下 Secrets：

| Secret 名称 | 值 | 说明 |
|------------|-----|------|
| `SSH_PRIVATE_KEY` | （见下方生成步骤） | 部署用 SSH 私钥 |
| `SERVER_HOST` | `47.238.64.8` | 服务器 IP |
| `SERVER_USER` | `root` | 服务器用户名 |

## 生成 SSH 密钥对

```bash
# 本地生成部署专用密钥
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/chewy_deploy -N ""

# 将公钥加入服务器
ssh-copy-id -i ~/.ssh/chewy_deploy.pub root@47.238.64.8

# 查看私钥（复制内容到 SSH_PRIVATE_KEY secret）
cat ~/.ssh/chewy_deploy
```

## 服务器端一次性配置

```bash
# 登录服务器，在 authorized_keys 中添加公钥
ssh root@47.238.64.8
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo "<粘贴公钥内容>" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## 流水线触发方式

- **自动触发**: push 到 develop 分支
- **PR 检查**: 向 main 或 develop 发起 PR 时触发 Build（不部署）
