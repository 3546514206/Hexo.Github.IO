---
title: TypeScript常见基础语法
date: 2024-11-06 09:48:12
tags:
- TypeScript
---

#### __1、变量声明 (Variable Declarations)__

&ensp;&ensp;&ensp;&ensp; TypeScript 支持使用 let、const 和 var 声明变量，类型可以显式指定。

```typescript
let name: string = 'Alice';  // let 声明的变量，可以修改
const age: number = 25;      // const 声明的常量，不能修改
let isActive: boolean = true; // 声明一个布尔类型的变量

// 变量的类型可以自动推导
let greeting = 'Hello, TypeScript!';  // 类型推导为 string
```

#### __2、基本类型 (Basic Types)__

&ensp;&ensp;&ensp;&ensp; TypeScript 支持多种基础数据类型，包括 string、number、boolean、null、undefined、any。

```typescript
let isAlive: boolean = true;        // 布尔类型
let age: number = 30;               // 数字类型
let firstName: string = 'John';     // 字符串类型
let nothing: null = null;           // null 类型
let undef: undefined = undefined;   // undefined 类型
let anyValue: any = 42;             // any 类型，可以赋予任何类型的值
```

#### __3、数组 (Arrays)__

&ensp;&ensp;&ensp;&ensp; 数组在 TypeScript 中可以通过两种方式定义类型。

```typescript
let numbers: number[] = [1, 2, 3];  // 数字数组
let names: Array<string> = ['Alice', 'Bob'];  // 字符串数组

// 使用推导类型
let mixArray = [1, 'Hello', true]; // TypeScript 会自动推导类型为 (number | string | boolean)[]
```

#### __4、元组 (Tuples)__

&ensp;&ensp;&ensp;&ensp; 元组是一个具有固定大小和固定类型的数组。

```typescript
let numbers: number[] = [1, 2, 3];  // 数字数组
let names: Array<string> = ['Alice', 'Bob'];  // 字符串数组

// 使用推导类型
let mixArray = [1, 'Hello', true]; // TypeScript 会自动推导类型为 (number | string | boolean)[]
```

#### __5、枚举 (Enum)__

&ensp;&ensp;&ensp;&ensp; 枚举用于定义具有命名常量的类型。TypeScript 提供了数字和字符串枚举。

```typescript
enum Color {
    Red = 1,
    Green = 2,
    Blue = 4
}

let c: Color = Color.Green;  // 使用枚举
console.log(c);  // 输出: 2
```

#### __6、函数 (Functions)__

&ensp;&ensp;&ensp;&ensp; TypeScript 函数可以显式声明参数类型和返回值类型。

```typescript
// 函数声明，返回值是 string 类型
function greet(name: string): string {
    return `Hello, ${name}!`;
}

console.log(greet('Alice'));  // 输出: Hello, Alice!

// 无返回值函数，返回类型为 void
function logMessage(message: string): void {
    console.log(message);
}

logMessage('This is a message');

// 函数立即调用
let str = (function (a: number, b: number): string {
    console.log(a + b);
    return "ok";
})(3, 4);

console.log(str);
```

#### __7、接口 (Interfaces)__

&ensp;&ensp;&ensp;&ensp; 接口用于定义对象的结构，可以定义属性和方法。

```typescript
interface Person {
    name: string;
    age: number;
    greet(): string;  // 修改返回类型为 string
}

const person: Person = {
    name: 'Alice',
    age: 30,
    greet: () => {
        console.log('Hello!');
        return 'Hello, ' + this.name;  // 返回一个字符串
    },
};

const greeting = person.greet();  // 调用 greet 方法并获取返回值
console.log(greeting);  // 输出: Hello, Alice
```

#### __8、类 (Classes)__

&ensp;&ensp;&ensp;&ensp; TypeScript 支持基于类的面向对象编程，可以定义构造函数、方法和访问控制符。

```typescript
class Animal {
    name: string;

    constructor(name: string) {
        this.name = name;
    }

    speak(): void {
        console.log(`${this.name} makes a noise`);
    }
}

class Dog extends Animal {
    constructor(name: string) {
        super(name);  // 调用父类构造函数
    }

    speak(): void {
        console.log(`${this.name} barks`);
    }
}

const dog = new Dog('Buddy');
dog.speak();  // 输出: Buddy barks
```

