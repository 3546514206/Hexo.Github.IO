---
title: 理解JavaScript中的对象与new命令
date: 2023-12-13 16:02:59
categories:
- 基本功
- 编程基础
tags:
- JavaScript
- OOP
---

#### __1、对象是什么__

&ensp;&ensp;&ensp;&ensp; 面向对象编程（Object Oriented Programming，缩写为 OOP）是目前主流的编程范式。它将真实世界各种复杂的关系，抽象为一个个对象，然后由对象之间的分工与合作，完成对真实世界的模拟。

&ensp;&ensp;&ensp;&ensp; 每一个对象都是功能中心，具有明确分工，可以完成接受信息、处理数据、发出信息等任务。对象可以复用，通过继承机制还可以定制。因此，面向对象编程具有灵活、代码可复用、高度模块化等特点，容易维护和开发，比起由一系列函数或指令组成的传统的过程式编程（procedural programming），更适合多人合作的大型软件项目。

&ensp;&ensp;&ensp;&ensp; 那么，“对象”（object）到底是什么？我们从两个层次来理解。

* 对象是单个实物的抽象。

&ensp;&ensp;&ensp;&ensp; 一本书、一辆汽车、一个人都可以是对象，一个数据库、一张网页、一个远程服务器连接也可以是对象。当实物被抽象成对象，实物之间的关系就变成了对象之间的关系，从而就可以模拟现实情况，针对对象进行编程。

* 对象是一个容器，封装了属性（property）和方法（method）。

&ensp;&ensp;&ensp;&ensp; 属性是对象的状态，方法是对象的行为（完成某种任务）。比如，我们可以把动物抽象为animal对象，使用“属性”记录具体是哪一种动物，使用“方法”表示动物的某种行为（奔跑、捕猎、休息等等）。

#### __2、构造函数__

&ensp;&ensp;&ensp;&ensp; 面向对象编程的第一步，就是要生成对象。前面说过，对象是单个实物的抽象。通常需要一个模板，表示某一类实物的共同特征，然后对象根据这个模板生成。

&ensp;&ensp;&ensp;&ensp; 典型的面向对象编程语言（比如 C++ 和 Java），都有“类”（class）这个概念。所谓“类”就是对象的模板，对象就是“类”的实例。但是，JavaScript 语言的对象体系，不是基于“类”的，而是基于构造函数（constructor）和原型链（prototype）。

&ensp;&ensp;&ensp;&ensp; JavaScript 语言使用构造函数（constructor）作为对象的模板。所谓”构造函数”，就是专门用来生成实例对象的函数。它就是对象的模板，描述实例对象的基本结构。一个构造函数，可以生成多个实例对象，这些实例对象都有相同的结构。

&ensp;&ensp;&ensp;&ensp; 构造函数就是一个普通的函数，但具有自己的特征和用法。

```javascript
var Vehicle = function () {
    this.price = 1000;
};
```

&ensp;&ensp;&ensp;&ensp; 上面代码中，Vehicle就是构造函数。为了与普通函数区别，构造函数名字的第一个字母通常大写。

&ensp;&ensp;&ensp;&ensp; 构造函数的特点有两个。

* 函数体内部使用了this关键字，代表了所要生成的对象实例。

* 生成对象的时候，必须使用new命令。

&ensp;&ensp;&ensp;&ensp; 下面先介绍new命令。

#### __3、New命令__

#### __3.1、基本用法__

&ensp;&ensp;&ensp;&ensp; new命令的作用，就是执行构造函数，返回一个实例对象。

```javascript
var Vehicle = function () {
    this.price = 1000;
};

var vobj = new Vehicle();
vobj.price // 1000
```

&ensp;&ensp;&ensp;&ensp; 上面代码通过new命令，让构造函数Vehicle生成一个实例对象，保存在变量v中。这个新生成的实例对象，从构造函数Vehicle得到了price属性。new命令执行时，构造函数内部的this，就代表了新生成的实例对象，this.price表示实例对象有一个price属性，值是1000。

&ensp;&ensp;&ensp;&ensp; 使用new命令时，根据需要，构造函数也可以接受参数。

```javascript
var Vehicle = function (p) {
    this.price = p;
};

var v = new Vehicle(500);
```

&ensp;&ensp;&ensp;&ensp; new命令本身就可以执行构造函数，所以后面的构造函数可以带括号，也可以不带括号。下面两行代码是等价的，但是为了表示这里是函数调用，推荐使用括号。

```javascript
// 推荐的写法
var v = new Vehicle();
// 不推荐的写法
var v = new Vehicle;
```

&ensp;&ensp;&ensp;&ensp; 一个很自然的问题是，如果忘了使用new命令，直接调用构造函数会发生什么事？

&ensp;&ensp;&ensp;&ensp; 这种情况下，构造函数就变成了普通函数，并不会生成实例对象。而且由于后面会说到的原因，this这时代表全局对象，将造成一些意想不到的结果。

```javascript
var Vehicle = function (){
    this.price = 1000;
};

var v = Vehicle();
v // undefined
price // 1000
```















