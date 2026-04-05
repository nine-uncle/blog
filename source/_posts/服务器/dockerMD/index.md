---
title: docker
date: 2025-08-01 15:43:07
tags:
  - 'docker'
categories: [服务器]
thumbnail: https://img.cifnews.com/dev/20220907/da961ffcf0cd4e56a8938228959b4b22.jpeg
excerpt: '求仙问卜，不如自己做主，念佛诵经，不如本事在身'
sticky: 9
cover: https://img.cifnews.com/dev/20220907/da961ffcf0cd4e56a8938228959b4b22.jpeg
---

说到 **docker** 对于一个前端开发来说，交集还是比较少的。很少会与服务器，docker 等打交道。
好久之前，于工（一个技术老男孩）和 阿勇 和我说过虽然是个前端，但是还是需要了解这些的，来拓展技术的广度。当时呢不以为然，我实在想象不出来，有什么场景能够用的上这些。

前不久，真的就是涉及到了。于是联系了远在西安出差的阿勇，竟口出狂言: **半小时教会我**

最后历经 1 小时后 我学会了。这个博客 就是 在服务器上面用 docker 构建的。

下面梳理一下 我学到的东西

1. 更新系统软件包

```bash
sudo apt update
```

2. 安装必要的依赖
   1. 安装 docker 所需的依赖项

```bash
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```

3. 添加 Docker 的官方 GPG 密钥

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

4. 添加 Docker 的官方软件源

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

5. 更新软件包 并安装 Docker

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

6. 检查 Docker 是否安装成功

```bash
docker --version
```

会看见类似以下输出

```bash
Docker version 20.10.xx, build xxxx
```

7. 启动 Docker 服务

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

上面呢 都是准备工作，那么安装 Docker 之后 如何把玩呢

崔师傅的教学开始：

- 登录服务器 进入 /var/ 文件夹下面，将 blog 的代码仓库拉取下来（需要包含打包后的产物）
- 在目录下面 打镜像

```bash
docker build -t wzy_blog:1.0 .
```

- 解释：

a. docker build：

- 用于构建 Docker 镜像。
- Docker 会根据指定目录中的 Dockerfile 来创建镜像。

b. -t wzy_blog:1.0：

- -t 选项用于指定镜像的名称和标签。
- wzy_blog 是镜像的名称。
- 1.0 是镜像的标签（版本号）。标签可以用来区分不同版本的镜像，例如 1.0、latest。

c. .（点号）：

- 表示当前目录。
- Docker 会在当前目录中寻找 Dockerfile 文件，并根据该文件的内容构建镜像。

查看镜像 信息

```bash
docker images
```

会产出一个表格 带有 镜像 id

如果想要删除这个镜像则使用命令

```bash
docker rmi xxx(id)
```

多说一句 如果要删除镜像，要先删除容器，删除容器，要先停止容器

好，我们打完镜像 那么要让他在容器里跑起来 则执行

```bash
docker run -d --name wzy_blog -p 8888:80 wzy_blog:1.0
```

解释

- docker run：

用于运行一个新的容器。
基于指定的镜像创建并启动容器。

- -d：

表示以“分离模式”（detached mode）运行容器。
容器会在后台运行，不会占用当前终端。

- --name wzy_blog：

为容器指定一个名称，方便后续管理。
在这里，容器名称是 wzy_blog。
如果不指定名称，Docker 会自动生成一个随机名称。

- -p 8888:80：

用于端口映射，将宿主机的端口 8888 映射到容器的端口 80。
宿主机（阿里云服务器）的 8888 端口可以通过浏览器或其他工具访问容器内的服务（例如 Web 应用）。
格式：<宿主机端口>:<容器端口>。

- wzy_blog:1.0：

指定运行的镜像名称和标签。
这里使用的是镜像 wzy_blog 的版本 1.0。

运行完命令后，终端会返回一个容器 id 例如

```bash
df2e06e1ec4f
```

这表示容器已经成功启动。

查看运行中的容器命令

```bash
docker ps
```

输出示例

```bash
CONTAINER ID   IMAGE            COMMAND                  CREATED        STATUS         PORTS                   NAMES
df2e06e1ec4f   wzy_blog:1.0     "nginx -g 'daemon of…"   5 seconds ago  Up 5 seconds   0.0.0.0:8888->80/tcp    wzy_blog
```

到了这步 则 在浏览器中访问服务器公网 ip + 8888 端口号 即可访问了

上面说到 **如果要删除镜像，要先删除容器，删除容器，要先停止容器**

停止容器命令

```bash
docker stop xxxx(容器id)
```

删除容器命令

```bash
docker rm xxxx(容器id)
```
