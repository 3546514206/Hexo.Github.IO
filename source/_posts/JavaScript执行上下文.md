---
title: JavaScript执行上下文
date: 2023-11-30 15:36:22
tags:
- JavaScript
---

__1、什么是执行上下文？__

&ensp;&ensp;&ensp;&ensp; 简而言之，执行上下文是计算和执行 JavaScript 代码环境的抽象概念。每当 Javascript 代码在运行的时候，它都是在执行上下文中运行。一个执行上下文包含：scope(作用域)、variable object(变量对象)、this value(this 值)。

__2、执行上下文的类型__

&ensp;&ensp;&ensp;&ensp; JavaScript 中有三种执行上下文类型：

* 全局执行上下文：这是默认或者说基础的上下文，任何不在函数内部的代码都在全局上下文中。它会执行两件事：创建一个全局的 window 对象（浏览器的情况下），并且设置 this 的值等于这个全局对象。一个程序中只会有一个全局执行上下文。
* 函数执行上下文：每当一个函数被调用时, 都会为该函数创建一个新的上下文。每个函数都有它自己的执行上下文，不过是在函数被调用时创建的。函数上下文可以有任意多个。每当一个新的执行上下文被创建，它会按定义的顺序（将在后文讨论）执行一系列步骤。
* Eval 函数执行上下文：执行在 eval 函数内部的代码也会有它属于自己的执行上下文，但由于 JavaScript 开发者并不经常使用 eval，所以在这里我不会讨论它。

__3、执行栈__

&ensp;&ensp;&ensp;&ensp; 执行栈，也就是在其它编程语言中所说的“调用栈”，是一种拥有 LIFO（后进先出）的数据结构，被用来存储代码运行时创建的所有执行上下文。

&ensp;&ensp;&ensp;&ensp; 当 JavaScript 引擎第一次遇到你的脚本时，它会创建一个全局的执行上下文并且压入当前执行栈。每当引擎遇到一个函数调用，它会为该函数创建一个新的执行上下文并压入栈的顶部。引擎会执行处于栈顶的执行上下文的函数。当该函数执行结束时，执行上下文从栈中弹出，控制流程到达当前栈中的下一个上下文。让我们通过下面的代码示例来理解：

```
let a = 'Hello World!';

function first() {
  console.log('Inside first function');
  second();
  console.log('Again inside first function');
}

function second() {
  console.log('Inside second function');
}

first();
console.log('Inside Global Execution Context');
```

&ensp;&ensp;&ensp;&ensp; 当上述代码在浏览器加载时，JavaScript 引擎创建了一个全局执行上下文并把它压入当前执行栈。当遇到 first() 函数调用时，JavaScript 引擎为该函数创建一个新的执行上下文并把它压入当前执行栈的顶部。

![IP报文结构](/pic/基本功/编程基础/JavaScript执行上下文/运行上下文.png)

&ensp;&ensp;&ensp;&ensp; 当从 first() 函数内部调用 second() 函数时，JavaScript 引擎为 second() 函数创建了一个新的执行上下文并把它压入当前执行栈的顶部。当 second() 函数执行完毕，它的执行上下文会从当前栈弹出，并且控制流程到达下一个执行上下文，即 first() 函数的执行上下文。当 first() 执行完毕，它的执行上下文从栈弹出，控制流程到达全局执行上下文。一旦所有代码执行完毕，JavaScript 引擎从当前栈中移除全局执行上下文。

__4、怎么创建执行上下文__

&ensp;&ensp;&ensp;&ensp; 到现在，我们已经看过 JavaScript 怎样管理执行上下文了，现在让我们了解 JavaScript 引擎是怎样创建执行上下文的。创建执行上下文有两个阶段：1） 创建阶段 和 2） 执行阶段。

__4.2、执行上下文的创建阶段（ES5及其以后规范）__

&ensp;&ensp;&ensp;&ensp; 创建阶段做三件事：1）this 值的决定，即我们所熟知的 this 绑定。2）创建词法环境组件。3）创建变量环境组件。

&ensp;&ensp;&ensp;&ensp; 所以执行上下文的伪代码表示可以为：

```
ExecutionContext = {
  ThisBinding = <this value>,
  LexicalEnvironment = { ... },
  VariableEnvironment = { ... }
}
```

__4.2.1、this 绑定__

&ensp;&ensp;&ensp;&ensp; 在全局执行上下文中，this 的值指向全局对象。(在浏览器中，this引用 Window 对象)。在函数执行上下文中，this 的值取决于该函数是如何被调用的。如果它被一个引用对象调用，那么 this 会被设置成那个对象，否则 this 的值被设置为全局对象或者 undefined（在严格模式下）。例如：

```
let foo = {           // PS:对象的花括号理解为作用域可能不太妥，理解为"属于"也许更为准确
  baz: function() {
      console.log(this);
  }
}

foo.baz();   // 'this' 引用 'foo', 因为 'baz' 被
             // 对象 'foo' 调用
let bar = foo.baz;

bar();       // 'this' 指向全局 window 对象，因为
             // 没有指定引用对象
```

__4.2.2、词法环境__

&ensp;&ensp;&ensp;&ensp; 官方的 ES6 文档把词法环境定义为：

&ensp;&ensp;&ensp;&ensp; __词法环境是一种规范类型，基于 ECMAScript 代码的词法嵌套结构来定义标识符和具体变量和函数的关联。一个词法环境由环境记录器和一个可能的引用outer词法环境的空值组成。__

