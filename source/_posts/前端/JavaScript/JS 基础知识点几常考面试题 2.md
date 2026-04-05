---
title: JS 基础知识点及常考面试题 2
date: 2024-09-04 10:14:07
tags:
  - "前端"
  - "JavaScript"
categories: [前端]
thumbnail: https://www.tutorialrepublic.com/lib/images/javascript-illustration.png
excerpt: "JavaScript 从头来过"
sticky: 8
cover: https://www.tutorialrepublic.com/lib/images/javascript-illustration.png
---

### == vs ===

对于 == 来说，如果对比双方的类型不一样的话，就会进行类型转换

当我们需要对比 x 和 y 是否相同时，就会进行如下判断流程：
1. 首先会判断两者类型是否相同。相同的话就是比大小了
2. 类型不相同的话，那么就会进行类型转换
3. 会先判断是否在对比 null 和 undefined，是的话就会返回 true
4. 判断两者类型是否为string 和 number 是的话就会将 字符串转换为 number
```javascript
 1 == '1'
      👇🏻
 1 ==  1
```
5. 判断其中一方是否为 boolean，是的话就会把 boolean 转为 number 再进行判断
```javascript
 '1' == true
         👇🏻
 '1' ==  1
  👇🏻
  1 ==  1
```
6. 判断其中一方是否为 object 且另一方为 string、number 或 symbol，是的话就会把 object 转为原始类型再进行判断
```javascript
 1 == { valueOf: () => 1 }
         👇🏻
 1 == 1  // true

'1' == { name: 'yck' }
        👇🏻
'1' == '[object Object]' // false
```

#### 常见面试题
- ==  和 === 区别
- == 操作符的类型转换规则

### 闭包
首先闭包正确的定义是： 加入一个函数能访问外部的变量，那么就形成了一个闭包，而不是一定要返回一个函数
    
```javascript
let a = 1;
// 产生闭包
function fn() {
    console.log(a);
}

function fn1() {
    let a = 2;
    // 产生闭包
    return function() {
        console.log(a);
    }
}

const fn2 = fn1()

fn2() // 2  
```

### 深浅拷贝
我们知道对象类型在赋值的过程中其实是复制了地址，从而会导致改变了一方时其他也都被改变的情况。通常在开发中我们不希望出现这样的问题，可以使用浅拷贝
来解决这个情况

#### 浅拷贝
浅拷贝只会拷贝对象的第一层，如果对象的属性仍然是对象，那么拷贝的就是这个对象的地址，所以就会导致上述问题。
首先可以通过 Object.assign 来解决这个问题。这个函数会拷贝所有的属性值到新的对象中。如果属性值是对象的话，拷贝的则是这个对象的地址。

```javascript
let a = {
    age: 1
}
let b = Object.assign({}, a)
a.age = 2
console.log(b.age) // 1
```
另外我们还可以通过展开运算符 ... 来实现浅拷贝：
    
```javascript
let a = {
    age:1
}
let b = {...a}
a.age = 2
console.log(b.age) // 1

```
通常浅拷贝就能解决大部分问题了，但是当我们遇到如下的情况就需要使用到深拷贝了：
    
```javascript
let a = {
    age: 1,
    jobs: {
        first: 'FE'
    }
}
    
let b = {...a}
a.jobs.first = 'native'
console.log(b.jobs.first) // native
```

#### 深拷贝
深拷贝通常可以通过 JSON.parse(JSON.stringify(object)) 来实现，这个方式基本能解决大部分情况
```javascript
let a = {
    age: 1,
    jobs: {
        first: 'FE'
    }
}
let b = JSON.parse(JSON.stringify(a))
a.jobs.first = 'native'
console.log(b.jobs.first) // FE
```
当然了，这个方法是存在局限性的
```javascript
let obj = {
    a: 1,
    b: {
        c: 2,
        d: 3
    }
}
obj.c = obj.b
obj.e = obj.a
obj.b.c = obj.c
obj.b.d = obj.b
obj.b.e = obj.b.c
let newObj = JSON.parse(JSON.stringify(obj))
console.log(newObj)
```
如果对象中存在循环引用，你会发现程序会报错。

同时在遇到不支持的数据类型，比如 函数、undefined、symbol 时，也会直接忽略
```javascript
let a = {
    age: undefined,
    sex: Symbol('male'),
    jobs: function() {},
    name: 'yck'
}
let b = JSON.parse(JSON.stringify(a))
console.log(b) // {name: "yck"} 

```
-以下是 JSON 支持的数据类型：
    - 对象(Object)l
    - 字符串(String)
    - 数值(Number)
    - 布尔(Boolean)
    - nul
- 以下是 JSON 不支持的数据类型：
    - 函数(Function)
    - 日期(Date)
    - undefined
    - symbol
#### 手写深拷贝函数
```javascript
function deepCopy(obj) {
    // 检查是否是基本类型（null、undefined、字符串、数字、布尔值）
    if (obj === null || typeof obj !== 'object') {
        return obj;
    }

    // 处理日期对象
    if (obj instanceof Date) {
        return new Date(obj);
    }

    // 处理数组
    if (Array.isArray(obj)) {
        let copy = [];
        for (let i = 0; i < obj.length; i++) {
            copy[i] = deepCopy(obj[i]); // 递归深拷贝每个元素
        }
        return copy;
    }

    // 处理对象
    if (obj instanceof Object) {
        let copy = {};
        for (let key in obj) {
            // 只复制对象本身的属性，而不复制原型链上的属性
            if (obj.hasOwnProperty(key)) {
                copy[key] = deepCopy(obj[key]); // 递归深拷贝每个属性
            }
        }
        return copy;
    }

    // 处理其他类型（如函数、正则表达式等），默认不拷贝，返回空对象
    throw new Error("Unable to copy object, unsupported type.");
}

// 使用示例
const originalObj = {
    name: "John",
    age: 30,
    date: new Date(),
    hobbies: ["reading", "travelling"],
    address: {
        city: "New York",
        zip: "10001"
    }
};

const copiedObj = deepCopy(originalObj);

// 测试
console.log(copiedObj);
console.log(copiedObj === originalObj); // false
console.log(copiedObj.address === originalObj.address); // false
console.log(copiedObj.hobbies === originalObj.hobbies); // false

```
{% notel blue 代码解读 %}
1. 基本类型处理：
 - 如果 obj 是基本类型（例如 null、字符串、数字、布尔值等），直接返回它，因为基本类型不需要深拷贝。
2. 日期处理：
 - 如果 obj 是 Date 类型，创建并返回一个新的日期对象，防止原始日期对象被修改。
3. 数组处理：
 - 如果 obj 是数组，创建一个新的空数组，并递归地深拷贝数组中的每个元素。
4. 对象处理：
 - 如果 obj 是对象，创建一个新的空对象，并递归地深拷贝对象中的每个属性。只复制对象本身的属性（使用 hasOwnProperty 检查），避免复制原型链上的属性。
5.错误处理：
 - 如果 obj 是其他未处理的类型（如函数、正则表达式等），函数会抛出错误，提示不支持的类型。
{% endnotel %}

#### 常见面试题
- 浅拷贝和深拷贝的区别是什么
- JSON.parse(JSON.stringify(a)) 存在什么问题
- 手写深拷贝函数