---
title: TypeScript类型系统
date: 2024-10-30 15:20:06
tags:
- TypeScript
---

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; TypeScript 的类型系统可以分为多个层次，涵盖从原始类型到高级类型的各个方面。这种类型系统旨在提供强大的类型检查和推断功能，使开发者能够在编写代码时发现潜在的错误并提高代码的可读性和维护性。

#### __TypeScript 类型系统概述__

##### __1、原始类型（Primitive Types）__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 直接使用的基本数据类型。

* string：字符串

* number：数值（整数和浮点数）

* boolean：布尔值

* null：空值

* undefined：未定义

* bigint：大整数

* symbol：符号

##### __2、特殊类型__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 特殊用途类型，适用于灵活的数据结构和类型控制。

* any：任意类型，跳过类型检查

* unknown：未知类型，更安全的 any

* void：没有返回值（通常用于函数返回类型）

* never：永不返回的类型（例如抛出错误的函数）

* object：非原始类型的对象

##### __3、复合类型（Compound Types）__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 由多个基本类型或其他类型组合而成的类型

* 数组类型（Array Types）：表示同类型元素的集合，可以使用 T[] 或 Array<T> 语法

* 元组类型（Tuple Types）：固定长度的数组，每个元素类型都已知，如 [string, number]

* 联合类型（Union Types）：变量可以是多个类型之一，用 | 分隔

* 交叉类型（Intersection Types）：类型的组合，用 & 分隔，表示具有所有类型特征的类型

##### __4、字面量类型（Literal Types）__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 特定的字符串、数值或布尔值类型，常用于定义更精准的变量类型：

* 字符串字面量："hello"

* 数字字面量：42

* 布尔字面量：true

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 联合字面量类型：多个字面量的联合，如 type Direction = "left" | "right"。

##### __5、类型别名（Type Aliases）__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 使用 type 定义的自定义类型名称，用于简化复杂类型定义。

```typescript
type UserID = string | number;
```

##### __6、接口（Interfaces）__

* 定义对象的结构，可以包含属性和方法。

* 支持继承和多重继承，用于描述对象的形状。

```typescript
interface Person {
    name: string;
    age: number;
}
```

##### __7、类类型（Class Types）__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 类是 TypeScript 的核心类型之一，可以包含属性、构造函数和方法。可以实现接口和使用泛型约束。

```typescript
interface UserInterface {
    name: string;
    age: number;
    email: string;

    getDetails(): string;

    isAdult(): boolean;
}

class User implements UserInterface {
    // 类的属性
    name: string;
    age: number;
    email: string;

    // 构造函数
    constructor(name: string, age: number, email: string) {
        this.name = name;
        this.age = age;
        this.email = email;
    }

    // 实现接口中的方法
    getDetails(): string {
        return `Name: ${this.name}, Age: ${this.age}, Email: ${this.email}`;
    }

    isAdult(): boolean {
        return this.age >= 18;
    }
}
```

##### __8、枚举类型（Enums）__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 表示一组命名常量的集合，用于有固定选择项的场景。

```typescript
enum Direction {
    Up,
    Down,
    Left,
    Right,
}
```

##### __9、泛型（Generics）__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 用于创建参数化的类型，使代码在类型安全的前提下能够适应多种类型。可以用于函数、接口和类中。

```typescript
function identity<T>(arg: T): T {
    return arg;
}
```

##### __10、类型推断与类型保护__

* __类型推断：__ TypeScript 根据上下文自动推断变量类型。

* __类型保护（Type Guards）：__ 在代码中使用 typeof、instanceof、in 等来判断和限制变量的类型。

* __自定义类型谓词：__ 通过自定义函数检查特定类型。

##### __11、条件类型（Conditional Types）__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 通过条件表达式定义类型，根据条件返回不同的类型。

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 案例一：

```typescript
type IsString<T> = T extends string ? true : false;
```

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 案例二：

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 判断类型是否为数组类型：我们将定义一个条件类型 IsArray<T>，用于检查类型 T 是否为数组类型。如果 T 是数组类型，则返回 true，否则返回 false。

```typescript
// 定义条件类型 IsArray<T>
type IsArray<T> = T extends any[] ? true : false;

// 使用条件类型进行测试
type Test1 = IsArray<string>;      // false
type Test2 = IsArray<number[]>;    // true
type Test3 = IsArray<[number]>;    // true
type Test4 = IsArray<boolean>;     // false
type Test5 = IsArray<never[]>;     // true
type Test6 = IsArray<{ name: string }[]>; // true

// 输出测试结果
const testResults: [Test1, Test2, Test3, Test4, Test5, Test6] = [
  false,   // Test1: string is not an array
  true,    // Test2: number[] is an array
  true,    // Test3: tuple [number] is an array
  false,   // Test4: boolean is not an array
  true,    // Test5: never[] is an array
  true,    // Test6: array of objects is an array
];

console.log(testResults);
```

