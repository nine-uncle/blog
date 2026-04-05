---
title: JS 基础知识点及常考面试题 1
date: 2024-08-26 15:51:04
tags:
  - "前端"
  - "JavaScript"
categories: [前端]
thumbnail: https://www.tutorialrepublic.com/lib/images/javascript-illustration.png
excerpt: "JavaScript 从头来过"
sticky: 10
cover: https://www.tutorialrepublic.com/lib/images/javascript-illustration.png
---

## 类型
### JS 数据类型分为两类：
    1. 基本数据类型(原始类型)
    2. 引用数据类型(对象类型）
### 基本数据类型(原始类型)
 在JS中，存这7种原始值:

   ```
    1. number
    2. string
    3. boolean
    4. null
    5. undefined
    6. symbol
    7. bigInt
   ```
 首先原始类型存储的都是值，是没有函数可以调用的，而引用类型存储的是地址，是可以调用函数的。
 比如：
 ```javascript
    var undefined = undefined;
    undefined.toString(); 
    // 报错 Uncaught TypeError: Cannot read property 'toString' of undefined
 ```

{% notel blue 提示 %}
那比如 **'1'.toString()** 是可以使用的。其实在这种情况下, **'1'** 已经不是原始类型了，而是被强制转换成了**String**类型
也就是对象类型，所以可以调用**toString()**方法。
{% endnotel %}

{% notel blue 提示 %}
string 类型的值是不可变的，无论你在 string 类型上调用何种方法，都不会对值有改变。
{% endnotel %}
```javascript
    var str = 'hello';
    str.toUpperCase();
    console.log(str); // hello
    let newStr = str.slice(2,4); // ll
    console.log(str); // hello
```
### 引用数据类型(对象类型）
 ```
    1. Object
    2. Array
    3. Function
    4. Date
    5. RegExp
    6. Error
    7. Math
    8. JSON
 ```

{% notel blue 基本数据类型与引用数据类型的区别 %}
基本数据类型与引用数据类型不同的是，
原始类型存储的是值，一般存储在栈(stack)上，而引用类型存储的是地址，一般存储在堆(heap)上。
{% endnotel %}

当创建一个对象类型的时候，计算机会在堆内存中帮我们开辟一个空间来存放值，但是当我们需要找到这个空间的时候，这个空间会有一个地址，
然后通过这个地址来找到对应的数据。
```javascript
const a = []
```
对于常量a 来说，假设内存地址(指针or门牌号)为0x0001，那么a存储的就是0x0001，而0x0001指向的是一个数组对象。
```javascript
const a = []
const b = a
b.push(1)
console.log(a) // [1]
console.log(b) // [1]
```
{% notel blue 专业解释 %}
专业地说，当我们将变量赋值给另一个变量时，复制的是原本变量的地址(指针)，也就是说当前变量b存放的地址也是0x0001。
因此当我们对任一变量进行数据修改的时候，等同于修改存放地址0x0001的数据，所以a和b的值都会发生变化。
{% endnotel %}

{% notel blue 通俗解释 %}
通俗地说，小明(a)有个房子，房子地址是回龙观东大街1号，然后小红(b)也租住了这个房子，所以 小明 与 小红 共享了这个房子。
然后有天 小红 买了个playstation 5 放在房子里，小明 也能看到这个playstation 5。
{% endnotel %}

函数参数是对象的情况：

```javascript
function fn(person) {
    person.age = 20
    person = {
      name: 'Tom',
      age: 18
    }
    return person;
}
const p1 = {
    name: 'Jerry',
    age: 19
}
console.log(p1) // {name: "Jerry", age: 19}
const person2 = fn(p1)
console.log(p1) // {name: "Jerry", age: 20}
console.log(p2) // {name: "Tom", age: 18}
```

{% notel blue 专业解释 %}
函数参数是对象的情况下，传递的是对象的引用，而不是对象本身。所以在函数内部修改对象的属性，会影响到函数外部的对象。
- 首先，函数传参是传递的对象的地址(指针，门牌号)，而不是对象本身。
- 其次，当函数内部修改对象的属性时，当前p1的值也会发生变化。也就是 age 从19 变化到 20了
- 最后，当函数内部重新赋值对象时，person指向了一个新的地址，而p1还是指向原来的地址。
{% endnotel %}

{% notel blue 通俗解释 %}
p1: '小明'
p2: '小红'
fn: '某件事情'
小明进入了某件事情之后呢，心智年龄得到了提升，变成了20岁，但是小明还是小明，只是心智年龄变了。
小红呢 等待这个事情的结果，结果出来后，小红就变了一个人一样。但是呢小明还是小明。
{% endnotel %}


### 类型判断

类型判断有多种方式。

#### typeof
typeof 对于 原始类型来说，除了 null 都可以显示正确的类型，如果你想判断 null的话可以使用 variable=== null

```javascript
    typeof 1 // 'number'
    typeof '1' // 'string'
    typeof true // 'boolean'
    typeof undefined // 'undefined'
    typeof Symbol() // 'symbol'
    typeof BigInt(1) // 'bigint'
```
typeof 对于对象来说，除了函数都会显示 object，所以说 typeof 并不能准确判断变量到底是什么类型。

```javascript
    typeof [] // 'object'
    typeof {} // 'object'
    typeof console.log // 'function'
```
#### instanceof

instanceof 可以准确判断复杂数据类型，但是对于基本数据类型来说，无能为力。

```javascript
    const Person = function() {}
    const p1 = new Person()
    p1 instanceof Person // true
 
    var str = 'hello'
    str instanceof String // false
 
    var str1 = new String('hello')
    str1 instanceof String // true
```
对于原始类型来说，想直接通过 instanceof 来判断类型是不行的，但是我们还是有办法实现的。

```javascript
        class PrimitiveString {
            static [Symbol.hasInstance](x) {
                return typeof x === 'string'
            }
        }
        'hello' instanceof PrimitiveString // true
``` 
你可能不知道 Symbol.hasInstance是什么东西，其实就是一个能让我们自定义 instanceof 行为的东西。
以上代码等同于 
    
```javascript
typeof 'hello' === 'string' // true
```
所以结果自然就是 true 了

其实也侧面反映了一个问题： insanceof 并不是百分之百可信的

另外其实我们还可以直接通过构建函数来判断类型：

```javascript
    // true
[].constructor === Array
```
#### Object.prototype.toString.call()
前面集中方式 或多或少都存在一些缺陷。
Object.prototype.toString.call 综合来看是最佳选择，能判断的类型最完整，基本上是开源库选择最多的方式。
    
```javascript
        Object.prototype.toString.call(1) // "[object Number]"
        Object.prototype.toString.call('1') // "[object String]"
        Object.prototype.toString.call(true) // "[object Boolean]"
        Object.prototype.toString.call(undefined) // "[object Undefined]"
        Object.prototype.toString.call(null) // "[object Null]"
        Object.prototype.toString.call(Symbol()) // "[object Symbol]"
        Object.prototype.toString.call(BigInt(1)) // "[object BigInt]"
        Object.prototype.toString.call([]) // "[object Array]"
        Object.prototype.toString.call({}) // "[object Object]"
        Object.prototype.toString.call(console.log) // "[object Function]"
``` 
#### 常见面试题
1. JS 类型如何判断，有哪几种方式可用
2. instanceof 原理
3. 手写 instanceof

### 类型转换
首先我们要知道，在JS中类型转换只有三种情况，分别是：
1. 转换为布尔值
2. 转换为数字
3. 转换为字符串

