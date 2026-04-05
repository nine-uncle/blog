# Hexo `public/` 静态资源部署到服务器指南

本文档用于将 Hexo 构建产物（`public/`）部署到 Linux 服务器，并通过 Nginx 对外提供访问。

## 1. 目标说明

当前项目中：

- `pnpm run build` 实际执行的是 `hexo generate`
- 生成产物目录为 `public/`

部署目标是：将 `public/` 上传到服务器目录（例如 `/var/www/note`），并由 Nginx 提供 HTTP/HTTPS 访问。

---

## 2. 前置条件

请确保以下条件满足：

- 一台可用 Linux 服务器（Ubuntu/CentOS）
- 服务器有公网 IP
- 本地可通过 SSH 登录服务器（账号+密码或密钥）
- 可选：已购买并解析到服务器的域名
- 服务器开放端口：`22`（SSH）、`80`（HTTP）、`443`（HTTPS）

---

## 3. 本地构建静态文件

在项目根目录执行：

```bash
pnpm install
pnpm run clean
pnpm run build
```

执行完成后，确认 `public/` 目录存在且内容已更新。

---

## 4. 服务器安装 Nginx（Ubuntu 示例）

SSH 登录服务器后执行：

```bash
sudo apt update
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```

检查 Nginx 状态：

```bash
systemctl status nginx
```

---

## 5. 创建站点目录并上传 `public/`

### 5.1 服务器创建部署目录

```bash
sudo mkdir -p /var/www/note
sudo chown -R $USER:$USER /var/www/note
```

### 5.2 本地上传构建产物（推荐 `rsync`）

在**本地项目目录**执行：

```bash
rsync -avz --delete ./public/ user@SERVER_IP:/var/www/note/
```

参数说明：

- `--delete`：保持远端目录与本地 `public/` 一致，删除远端多余文件
- `user`：你的服务器登录用户名
- `SERVER_IP`：服务器公网 IP

如果你更习惯 `scp`：

```bash
scp -r ./public/* user@SERVER_IP:/var/www/note/
```

---

## 6. 配置 Nginx 站点

创建配置文件：

```bash
sudo nano /etc/nginx/sites-available/note
```

写入以下内容（`server_name` 可先填 IP，后续再换域名）：

```nginx
server {
    listen 80;
    server_name your_domain_or_ip;

    root /var/www/note;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # 静态资源缓存（可选）
    location ~* \.(js|css|png|jpg|jpeg|gif|svg|ico|woff|woff2)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

启用站点：

```bash
sudo ln -s /etc/nginx/sites-available/note /etc/nginx/sites-enabled/note
```

可选：关闭默认站点，避免冲突：

```bash
sudo rm -f /etc/nginx/sites-enabled/default
```

检查并重载：

```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## 7. 验证访问

浏览器访问：

- `http://SERVER_IP`
- 或 `http://your_domain`

若能打开博客首页，说明部署成功。

---

## 8. 配置 HTTPS（推荐）

当你已经有域名并完成解析后，使用 Let’s Encrypt：

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d your_domain -d www.your_domain
```

验证自动续期：

```bash
sudo certbot renew --dry-run
```

---

## 9. 后续发布流程（每次更新）

每次博客内容更新后执行：

1. 本地重新构建

```bash
pnpm run clean && pnpm run build
```

2. 同步到服务器

```bash
rsync -avz --delete ./public/ user@SERVER_IP:/var/www/note/
```

说明：纯静态文件更新通常不需要重启 Nginx。

---

## 10. 常见问题排查

### 10.1 出现 403/404

检查站点目录和权限：

```bash
sudo chown -R www-data:www-data /var/www/note
sudo find /var/www/note -type d -exec chmod 755 {} \;
sudo find /var/www/note -type f -exec chmod 644 {} \;
```

### 10.2 Nginx 配置不生效

```bash
sudo nginx -t
sudo systemctl reload nginx
```

### 10.3 域名无法访问

- 检查 DNS A 记录是否指向服务器公网 IP
- 检查云防火墙/安全组是否放行 80/443

### 10.4 页面内容未更新

- 浏览器强制刷新（`Ctrl/Cmd + Shift + R`）
- 确认 `rsync` 执行成功并实际覆盖了远端文件

---

## 11. 可选：本地一键部署命令

可在本地使用如下命令一键完成构建+上传：

```bash
pnpm run clean && pnpm run build && rsync -avz --delete ./public/ user@SERVER_IP:/var/www/note/
```

后续可再封装为 `package.json` 的脚本命令，提升发布效率。
