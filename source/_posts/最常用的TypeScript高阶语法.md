---
title: 最常用的TypeScript高阶语法
date: 2024-11-01 09:28:23
tags:
- TypeScript
---

#### __1、接口（Interfaces）__

* 用途：定义对象的形状，包括其属性和方法的类型。

* 示例：

```typescript
interface User {
    name: string;
    age?: number; // 可选属性
    greet(): void;
}

let user: User = {
    name: "Alice",
    greet() {
        console.log("Hello, " + this.name);
    }
};
```

#### __2、泛型（Generics）__

* 用途：在定义函数、接口或类时不具体指定类型，使得它们可以用于多种数据类型。

* 示例：

```typescript
function identity<T>(arg: T): T {
    return arg;
}

let output = identity<string>("myString");  // 明确指定 T 为 string
let output2 = identity("myString");  // 类型推断
```

#### __3、枚举（Enums）__

* 用途：定义一组有相同意义的常量。

* 示例：

```typescript
enum Direction {
    Up,
    Down,
    Left,
    Right
}

let dir: Direction = Direction.Up;
```

#### __4、类型别名（Type Aliases）__

* 用途：给类型设置别名。

* 示例：

```typescript
type Point = {
    x: number;
    y: number;
};

function drawCoord(point: Point) {
    console.log(`X: ${point.x}, Y: ${point.y}`);
}
```

#### __5、联合类型和交叉类型__

* __联合类型（Union Types）__ 允许一个值具有多种类型之一。

* __交叉类型（Intersection Types）__ 结合多个类型成为一个类型。

* 示例

```typescript
// 联合类型
type StringOrError = string | Error;

// 交叉类型
type Employee = User & { employeeId: number; };

let worker: Employee = {
    name: "Bob", employeeId: 1234, greet() {
        console.log("Hello");
    }
};
```

#### __6、模块（Modules）__

* 用途：组织和重用代码。

* 示例：

```typescript
// file: mathUtils.ts
export function add(x: number, y: number): number {
  return x + y;
}

// file: main.ts
import { add } from "./mathUtils";

console.log(add(1, 2));
```

#### __7、装饰器（Decorators）__

* 用途：为类和类成员提供额外的元数据声明和注释功能。

* 示例：

```typescript
function sealed(constructor: Function) {
  Object.seal(constructor);
  Object.seal(constructor.prototype);
}

@sealed
class Greeter {
  greeting: string;
  constructor(message: string) {
    this.greeting = message;
  }
  greet() {
    return "Hello, " + this.greeting;
  }
}
```

#### __8、类型声明文件（.d.ts）__

* 用途：提供 JavaScript 库的类型信息，使 TypeScript 编译器能理解库的结构，从而提供类型安全和智能代码补全。

* 示例：

```typescript
// calculator.js
function add(a, b) {
    return a + b;
}

function subtract(a, b) {
    return a - b;
}

// calculator.d.ts
declare function add(a: number, b: number): number;
declare function subtract(a: number, b: number): number;

// 这个声明文件告诉 TypeScript 编译器，add 和 subtract 函数都接受两个数字参数，并返回一个数字。
```


