# 国内 ECS 拉 docker.io 常失败，默认走 DaoCloud 镜像；可 build 时覆盖 NGINX_IMAGE
# 示例: docker build --build-arg NGINX_IMAGE=nginx:stable-alpine -t my-hexo-blog:v1 .
ARG NGINX_IMAGE=docker.m.daocloud.io/library/nginx:stable-alpine
FROM ${NGINX_IMAGE}

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY public /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
