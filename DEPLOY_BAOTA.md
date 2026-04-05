# 使用宝塔面板部署本 Hexo 项目

本文档对应仓库根目录的 `package.json`：

- `pnpm run build` → 执行 `hexo generate`，**产出物在 `public/` 目录**
- `pnpm run clean` → `hexo clean`，清理缓存与旧生成文件
- `pnpm run dev` → 本地预览，**不用于线上**

线上访问只需要把 **`public/` 里的静态文件** 放到网站根目录，由 Nginx（宝塔已装）对外提供即可。

**不要用「Node 项目」来托管已构建的博客：** 宝塔里的 Node 项目会要求目录下有 `package.json`，用来启动 Node 进程；而 Hexo 上线是 **纯静态 HTML**，应走 **网站 → 添加站点（传统项目 / 纯静态）**，见下文「5.5」。

---

## 一、部署思路（选一种即可）

| 方式 | 说明 | 适合 |
|------|------|------|
| **方式 A：本地构建 + 上传** | 在你电脑上 `pnpm run build`，把 `public/` 上传到宝塔网站目录 | 最省事，推荐 |
| **方式 B：服务器上构建** | 代码推到 Git，服务器拉代码后执行 `pnpm install` 与 `pnpm run build` | 需要服务器装 Node，适合经常改文、不想本机打包 |

下面两种方式都会写；**新手优先用方式 A**。

---

## 二、前置准备

1. 已安装 **宝塔 Linux 面板** 的服务器（CentOS / Ubuntu / Debian 等均可）。
2. 宝塔 **软件商店** 中已安装 **Nginx**（静态站点必备）。
3. （可选）域名已解析到服务器公网 IP；宝塔 **安全** 里放行 **80、443** 端口。
4. 本地开发需已安装 **Node.js** 与 **pnpm**（方式 A 在本地构建时需要）。

本地构建命令摘要：

```bash
pnpm install
pnpm run clean
pnpm run build
```

构建完成后，项目根目录下会出现或更新 **`public/`** 文件夹，里面即为完整静态站。

---

## 三、方式 A：本地构建 + 宝塔部署（推荐）

### 3.1 在宝塔创建网站

1. 登录宝塔面板 → **网站** → **添加站点**。
2. **域名**：填你的域名（如 `blog.example.com`）；若暂时没有域名，可先填服务器 IP，后续再改。
3. **根目录**：记下默认路径，一般为  
   `/www/wwwroot/你的域名/`  
   （例如 `/www/wwwroot/blog.example.com/`）。
4. **PHP 版本**：纯静态可选 **纯静态** 或任意 PHP 版本均可（Hexo 不依赖 PHP）。
5. 提交创建站点。

### 3.2 上传 `public/` 内容到网站根目录

**重要：** 访客访问的是 **网站根目录**，应上传 **`public/` 里面的所有文件**，而不是把整个 `public` 文件夹当作一层子目录（否则首页路径会变成 `/public/index.html`，容易出错）。

可选做法：

**做法 1：宝塔文件管理**

1. 打开 **文件**，进入该站点根目录（如 `/www/wwwroot/blog.example.com/`）。
2. 若根目录里有默认的 `index.html`、`404.html` 等，可先删除或清空（避免与 Hexo 首页冲突）。
3. 将本地 **`public` 目录内的全部内容**（含 `index.html`、`css/`、`js/`、`archives/` 等）打包为 zip，上传到该目录并解压，保证 **`index.html` 直接在网站根目录下**。

**做法 2：本机命令行 rsync（有 SSH 时）**

```bash
# 在本地项目根目录执行；将 user、域名路径改成你的
rsync -avz --delete ./public/ user@服务器IP:/www/wwwroot/你的域名/
```

### 3.3 确认 Nginx 根目录

1. **网站** → 找到站点 → **设置** → **网站目录**。
2. **网站目录** 应指向你上传文件的那一层（即 **`index.html` 所在目录**）。
3. **运行目录** 一般保持默认 `/` 即可（不要填成 `public` 子目录，除非你刻意把文件放在子目录里）。

### 3.4 测试访问

浏览器访问 `http://你的域名` 或 `http://服务器IP`。应能看到 Hexo 首页。

### 3.5（可选）开启 HTTPS

1. **网站** → 站点 **设置** → **SSL**。
2. 选择 **Let’s Encrypt**，勾选域名，申请并开启 **强制 HTTPS**。
3. 证书续期一般由宝塔定时任务处理，可在面板中查看。

### 3.6 以后每次更新博客

在本地：

```bash
pnpm run clean && pnpm run build
```

然后重新上传 **`public/` 内全部文件** 覆盖网站根目录（或用 rsync `--delete` 同步），无需重启 Nginx。

---

## 四、方式 B：在服务器上用 Git + pnpm 构建

适用于：希望「推代码 → 服务器一键生成」或不想每次本机打包。

### 4.1 宝塔安装 Node 环境

1. **软件商店** 搜索 **Node 版本管理器**（或 **PM2 管理器**，内含 Node），按提示安装。
2. 安装 **Node.js**（建议 **LTS**，如 18 或 20），与本地开发版本尽量接近，减少兼容问题。
3. SSH 登录服务器，确认：

