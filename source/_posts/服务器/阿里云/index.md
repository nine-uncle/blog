---
title: 阿里云服务器 --- nignx命令
date: 2024-08-28 12:43:07
tags:
  - "阿里云服务器"
categories: [服务器]
thumbnail: https://img.cifnews.com/dev/20220907/da961ffcf0cd4e56a8938228959b4b22.jpeg
excerpt: "求仙问卜，不如自己做主，念佛诵经，不如本事在身"
sticky: 9
cover: https://img.cifnews.com/dev/20220907/da961ffcf0cd4e56a8938228959b4b22.jpeg
---

### 清除缓存 & 重启
当对nginx的文件进行修改或更新时，可能会出现旧文件被缓存而无法立即生效的问题，此时需要清空nginx的文件缓存并强制刷新。可以通过以下步骤实现：
```shell
#登录nginx服务器
#执行命令：
  sudo nginx -s reload #（重新加载nginx配置）
执行命令：
  sudo rm -rf /var/cache/nginx/* #（清空nginx缓存)
执行命令：
  sudo systemctl restart nginx #（重启nginx服务） 
```
这样就可以清空nginx的文件缓存并强制刷新。需要注意的是，此操作可能会导致服务器)负担增加，建议在低峰期进行操作。