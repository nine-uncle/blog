# start

### 加载依赖

```
npm install
```

### 构建镜像

```
docker build -t wzy_blog:1.0 .


$version = (Get-Date).ToString("yyyyMMddHHmm")
docker buildx build --platform linux/arm64 -t ragweb_chatbox_arm:$version .

# 后台运行
docker run -d --name wzy_blog -p 8888:80 wzy_blog:1.0
```