#### __9、类型别名 (Type Aliases)__

&ensp;&ensp;&ensp;&ensp; type 用来为类型创建别名，通常用于复杂类型的重用。

```typescript
type Point = {
    x: number;
    y: number;
};

const point: Point = { x: 10, y: 20 };  // 使用类型别名
```

#### __10、联合类型 (Union Types)__

&ensp;&ensp;&ensp;&ensp; type 用来为类型创建别名，通常用于复杂类型的重用。

```typescript
let id: string | number = 42;   // 可以是字符串或数字
id = 'abc';  // 也可以是字符串

// 函数中使用联合类型
function printId(id: string | number): void {
    console.log(id);
}

printId(123);  // 输出: 123
printId('abc');  // 输出: abc
```

#### __11、类型断言 (Type Assertion)__

&ensp;&ensp;&ensp;&ensp; 类型断言告诉 TypeScript 编译器将一个类型视为另一个类型，通常用于 any 类型的转换。

```typescript
let someValue: any = 'Hello, TypeScript';
let strLength: number = (someValue as string).length;  // 类型断言
console.log(strLength);  // 输出: 17
```

#### __12、可选属性 (Optional Properties)__

&ensp;&ensp;&ensp;&ensp; 通过 ? 标记属性为可选属性。

```typescript
interface Car {
    brand: string;
    model: string;
    year?: number;  // 可选属性
}

let myCar: Car = { brand: 'Toyota', model: 'Camry' };  // 不需要提供 year 属性
```

#### __13、只读属性 (Readonly Properties)__

&ensp;&ensp;&ensp;&ensp; readonly 修饰符表示属性不可修改。

```typescript
interface User {
    readonly id: number;
    name: string;
}

let user: User = { id: 1, name: 'John' };
user.name = 'Doe';  // 允许修改
// user.id = 2;  // 错误，无法修改 readonly 属性
```

#### __14、函数类型 (Function Types)__

&ensp;&ensp;&ensp;&ensp; 你可以为函数指定参数和返回值类型。

```typescript
// 直接声明函数类型
let add: (x: number, y: number) => number;

add = (x, y) => x + y;  // 函数赋值
console.log(add(2, 3));  // 输出: 5
```

#### __15、泛型 (Generics)__

&ensp;&ensp;&ensp;&ensp; 泛型允许你在函数、类或接口中定义一个占位符类型，调用时再传入具体类型。

```typescript
// 泛型函数
function identity<T>(arg: T): T {
    return arg;
}

let output = identity<string>('Hello');
console.log(output);  // 输出: Hello

// 泛型类
class Box<T> {
    value: T;
    constructor(value: T) {
        this.value = value;
    }
}

let box = new Box<number>(123);
console.log(box.value);  // 输出: 123
```

#### __16、模块和导入导出 (Modules)__

&ensp;&ensp;&ensp;&ensp; TypeScript 支持 ES6 模块语法，可以使用 export 和 import 来导出和导入代码。

```typescript
// person.ts
export class Person {
    constructor(public name: string) {}
}

// main.ts
import { Person } from './person';  // 导入 person.ts 中的 Person 类

let person = new Person('Alice');
console.log(person.name);  // 输出: Alice
```

#### __17、装饰器 (Decorators)__

&ensp;&ensp;&ensp;&ensp; 装饰器是 TypeScript 的实验性功能，可以为类、方法、属性、参数等添加额外的行为。

```typescript
function log(target: any, propertyKey: string, descriptor: PropertyDescriptor) {
    console.log(`Method ${propertyKey} is called`);
}

class Greeter {
    @log
    greet() {
        console.log('Hello!');
    }
}

let greeter = new Greeter();
greeter.greet();  // 输出: Method greet is called
                  // 输出: Hello!
```

#### __18、类型守卫 (Type Guards)__

&ensp;&ensp;&ensp;&ensp; 类型守卫是通过 typeof 或 instanceof 来检查变量类型。

```typescript
function isString(value: any): value is string {
    return typeof value === 'string';
}

function greet(value: string | number) {
    if (isString(value)) {
        console.log(`Hello, ${value}`);
    } else {
        console.log('Hello, Guest');
    }
}

greet('Alice');  // 输出: Hello, Alice
greet(42);       // 输出: Hello, Guest
```