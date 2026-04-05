---
title: ES6之 Set 和Map 数据结构demo
tags:
  - "前端"
  - "算法"
categories: [前端]
thumbnail: https://www.tutorialrepublic.com/lib/images/javascript-illustration.png
excerpt: "重走JavaScript"
sticky: 6
cover: https://www.tutorialrepublic.com/lib/images/javascript-illustration.png
---
```javascript
let a = new Set([1,2,3,4,5,6,6,7,8,9,10])
let b = new Set([2,3,4,6])
// 并集
function union(a,b){
    let set = new Set ([...a,...b]);
    return [...set]
}
let result1 = union(a,b);
console.log(result1);
// 交集
function intersection(a,b){
  let res =  [...a].filter((x)=>b.has(x))
    return res;
}
let result2 = intersection(a,b);
console.log(result2);
// 差集
function difference(a,b){
    let res = [...a].filter((x)=>!b.has(x))
    return res;
}
let result3 = difference(a,b);
console.log(result3);
```