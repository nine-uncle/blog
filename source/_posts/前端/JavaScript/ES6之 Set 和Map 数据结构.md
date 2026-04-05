---
title: ES6之 Set 和Map 数据结构
tags:
  - "前端"
  - "算法"
categories: [前端]
thumbnail: https://www.tutorialrepublic.com/lib/images/javascript-illustration.png
excerpt: "重走JavaScript"
sticky: 6
cover: https://www.tutorialrepublic.com/lib/images/javascript-illustration.png
---
## Set
es6 提供了新的数据结构 Set。它类似于数组，但是成员的值都是唯一的，没有重复的值。

Set 本身是一个构造函数，用来生成 Set数据结构 
```javascript
const s = new Set();
[2,3,4,5,5,2,3].forEach(x => s.add(x));
for(let i of s){
    console.log(i); // 2 3 4 5
}
```
上面代码 通过add() 方法 想Set 结构加入成员，结果表明 Set结构不会添加重复的值。
Set() 函数 可以接受一个数组（或者具有 iterable 接口的其他数据结构）作为参数，用来初始化。

```javascript
// 例子一
const set = new Set([1,2,3,4,4]);
[...set]; // [1,2,3,4]
// 例子二
const items = new Set([1,2,3,4,5,5,5,5]); // Set {1,2,3,4,5}
items.size; // 5
// 例子三
const set = new Set(document.querySelectorAll('div'));
set.size; // 56
```
上面代码中，例子一和例子二 都是 Set 函数接受数组作为参数，例子三是接受类似数组的对象作为参数。
上面代码也展示了一种去除数据重复成员的方法。
```javascript
// 去除数组的重复成员
[...new Set(array)]
```
上面的方法也可以用于，去除字符串里面的重复字符串
```javascript
[...new Set('ababbc')].join(''); // abc
```
向Set 加入值的时候，不会发生类型转换，所以 5和 "5"是不同的两个值
Set内部判断两个值是否不同，使用的算法叫做："Same-value-zero equality"， 它类似于精确相等运算符（===），主要的区别是NaN等于自身，
而精确相等运算符认为NaN不等于自身。

```javascript
let set = new Set();
let a = NaN;
let b = NaN;
set.add(a);
set.add(b);
set; // Set {NaN}
```
上面代码向Set实例添加了两次NaN,但是只会加入一个，这表明，在Set内部，两个NaN是相等的。

另外，两个对象总是不相等的
```javascript
let set = new Set();
set.add({});
set.size; // 1
set.add({});
set.size; // 2
```
上面代码表示，由于两个空对象不相等，所以它们被视为两个值。
Array.from 方法可以将 Set 结构转为数组
```javascript
const items = new Set([1,2,3,4,5]);
const array = Array.from(items);
```
这就提供了另一种去除数组重复成员的方法。
```javascript
function dedupe(array){
    return Array.from(new Set(array));
}
```
### Set 实例的属性和方法
Set结构的实力有以下属性。
- Set.prototype.constructor: 构造函数，默认就是 Set 函数
- Set.prototype.size: 返回 Set 实例的成员总数
Set 实例的方法分为两大类： 操作方法（用于操作数据）和遍历方法（用于遍历成员）。
下面先介绍四个操作方法：
- add(value): 添加某个值，返回 Set 结构本身
- delete(value): 删除某个值，返回一个布尔值，表示是否删除成功
- has(value): 返回一个布尔值，表示该值是否为Set的成员
- clear(): 清除所有成员，没有返回值
上面这些属性和方法的实例如下：
```javascript
let s = new Set();
s.add(1).add(2).add(2);
s.size; // 2
s.has(1); // true
s.has(2); // true
s.has(3); // false
s.delete(2);
s.has(2); // false
```
下面是一个对比，判断是否包括一个键，Object 结构和Set 结构写法的不同
```javascript
// 对象写法
const propertues ={
    'width': 1,
    'height': 1
};

if(properties[someName]){
    // do something
}
// Set 结构写法
const properties = new Set();
properties.add('width');
properties.add('height');

if(properties.has(someName)){
    // do something
}
```
### 遍历操作
Set 结构的实例有四个遍历方法，可以用于遍历成员。
- keys(): 返回键名的遍历器
- values(): 返回键值的遍历器
- entries(): 返回键值对的遍历器
- forEach(): 使用回调函数遍历每个成员
需要特别指出的是，Set 的遍历顺序就是插入顺序。这个特性有时非常有用。比如使用Set 保存一个回调函数列表，调用时就能保证按照添加顺序调用。
keys(), values(), entries() 返回的都是遍历器对象，可以用for...of 循环遍历，也可以使用 forEach 方法。
```javascript
let set = new Set(['red','green','blue']);
for (let item of set.keys()){
    console.log(item);
} // red green blue
for (let item of set.values()){
    console.log(item);
} // red green blue 
for (let item of set.entries()){
    console.log(item);
} // ['red','red'] ['green','green'] ['blue','blue']
```
上面代码中，entries 方法返回的遍历器，同时包括键名和键值，所以每次输出一个数组，他的两个成员完全相等。
Set 结构的实例默认可遍历，它的默认遍历器生成函数就是它的values方法。
```javascript
Set.prototype[Symbol.iterator] === Set.prototype.values
// true
```
这意味着，可以省略values方法，直接用for...of 循环遍历 Set。
```javascript
let set = new Set(['red','green','blue']);
for(let x of set){
    console.log(x);
} // red green blue
```
Set 结构的实例的forEach方法，用于对每个成员执行某种操作，没有返回值。
```javascript
let set = new Set([1,4,9]);
set.forEach((value,key) => console.log(value * 2));
```
上面代码说明，forEach 方法的参数就是一个处理函数。该函数的参数与数组的forEach一致，依次为键值、键名、集合本身。
### 遍历的应用
扩展运算符（...）内部使用for...of 循环，所以也可以用于 Set 结构。
```javascript
let set = new Set(['red','green','blue']);
let arr = [...set];
```
扩展运算符和 Set 结构相结合，就可以去除数组的重复成员。
```javascript
let arr = [3,5,2,2,5,5];
let unique = [...new Set(arr)];
```
数组的map 和 filter 方法也可以间接用于 Set。
```javascript
let set = new Set([1,2,3]);
set = new Set([...set].map(x => x * 2]);
// 返回 Set 结构：{2,4,6}
let set = new Set([1,2,3,4,5]);
set = new Set([...set].filter(x => (x % 2) == 0));  
// 返回 Set 结构：{2,4}
```
因此，使用 Set 可以很容易地实现并集（Union）、交集（Intersect）和差集（Difference）。
```javascript
let a = new Set([1,2,3]);
let b = new Set([4,3,2]);
// 并集
let union = new Set([...a,...b]);
// Set {1,2,3,4}
// 交集
let intersect = new Set([...a].filter(x => b.has(x)));
// Set {2,3}
// 差集
let difference = new Set([...a].filter(x => !b.has(x)));
// Set {1}
```