##### __12、映射类型（Mapped Types）__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 基于已知类型创建新类型，允许对类型属性进行映射和转换。下面是一个综合案例，展示了如何使用 TypeScript 的 映射类型（Mapped Types） 来创建一个实用的类型工具。这个案例通过映射类型创建了多个类型工具，例如将对象的所有属性设为可选、只读、或可为空的类型。在这个案例中，我们将定义以下几个类型工具：

* Optional<T>：将对象的所有属性设为可选。

* Readonly<T>：将对象的所有属性设为只读。

* Nullable<T>：将对象的所有属性设为可为空（null）。

```typescript
// 定义一个基础接口
interface User {
  id: number;
  name: string;
  email: string;
}

// 1. Optional<T>：将对象的所有属性设为可选
type Optional<T> = {
  [P in keyof T]?: T[P];
};

// 2. Readonly<T>：将对象的所有属性设为只读
type Readonly<T> = {
  readonly [P in keyof T]: T[P];
};

// 3. Nullable<T>：将对象的所有属性设为可为空（null）
type Nullable<T> = {
  [P in keyof T]: T[P] | null;
};

// 测试各个映射类型工具

// 使用 Optional<T> 工具
type OptionalUser = Optional<User>;
const optionalUser: OptionalUser = {
  // 所有属性变成可选的
  name: "Alice",
};

// 使用 Readonly<T> 工具
type ReadonlyUser = Readonly<User>;
const readonlyUser: ReadonlyUser = {
  id: 1,
  name: "Bob",
  email: "bob@example.com"
};
// readonlyUser.id = 2; // Error: Cannot assign to 'id' because it is a read-only property.

// 使用 Nullable<T> 工具
type NullableUser = Nullable<User>;
const nullableUser: NullableUser = {
  id: null,
  name: null,
  email: "charlie@example.com",
};

// 输出示例
console.log("OptionalUser:", optionalUser);
console.log("ReadonlyUser:", readonlyUser);
console.log("NullableUser:", nullableUser);
```

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 映射类型 Optional<T>：通过 [P in keyof T]? 语法将对象 T 的所有属性变为可选属性，即所有属性后面添加 ?。

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 示例中 OptionalUser 类型的所有属性都是可选的，因此可以只定义部分属性。映射类型 Readonly<T>：通过 readonly [P in keyof T] 将对象 T 的所有属性设为只读属性。

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 示例中 ReadonlyUser 类型的所有属性都是只读的，因此尝试更改任何属性都会报错。映射类型 Nullable<T>：通过 [P in keyof T]: T[P] | null 将对象 T 的所有属性类型变为可为空，即所有属性的类型添加 null。

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 示例中 NullableUser 类型的所有属性都可以为 null。

##### __13、模板字面量类型（Template Literal Types）__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 通过模板字符串生成新的字符串字面量类型。

```typescript
type Greeting = `Hello, ${string}`;
```

#### __TypeScript 类型系统架构图__

```text
                           ┌────────────────────┐
                           │ TypeScript 类型系统 │
                           └────────────────────┘
                                    │
    ┌──────────────┬────────────────┼─────────────────────┬─────────────┐
    │              │                │                     │             │
┌───▼─────┐    ┌─────▼────┐    ┌──────▼─────┐      ┌────────▼─────┐ ┌─────▼─────┐
│ 原始类型 │    │ 特殊类型   │   │ 复合类型    │      │ 字面量类型     │ │ 类型别名   │
└───┬─────┘    └─────┬────┘    └──────┬─────┘      └──────────────┘ └─────┬─────┘
    │                │                │                                   │
 ┌──▼────┐      ┌────▼───┐    ┌───────▼─────┐                          ┌──▼────────────┐
 │string │      │ any    │    │数组 / 元组类型│                          │接口 (Interface)│
 │number │      │ unknown│    │联合类型      │                          └───────────────┘
 │boolean│      │ void   │    │交叉类型      │      
 │null   │      │ never  │    │             │      
 │...    │      │ object │    └─────────────┘       
 └───────┘      └────────┘
    
                ┌───────────────┬───────────────────────────┬─────────────────────┐
                │               │                           │                     │
           ┌────▼────┐    ┌─────▼──────────┐       ┌──────▼────────┐       ┌────▼──────┐
           │ 枚举类型 │    │ 泛型 (Generics) │       │ 类类型 (Class) │       │ 条件类型   │
           └─────────┘    └────────────────┘       └───────────────┘       └───────────┘
                ┌──────────────────────────────────────────┐
                │                                          │
           ┌────▼─────────────┐                     ┌──────▼─────────┐
           │ 映射类型 (Mapped) │                     │ 模板字面量类型    │
           └──────────────────┘                     └────────────────┘

```











