# 使用 nginx 基础镜像
FROM  nginx:stable-alpine

#移除默认的Nginx配置文件
RUN rm /etc/nginx/conf.d/default.conf

#将自定义的Nginx配置文件复制到容器中
COPY nginx.conf /etc/nginx/conf.d/default.conf

#将Hexo生成的静态文件复制到容器中
COPY public /usr/share/nginx/html

#暴露80端口
EXPOSE 80

#启动Nginx
CMD ["nginx", "-g", "daemon off;"]