&ensp;&ensp;&ensp;&ensp; 简单来说词法环境是一种持有标识符—变量映射的结构。（这里的标识符指的是变量/函数的名字，而变量是对实际对象[包含函数类型对象]或原始数据的引用）。

&ensp;&ensp;&ensp;&ensp; 现在，在词法环境的内部有两个组件：(1) 环境记录器：环境记录器是存储变量和函数声明的实际位置。 (2) 一个外部环境的引用：外部环境的引用意味着它可以访问其父级词法环境（作用域）。

&ensp;&ensp;&ensp;&ensp; 词法环境有两种类型：1）全局词法环境（在全局执行上下文中）是没有外部环境引用的词法环境。全局环境的外部环境引用是 null。它拥有内建的 Object/Array/等、在环境记录器内的原型函数（关联全局对象，比如 window 对象）还有任何用户定义的全局变量，并且 this的值指向全局对象。2）函数词法环境，函数内部用户定义的变量存储在函数环境记录器中。并且引用的外部环境可能是全局环境，或者任何包含此内部函数的外部函数。

&ensp;&ensp;&ensp;&ensp; 环境记录器也有两种类型：1）声明式环境记录器存储变量、函数和参数；2）对象环境记录器用来定义出现在全局上下文中的变量和函数的关系。简而言之，在全局环境中，环境记录器是对象环境记录器。在函数环境中，环境记录器是声明式环境记录器。

&ensp;&ensp;&ensp;&ensp; 对于函数环境，声明式环境记录器还包含了一个传递给函数的 arguments 对象（此对象存储索引和参数的映射）和传递给函数的参数的 length。抽象地讲，词法环境在伪代码中看起来像这样：

```
GlobalExectionContext = {
  LexicalEnvironment: {
    EnvironmentRecord: {
      Type: "Object",
      // 在这里绑定标识符
    }
    outer: <null>    // 全局词法环境的外部环境引用为null
  }
}

FunctionExectionContext = {
  LexicalEnvironment: {
    EnvironmentRecord: {
      Type: "Declarative",
      // 在这里绑定标识符
    }
    outer: <Global or outer function environment reference>
  }
}
```

__4.2.3、变量环境__

&ensp;&ensp;&ensp;&ensp; 变量环境同样是一个词法环境，所以它有着上面定义的词法环境的所有属性，其环境记录器持有变量声明语句在执行上下文中创建的绑定关系。在 ES6 中，词法环境组件和变量环境组件的一个不同点就是前者被用来存储函数声明和变量（let 和 const）绑定，而后者只用来存储 var 变量绑定。我们看点样例代码来理解上面的概念：

```
let a = 20;
const b = 30;
var c;

function multiply(e, f) {
 var g = 20;
 return e * f * g * a;
}

c = multiply(20, 30);
```

&ensp;&ensp;&ensp;&ensp; 运行上述JS代码所创建的执行上下文的伪代码看起来像这样：

```
// 全局执行上下文
GlobalExectionContext = {
  // this 绑定  
  ThisBinding: <Global Object>,
  // 词法环境
  LexicalEnvironment: {
    // 环境记录器(对象环境记录器)  
    EnvironmentRecord: {
      Type: "Object",
      // 标识符绑定，词法环境对应的是let,const还有函数声明
      a: < uninitialized >,
      b: < uninitialized >,
      multiply: < func >
    }
    // 外部环境引用(全局执行上下文的外部环境引用都是null)
    outer: <null>
  },
  // 变量环境
  VariableEnvironment: {
    // 环境记录器(全局执行上下文的词法环境和变量环境的环境记录器都是对象环境记录器)  
    EnvironmentRecord: {
      Type: "Object",
      // 在这里绑定标识符
      c: undefined,
    }
    outer: <null>
  }
}
// 函数执行上下文
FunctionExectionContext = {
    
  ThisBinding: <Global Object>,

  LexicalEnvironment: {
    EnvironmentRecord: {
      Type: "Declarative",
      // 在这里绑定标识符
      Arguments: {0: 20, 1: 30, length: 2},
    },
    outer: <GlobalLexicalEnvironment>
  },

  VariableEnvironment: {
    EnvironmentRecord: {
      Type: "Declarative",
      // 在这里绑定标识符
      g: undefined
    },
    outer: <GlobalLexicalEnvironment>
  }
}
```

&ensp;&ensp;&ensp;&ensp; 只有遇到调用函数 multiply 时，函数执行上下文才会被创建。可能你已经注意到 let 和 const 定义的变量并没有关联任何值，但 var 定义的变量被设成了 undefined。这是因为在创建阶段时，引擎检查代码找出变量和函数声明，虽然函数声明完全存储在环境中，但是变量最初设置为 undefined（var 情况下），或者未初始化（let 和 const 情况下）。这就是为什么你可以在声明之前访问 var 定义的变量（虽然是 undefined），但是在声明之前访问 let 和 const 的变量会得到一个引用错误。这就是我们说的变量声明提升。

__4.3、执行上下文的执行阶段__

&ensp;&ensp;&ensp;&ensp; 这是整篇文章中最简单的部分。在此阶段，完成对所有这些变量的分配，最后执行代码。需要注意的是：在执行阶段，如果 JavaScript 引擎不能在源码中声明的实际位置找到 let 变量的值，它会被赋值为 undefined。