```bash
node -v
npm -v
```

安装 pnpm（若未安装）：

```bash
npm i -g pnpm
pnpm -v
```

### 4.2 克隆项目到服务器

在例如 `/www/wwwroot/` 下建目录存放源码（**不要和网站运行根目录混用**，避免把 `node_modules` 暴露到公网）：

```bash
cd /www/wwwroot/
git clone <你的仓库地址> note-src
cd note-src
pnpm install
pnpm run build
```

构建完成后，**静态文件在** `note-src/public/`。

### 4.3 宝塔站点指向构建产物

**网站** → 添加站点（域名同上）→ **网站目录** 设置为：

```text
/www/wwwroot/note-src/public
```

这样 Nginx 直接服务 `hexo generate` 的输出目录。  
若你更习惯「源码与运行目录分离」，也可以在构建后把 `public/*` **复制或 rsync** 到 `/www/wwwroot/你的域名/`，与方式 A 一致。

### 4.4 安全建议（方式 B 必看）

- 网站运行目录 **只应包含** `public` 里的静态文件；**不要把** 含 `.git`、`source/_posts`、`_config.yml` 的仓库根目录设为对外网站目录，以免泄露配置与草稿。
- 若站点根目录必须指向 `public`，请确保父级目录在 Nginx 中 **不可被遍历** 到上级敏感路径（宝塔默认按站点根提供服务，一般只映射你设置的那一层即可）。

### 4.5 更新流程

```bash
cd /www/wwwroot/note-src
git pull
pnpm install   # 依赖有变更时
pnpm run clean && pnpm run build
```

若网站目录已指向 `.../note-src/public`，构建完成后刷新浏览器即可；若采用复制到另一目录，需在构建后再次复制/rsync。

### 4.6（可选）宝塔计划任务

**计划任务** → 添加 **Shell 脚本**，例如每天拉取并构建（按你需求改路径与分支）：

```bash
cd /www/wwwroot/note-src && git pull && pnpm install && pnpm run build
```

---

## 五、常见问题

### 5.1 打开是空白或 404

- 检查网站根目录下是否有 **`index.html`**，且是否在**根目录**而不是 `public/index.html` 这种多一层的路径。
- **网站目录** 是否填错。

### 5.2 样式、JS 加载失败（路径不对）

- 检查 Hexo 站点配置里的 **`url`** 与 **`root`**（`_config.yml`）是否与线上域名、子路径一致；改完后需重新 `pnpm run build` 再上传。

### 5.3 缓存导致看不到更新

- 浏览器 **强制刷新**（Ctrl+F5 或 Cmd+Shift+R）。
- 若用了 CDN，需在 CDN 控制台刷新缓存。

### 5.4 与 `package.json` 里 `publish` 脚本的关系

`publish` 为：`hexo clean && pnpm run build && git add . && git commit && git push`，用于 **把源码推送到 Git**，**不会**自动部署到宝塔。  
部署到宝塔仍需：**上传 `public/`** 或 **服务器上 `pnpm run build` 并指向 `public`**。

### 5.5 宝塔提示「未检测到 package.json，建议前往传统项目进行项目添加」

这是正常现象，按你的操作路径分两种情况处理：

**情况 1：你选的是「Node 项目」，但文件夹是 `public/` 或只上传了静态文件**

- `public/` 里只有 `index.html`、`css/`、`js/` 等，**没有** `package.json`，宝塔就会报这个提示。
- **正确做法：** 不要添加 Node 项目。请到 **网站** → **添加站点**，选 **传统项目**（或 **纯静态**），网站目录填 **`public` 内容所在目录**（即 `index.html` 那一层）。线上不需要跑 `node` 或 `pnpm run dev`。

**情况 2：你确实要在服务器上构建 Hexo，仍想用宝塔的 Node 能力**

- `package.json` 在 **仓库根目录**（与 `source/`、`_config.yml` 同级），不在 `public/` 里。
- **正确做法：** 添加 Node 项目时，**项目路径必须选到克隆下来的整个博客仓库根目录**（该目录下能看到 `package.json`），而不是 `public` 子目录。
- 构建命令在 SSH 或计划任务里执行：`pnpm install` → `pnpm run build`。  
- **对外访问的站点** 仍建议单独建一个 **传统站点**，**网站目录** 指向 `.../你的仓库/public`（或构建后复制到的目录）；不要指望用 `hexo server` 长期当生产服务。

**小结：** 访问博客用 **传统站点 + 静态根目录**；只有当你要在面板里管理「带 `package.json` 的源码目录」时，才用 Node 项目，且路径要选仓库根。

---

## 六、命令速查（来自 `package.json`）

| 命令 | 作用 |
|------|------|
| `pnpm run build` | 生成静态站到 `public/` |
| `pnpm run clean` | 清理生成文件与缓存 |
| `pnpm run dev` | 本地开发预览 |
| `pnpm run deploy` | Hexo 自带部署（需配置 `_config.yml` 的 deploy，与宝塔无直接绑定） |

---

若你提供「域名、是否用子路径、打算用方式 A 还是 B」，可以把对应站点的**网站目录**与**上传结构**再收紧成一份只针对你环境的检查清单。
