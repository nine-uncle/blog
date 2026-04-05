---
title: 快速理解JS节流和防抖以及场景
date: 2024-09-05 10:51:22
tags:
  - "前端"
  - "JavaScript"
categories: [前端]
thumbnail: https://www.tutorialrepublic.com/lib/images/javascript-illustration.png
excerpt: "JavaScript 从头来过"
sticky: 10
cover: https://www.tutorialrepublic.com/lib/images/javascript-illustration.png
---

## 概念和例子
### 防抖函数 (debounce)
防抖函数的作用是在一段时间内，不管触发多少次回调，只执行最后一次。比如在输入框输入时，只有在输入完成后，才会触发回调。

```javascript
// fn 是需要防抖的函数，delay 是防抖的时间
function debounce(fn,delay){
    // 定时器
    let timer = null;
    // 返回一个函数
    return function(){
        const that = this
        // 如果定时器存在，清除定时器
        if(timer){
            clearTimeout(timer);
        }
        // 重新设置定时器
        timer = setTimeout(()=>{
            // 执行函数
            fn.apply(that,arguments);
        },delay);
    }
}
```

### 节流函数 (throttle)
节流函数的作用是在一段时间内，不管触发多少次回调，只执行一次。比如在滚动事件中，只有在停止滚动后，才会触发回调。

```javascript
function throttle(fn,delay){
    // 定时器
    let timer = null;
    // 返回一个函数
    return function(){
        // 如果定时器不存在
        if(!timer){
            // 设置定时器
            timer = setTimeout(()=>{
                // 执行函数
                fn.apply(this,arguments);
                // 清除定时器
                timer = null;
            },delay);
        }
    }
}

```