# 国内服务器请使用镜像加速地址，避免 docker.io 拉取失败
# 若仍失败，可在 ECS 配置 /etc/docker/daemon.json 的 registry-mirrors
FROM registry.cn-hangzhou.aliyuncs.com/library/nginx:stable-alpine

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY public /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
