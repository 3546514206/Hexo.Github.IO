---
title: C++从遗忘到入门
date: 2024-04-02 08:48:14
tags:
- C++
---

__1、受众__ 

&ensp;&ensp;&ensp;&ensp; 本文主要面向的是曾经学过、了解过C++的同学，旨在帮助这些同学唤醒C++的记忆，提升下自身的技术储备。如果之前完全没接触过C++，也可以整体了解下这门语言。

&ensp;&ensp;&ensp;&ensp; C++是一种通用编程语言，它被广泛用于软件开发。C++以其强大的功能、高效的性能和灵活性而著称。以下是一些关键特点：

&ensp;&ensp;&ensp;&ensp; __面向对象：__ C++支持面向对象编程（OOP）的四大特性：封装、继承、多态和抽象。通过类和对象，程序员能够创建模块化的代码，更容易地进行维护和扩展。

&ensp;&ensp;&ensp;&ensp; __泛型编程：__ C++支持模板编程，允许编写与数据类型无关的代码。模板是实现泛型编程的关键工具，它们提高了代码的复用性。

&ensp;&ensp;&ensp;&ensp; __直接内存管理：__ C++提供了对内存的直接操作能力，允许程序员手动管理内存分配和释放，这是C++的一个强大特性，也是需要谨慎使用的地方，因为不当的内存管理可能会导致资源泄露和其他问题。

&ensp;&ensp;&ensp;&ensp; __性能：__ C++编写的程序通常有很高的执行效率，这是因为C++提供了与底层硬件直接对话的能力。这使得C++成为开发要求性能的系统软件（如操作系统、游戏引擎）的理想选择。

&ensp;&ensp;&ensp;&ensp; __C 语言兼容：__ 大部分C语言程序可以在C++编译器上编译并运行。这一特性简化了从C到C++的过渡。

&ensp;&ensp;&ensp;&ensp; 多编程范式支持：除了面向对象和泛型编程外，C++还支持过程式编程和函数式编程等范式，使其成为一个多样化的工具，能适应不同的编程需求。

&ensp;&ensp;&ensp;&ensp; C++语言的复杂劝退了很多人，诸如指针、虚函数、泛型等语言特性让C++变得特别复杂。事实也确实如此，不过C++的作者说过：“轻松地使用这种语言。不要觉得必须使用所有的特性，不要在第一次学习时就试图使用所有特性。”

&ensp;&ensp;&ensp;&ensp; 本文主要内容是介绍现代C++（C++11及之后的版本）中的语法和特性，不会深入语法细节，每小节最后可能会列出一些相关的拓展知识点，感兴趣的同学可以自行了解。

__2、语法基础__

__2.1、类型__

&ensp;&ensp;&ensp;&ensp; C++是静态编译语言，所有变量在声明时都要指定具体的变量类型，或者能让编译器推导出具体的变量类型（比如使用 auto、decltype 关键字的场景），类型检查不通过将导致编译期出错。

__2.1.1、基础类型__

&ensp;&ensp;&ensp;&ensp; C++的基础类型可以按照其所能表示的数据类型来分类。以下表格列出了C++的基础类型及其常见的大小和范围（请注意，实际的大小和范围可能根据平台和编译器的不同而有所变化）：

![基础类型](/pic/基本功/编程基础/从遗忘到入门/基础类型.png)

&ensp;&ensp;&ensp;&ensp; 语法示例：
```C++
// 声明未初始化，使用前建议手动初始化
nt a;      
char b = 'a';
// C++中默认小数是double类型，加上f可以指定为float
float c = 1.0f;  
double d = 2.0;
// 编译器自动推导auto为 int 类型
auto e = 20;  
```

&ensp;&ensp;&ensp;&ensp; 编译器自动进行的类型转换，不需要程序员进行任何操作。这些转换通常在类型兼容的情况下发生，比如从小的整数类型转换到大的整数类型。下面是经常遇到的隐式类型转换：

&ensp;&ensp;&ensp;&ensp; 安全的隐式转换：

* 整型提升：小的整型（如 char、short）会自动转换成较大的整型（如 int）。

* 算数转换：例如，当 int 和 double 混合运算时，int 会转换为 double。

&ensp;&ensp;&ensp;&ensp; 存在隐患的隐式转换：

* 窄化转换：大的整数类型转换到小的整数类型，或者浮点数转换到整数，可能会造成数据丢失或截断。

* 指针转换：例如，将 void* 转换为具体类型的指针时，如果转换不正确，会导致未定义行为。

__2.1.2、结构体（struct）__

&ensp;&ensp;&ensp;&ensp; 结构体是不同类型数据的集合，允许将数据组织成有意义的组合。语法示例：

```C++
// 结构体定义
struct Person {    
    std::string name;
    int age;
}

// 结构体初始化，
Person person = {"Jim", 20};    

// 创建另一个实例
Person person2; 
// 将person中的值复制到person2中，默认是浅拷贝，在有指针的情况下有潜在风险
person2 = person;
```

&ensp;&ensp;&ensp;&ensp; 枚举是一种用户定义的类型，它可以赋予一组整数值具有更易读的别名。语法示例：

```C++
enum Color { RED, GREEN, BLUE };

// 使用
Color myColor = RED;
```

&ensp;&ensp;&ensp;&ensp; C++11引入了新的枚举类型，作用域枚举。语法示例：

```C++
enum class Color {
    RED,
    GREEN,
    BLUE
};

// 使用作用域解析运算符(::)访问枚举值
Color myColor = Color::RED; 
```

&ensp;&ensp;&ensp;&ensp; 作用域枚举解决了传统枚举可能导致命名冲突的问题，并提供了更强的类型检查。

&ensp;&ensp;&ensp;&ensp; __2.1.3、联合体（union）__

联合体允许在相同的内存位置存储不同类型的数据，但一次只能使用其一。语法示例：

```C++
// 联合体的定义
union Data {
    int intValue;
    float floatValue;
    char charValue;
}

// 联合体一次只能保存一种类型的数据，每次赋值都会覆盖内存中之前的值
// 因此联合体一般是配合结构体来使用，下面是一个示例

// 定义数据类型的枚举
enum DataType {
    INT,
    FLOAT,
    CHAR
};

// 定义一个结构体，它包含一个联合体和一个枚举标签
struct SafeUnion {
    // 标记当前联合体中存储的数据类型
    DataType type;

    // 定义联合体
    union {
        int intValue;
        float floatValue;
        char charValue;
    } data;
};

// 赋值操作
SafeUnion su;
su.type = FLOAT;
su.data.floatValue = 1.0f;

// 使用时，通过type判断类型然后访问联合体对应的成员变量
switch(su.type) {
    case FLOAT:
        cout << su.data.floatValue << endl;
        break;

}
```

__2.1.3、类（class）__

&ensp;&ensp;&ensp;&ensp; 类是C++的核心特性，是面向对象的基础，允许将数据和操作这些数据的函数封装为一个对象。这里先只介绍定义。语法示例：

```C++
class Person {

public:
    void doWork();     // 方法，类对外提供的一系列操作实例的函数

private:
    std::string name;   // 成员变量，封装到类中的属性，保存内部状态信息
    int age;
};
```

__2.1.4、列表初始化__

&ensp;&ensp;&ensp;&ensp; 现代C++提供了一种新的统一的变量初始化方式 - 列表初始化，推荐优先使用这种初始化方式，它能提供更加直观和统一的数据初始化方式。列表初始化使用 {} 来初始化数据对象，包括基础类型、数组、结构体、类和容器等复杂的数据类型。语法示例：

```C++
// 基础类型
int a{0};  
double b{3.14}; 

// 结构体
struct MyStruct {
    int x;
    double y;
};

MyStruct s{1, 2.0};

// 类
class MyClass {
public:
    MyClass(int a, double b) : a_(a), b_(b) {}
private:
    int a_;
    double b_;
};

MyClass obj{5, 3.14}; // MyClass 必须有一个匹配这个参数列表的构造函数

// 数组
int arr[3]{1, 2, 3};

// 上面介绍的都是现代C++推荐写法，省略 = 
// 下面的2种写法绝大多数情况下是等价的
float arr[2]{1, 2};        // 写法1
float arr[2] = {1, 2};    // 写法2
// 编译器对这两种写法的处理是一致的，方法2并不会产生临时变量和拷贝赋值，包括类的声明
```

&ensp;&ensp;&ensp;&ensp; 现代C++推荐优先使用列表初始化来初始化变量，因为这种方式不允许进行窄化转换这能避免一些问题的发生，示例：

```C++
int a = 7.7;   // 编译能通过，但是有warning
int b = {1.0}; // 编译器拒绝通过，因为浮点到整形的转换会丢失精度
```

&ensp;&ensp;&ensp;&ensp; 列表初始化支持参数列表小于数据对象的个数，这种情况下会默认进行其他变量的零初始化。

__2.2、数组__

&ensp;&ensp;&ensp;&ensp; C++的数组是一个固定大小的序列容器，它可以存储特定类型的元素的集合。数组中的元素在内存中连续存储，这允许快速的随机访问，即可以直接通过索引访问任何元素，而无需遍历数组。

__2.2.1、数组的声明__

数组的声明形式如下：

```C++
Typename arrayName[Size];    

// 基本类型
int arr[10];
char charArr[30];

// 复杂类型
struct Point {
    int x;
    int y;
}
Point points[10];
```

&ensp;&ensp;&ensp;&ensp; 这里 Typename 是数组中元素的数据类型，arrayName 是数组的变量名，Size 是数组的元素个数，在这种声明形式下必须是整形的常量。

&ensp;&ensp;&ensp;&ensp; 这里介绍的方式是数组的静态声明方式，即数组的元素个数在编译期间就能确定，数组占用的内存分配在栈内存中，实际开发中更多的情况可能是更具运行时的值确定数组的大小，这时需要动态的方式声明数组，后面会介绍。

__2.2.2、数组的初始化__

&ensp;&ensp;&ensp;&ensp; 数组定义时如果未进行初始化，那么数组中的元素的值都是内存中残留的数据，而这些数据通常没有意义，直接使用会导致不可预知的问题。因此声明数组后需要对数组进行必要地初始化。数组支持列表初始化语法：

```c++
// 数组大小为5，编译器自动确定
int arr[] = {1, 2, 3, 4, 5};
// 数组前三项确定为1，2，3，其余被初始化为0     
int arr[10] = {1, 2, 3};   
// 整个数组全部为0 
int arr[10] = {0};         
```

__2.2.3、数组的使用__

&ensp;&ensp;&ensp;&ensp; 数组中的元素可以通过索引来访问和修改，索引从0开始，第一元素索引是0，最后一个索引是Size-1。

```C++
// 零初始化
nt arr[10] = {};  
// 修改数组第一个元素值为10
arr[0] = 10;      
```

* 数组在声明后（无论静态声明还是动态声明），数组的大小即固定，不可更改；

* 数组不提供任何内置的方法来获取其大小，通常需要额外保存数组的大小，或者使用特殊标记结束元素（C风格的字符串使用'\0'表示数组结束）；

* 数组不提供边界检查，越界访问的代码是可以通过编译的（静态数组编译器会给出警告），可能导致很多潜在问题。

&ensp;&ensp;&ensp;&ensp; 下面是越界访问的案例：

```C++
int arr[10] = {0}; 
// 最大的有效索引是9，这里出现越界，但编译器能顺利编译通过（有警告） 
int a = arr[10];   
// a中的值是不确定的，没有实际意义的，这里是读取，危害可能有限

arr[10] = 99; 
// 可怕的是该语句也能通过编译，但这里进行了更加危险的操作，
// 越界访问了一块内存并修改了其内容，这很可能导致程序崩溃
```

__2.2.4、多维数组__

__2.2.4.1、二维数组__

&ensp;&ensp;&ensp;&ensp; 上面提到的数组存储的是一维的，即一系列同类型数据，但有时需要存储一个表格数据，需要区分行列，这时可以使用二维数组来存储。

```C++
// Rows是行数， Columns是列数， 必须常量
Typename arrayName[Rows][Columns];  

// 实际示例
// 定义了一个10*10的二维数组
int arr[10][10];  
```

&ensp;&ensp;&ensp;&ensp; 下面是二维数组的初始化：

```C++
// 完全初始化
int matrix[2][3] = {
    {1, 2, 3},
    {4, 5, 6}
};

// 部分初始化
int matrix[2][3] = {
    {1, 2}, // 第一行的最后一个元素将被初始化为 0
    {4}     // 第二行的第二个和第三个元素将被初始化为 0
};

// 单行初始化
int matrix[2][3] = {1, 2, 3}; // 只初始化第一行，其他行将默认初始化为0

// 自动推断，和一维数组一样，编译器会根据数组推断二维数组第一维的大小
int matrix[][3] = {
    {1, 2, 3},
    {4, 5, 6}
};
```


__2.2.4.1、多维数组__

&ensp;&ensp;&ensp;&ensp; 多维数据是和二维数组类似，在基础上再增加一维:

```C++
Typename arrayName[Depth][Rows][Columns];
```

&ensp;&ensp;&ensp;&ensp; 当然可以推广这个概念，定义出四维、五维等等数组形式，这里不展开。

__2.2.5、数组的替代__

&ensp;&ensp;&ensp;&ensp; 数组本身是一种常见的C++数据类型，使用范围很广，但是本身也存在局限性。因此为了提升开发效率，C++标准库中提供了更加灵活的数据容器供开发者使用：

* std::vector: 可变大小的数组。提供对元素的快速随机访问，并能高效地在尾部添加和删除元素。

* std::list 双向链表。支持在任何位置快速插入和删除元素，但不支持快速随机访问。

* std::deque: 双端队列。类似于std::vector，但提供在头部和尾部快速添加和删除元素的能力。

* std::array (C++11): 固定大小的数组。提供对元素的快速随机访问，并且其大小在编译时确定。

* std::forward_list (C++11): 单向链表。提供在任何位置快速插入和删除元素，但不支持快速随机访问。

* std::stack: 栈容器适配器。提供后进先出(LIFO)的数据结构。

* std::queue: 队列容器适配器。提供先进先出(FIFO)的数据结构。

* std::priority_queue: 优先队列容器适配器。元素按优先级出队，通常使用堆数据结构实现。

* std::set: 一个包含排序唯一元素的集合。基于红黑树实现。

* std::multiset: 一个包含排序元素的集合，元素可以重复。基于红黑树实现。

* std::unordered_set (C++11): 一个包含唯一元素的集合，但不排序。基于散列函数实现。

* std::unordered_multiset (C++11): 一个包含元素的集合，元素可以重复，但不排序。基于散列函数实现。

__2.3、指针__

&ensp;&ensp;&ensp;&ensp; 在C++中，指针是一种基础数据类型，它存储了内存地址的值。通过指针，可以直接读取或修改相应内存地址处的数据。指针是C/C++强大功能的一个关键组成部分，允许直接操作内存，这在底层编程和系统编程中非常有用，但这一切能力的代价就是指针操作的高风险。

__2.3.1、理解指针__

&ensp;&ensp;&ensp;&ensp; 下面是简单的整形变量和整形指针变量在内存中的示意图:

![理解指针](/pic/基本功/编程基础/从遗忘到入门/理解指针.webp)

&ensp;&ensp;&ensp;&ensp; 可以看出：

* a是一个整形，占用4个字节（一般int类型占用4字节），0xffffffffffffecdc是其首地址，内存中的值是2568，即代码中的赋值（具体的存储细节可以搜索 大端序、小端序）。

* p是一个整形指针，占用8个字节（64位系统），0xffffffffffffece0是其首地址，内存中的值是a变量内存的首地址，即0xffffffffffffecdc。

&ensp;&ensp;&ensp;&ensp; 通过示意图，可以知道指针本身是一种变量类型，和int、bool这些类型没有本质的区别，只不过其他类型的变量中存储的是数据，而指针类型变量中存储的内存地址。一旦理解了这个概念，那么指针的指针这一概念也不难理解，它本身是一个指针类型，其中存储的值是另一个指针的地址。

__2.3.2、指针的定义__

&ensp;&ensp;&ensp;&ensp; 指针的定义语法：

```C++
Typename * ptrName;

// 指针定义风格，下面的声明都正确
int *p;   // C风格，旨在强调 （*p）是一个整形值
int* p;    // 经典C++风格，只在强调 p是一个整形指针类型（int*）

// 阿里集团推荐的风格,指针、引用都是居中，两边留空格
int * p;     // 指针
int & a = xx;  // 左值引用
int && a = xx;  // 右值引用
```

__2.3.3、指针的初始化和访问__

&ensp;&ensp;&ensp;&ensp; 指针的赋值和访问语法如下：

```C++
int a = 5;
int * p = &a;      // & 取地址运算符

// * 用在指针这里是解引用运算符，可以获取指针指向的地址的值
cout << *p << endl;   // 输出  5

int b = 10;
p = &b;          // 指针变量可以修改其指向地址
cout << *p << endl;    // 输出 10
```

__2.3.4、常量指针 vs 指针常量__

__2.3.4.1、常量指针__

&ensp;&ensp;&ensp;&ensp; 常量指针指向一个常量值，不管指向的变量本身是否声明为常量都不能通过指针来修改指向的内容，但指针本身可以重新赋值指向新的地址。

```C++
int value = 5;
const int * p = &value;    // p是一个常量指针
int const * q = &value;   // 和上面的声明等价 
*p = 10;           // 非法，*p是常量不能修改

int a = 6;
p = &a;            // 合法，p本身不是常量，可以重新赋值
```

&ensp;&ensp;&ensp;&ensp; 常量指针在函数传参时非常有用，它可以限制函数内部通过指针非法地修改原始内容。

__2.3.4.2、指针常量__

&ensp;&ensp;&ensp;&ensp; 指针常量表示指针本身是常量，必须在声明时初始化，之后不能指向其他地址，但可以通过指针修改指向的内容。

```C++
int value = 5;
int * const p = &value;   // p是常量
*p = 6;     // 合法

int a = 7;
p = &a;    // 非法
```

&ensp;&ensp;&ensp;&ensp; 要记住这两种声明的区别有个简单的方法：看 const 修饰是什么：const int * p ：const修饰 *p，即 *p 是常量；int * const p ：const修饰 p，即 p 是常量。

__2.3.5、指针与数组__

__2.3.5.1、指针和数组名的异同__

&ensp;&ensp;&ensp;&ensp; 在C++中，数组名在绝大多数场景下可以看做是指针，在这些场景下数组名和指向该数组首个元素的指针是等价的。

```C++
int arr[5] = {1, 2, 3, 4, 5};
int * p1 = arr;     // arr 被当做指向数组首元素的指针
int * p2 = &arr[0];    // 取arr首个元素的地址
// 这种情况下 p1 和 p2 是等价的
if (p1 == P2) {      // 检测会通过
    cout << "p1,p2是等价的" << endl;  
    cout << *p1 << endl;  // 打印 1
    cout << *p2 << endl;   // 打印 1
}

// 使用指针访问数组
// 指针方式
cout << *(p1 + 1) << endl;  // 访问数组第二个元素，这种方式符合指针的计算规则
// 类似数组名的使用方式
cout << p1[1] << endl;// p1虽然是指针，索引访问方式依然有效，本质是*(p1 + 1)的语法糖
```

&ensp;&ensp;&ensp;&ensp; 指针和数组名有区别的地方：

```C++
int arr[5] = {1, 2, 3, 4, 5};
int * p1 = arr;

cout << sizeof(arr) << endl;  // 打印结果：20 
cout << sizeof(p1) << endl;    // 打印结果：8
// sizeof(arr)为数组本身的大小，这里是 5个int占用20字节
// sizeof(p1)为指针本身大小，64位系统中占用8个字节
```

&ensp;&ensp;&ensp;&ensp; 此外 &取地址运算符对于 指针和数组名的处理也是不同的：

```C++
// 0x16b98aa40
cout << &arr << endl;      
// 0x16b98aa54
cout << &arr + 1 << endl;   
// 0x16b98aa40 
cout << &arr[0] << endl;    
// 0x16b98aa44
cout << &arr[0] + 1 << endl;  

// 可以看出 &arr 和 &arr[0] 的值是一样的，但是指针偏移1后
// (&arr + 1) 在 &arr 的基础上偏移了20（0x14）个字节
// (&arr[0] + 1) 在 &arr[0] 的基础上偏移了4个字节
```

&ensp;&ensp;&ensp;&ensp; 对于数组名进行 & 取地址，得到的整个数组的地址，虽然值和首元素地址相同，但其指针类型是不同的。

* &arr 得到的类型是 int (*)[5] ，这是一个指向包含5个整数数组的指针。

* &arr[0]得到的类型是 int *，这是一个整型指针。

__2.3.5.2、动态数组__

&ensp;&ensp;&ensp;&ensp; 前面介绍的数据都是静态数组，实际开发中，可能更希望更具实际需要动态申请指定长度的数组，这时就需要动态数组。因为标准库中提供了std::vector容器，提供了更加方便的动态数组解决方案，因此这里简单介绍下：

```C++
nt * arr = new int[10];   // new操作符在堆内存中申请10个int类型大小的连续空间，并返回首地址
arr[0] = 1;
arr[1] = 2;
// ...
delete[] arr;      // new操作符申请的内存需要使用delete操作符释放，数组使用delete[]
```

&ensp;&ensp;&ensp;&ensp; 多维数组的创建和释放比一维要复杂一些，下面是示例：

```C++
// 二维数组的动态创建 & 释放
int rows = 5; // 行数
int cols = 3; // 列数

// 动态创建二维数组
int ** array = new int*[rows]; // 创建行指针
for (int i = 0; i < rows; ++i) {
    array[i] = new int[cols]; // 为每行分配内存
}

// 初始化二维数组
for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
        array[i][j] = i * cols + j; // 或者任何其他的赋值逻辑
    }
}

// 使用二维数组，例如打印它
for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
        std::cout << array[i][j] << ' ';
    }
    std::cout << std::endl;
}

// 动态释放二维数组
for (int i = 0; i < rows; ++i) {
    delete[] array[i]; // 释放每行的内存
}
delete[] array; // 释放行指针数组的内存
```

__2.4、函数__

&ensp;&ensp;&ensp;&ensp; 在 C++ 中，函数是一段执行特定任务的代码块，它具有一个名字，可以接受输入参数（也可以不接受），并可以返回一个值（也可以不返回，即返回类型为 void）。函数的主要目的是使代码更模块化、更易于管理，并且可以重用。

__2.4.1、函数基础__

&ensp;&ensp;&ensp;&ensp; C++的完整函数定义包括以下几个要素：

* 返回类型：函数可能返回的值的数据类型。如果函数不返回任何值，则使用关键字 void。

* 函数名：用于识别函数的唯一名称。

* 参数列表：括号内的变量列表，用于从调用者那里接收输入值。如果函数不接受任何参数，则参数列表为空。

* 函数体：花括号 {} 内包含的代码块，当函数被调用时将执行这些代码。

```C++
// 这是一个简单函数定义
int add(int a, int b) {
    return a + b;
}

// 调用
int sum = add(3, 7);  // sum值为10
```

&ensp;&ensp;&ensp;&ensp; 此外，函数定义时需要定义函数原型（也叫函数声明），函数原型告知编译器关于函数的名称、返回类型、参数，但是不提供函数体。一般函数原型都定义在头文件中，包含该头文件即可调用相关函数。

```C++
// 下面是一个函数原型的定义
// 函数原型的参数列表可以省略参数名
int draw(int, int);        
// 建议加上参数名，可以更直观的了解参数含义
int draw(int width, int height);
```

__2.4.2、参数传递__

&ensp;&ensp;&ensp;&ensp; C++中函数的参数传递方式包含：

* 值传递

* 指针传递

* 引用传递（特指左值）

* 右值传递

__2.4.2.1、值传递__

&ensp;&ensp;&ensp;&ensp; 该传递方式中函数的实参的值被复制到形参中。函数操作的是实参的副本（拷贝）。 见下例：

```C++
void swap(int a, int b) {
    int tmp = a;
    a = b;
    b = tmp;
}

int x = 5; 
int y = 7;
swap(x, y);      // x = 5  y = 7
```

&ensp;&ensp;&ensp;&ensp; 调用swap(x, y)时，函数swap接受两个参数a（x的拷贝），b（y的拷贝），此时在函数中对ab的操作不会影响到外部的实参 x、y。

__2.4.2.2、指针传递__

&ensp;&ensp;&ensp;&ensp; 在该传递方式中函数的实参的地址被传递给了形参，本质其实是指针类型的值传递。因为指针能操作其对应的地址的值，因此可以通过指针完成对实参的修改。

&ensp;&ensp;&ensp;&ensp; 上面的swap函数并没有实际完成其命名的功能（交换两个变量的数值），这里利用指针传递改造，见下面代码：

```C++
void swap(int * a, int * b) {
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

int x = 5;
int y = 7;
swap(&x, &y);      // x = 7  y = 5
```

&ensp;&ensp;&ensp;&ensp; 对于需要传递数组参数的场景，指针传递是唯一的选择，数组传参的示例如下：

```C++
int sum(int arr[], int size);// 定义1，这种定义的好处是清晰，调用者一看就知道传递数组指针

int sum(int * arr, int size);// 定义2，这种定义更符合数组传参的本质

// 特殊说明
// 不管定义1还是定义2，通过参数传递数组指针后，数组指针（前面介绍过，即数组名）会退化为首个元素
// 的地址指针，因此一定要通过size参数传递数组的大小给函数
```

__2.4.2.3、引用传递（左值传递）__

&ensp;&ensp;&ensp;&ensp; 传递方式中形参成为实参的别名（引用），所以任何对形参的操作实际上都是在实参上进行的。引用就是别名。编译器在底层可能会使用指针来实现引用，但会提供更严格的语义和更简单的语法。引用的声明方式如下：

```C++
nt a = 5；
int & ra = a;  // ra的类型是 int&（引用），必须声明时立即初始化

int b = 6;
ra = b;      // 非法，引用变量不支持重新赋值
```

&ensp;&ensp;&ensp;&ensp; 依然以交换函数swap举例：

```C++
void swap(int & a, int & b) {
    int tmp = a;
    a = b;
    b = tmp;
}

int x = 5;
int y = 7;
swap(x, y);      // x = 7 y = 5
```

__2.4.2.4、右值传递__

&ensp;&ensp;&ensp;&ensp; 右值传递同引用传递类似，是传递右值引用到函数内部的传递方式。主要被用来实现移动语义和完美转发。详细内容请自行搜索。在下面介绍类的移动语义的部分会有涉及右值。

* 左值（lvalue）：左值是指表达式结束后依然存在的持久性对象，可以出现在赋值语句的左边。左值可以被取地址，即可以通过取地址运算符&获取其地址。通常，变量、数组元素、引用、返回左值引用的函数等都是左值。

* 右值（rvalue）：右值是指表达式结束后不再存在的临时对象，不能出现在赋值语句的左边。右值不能被取地址，即不能通过取地址运算符&获取其地址。通常，字面量、临时对象、返回右值引用的函数等都是右值。

&ensp;&ensp;&ensp;&ensp; C++11引入了右值引用（rvalue reference）的概念，通过&&来声明一个右值引用。右值引用可以绑定到临时对象，从而支持移动语义和完美转发。移动语义允许将资源（如动态分配的内存）从一个对象“移动”到另一个对象，而不是进行昂贵的复制操作。完美转发允许将参数以原样传递给其他函数，避免不必要的拷贝。

&ensp;&ensp;&ensp;&ensp; 总的来说，C++11中的左值和右值概念更加严格和明确，为语言引入了更多的灵活性和性能优化的可能性。

&ensp;&ensp;&ensp;&ensp; 拓展：纯右值、将亡值、泛左值 、std::move、类型萃取。

__2.4.2.5、参数修改保护__

&ensp;&ensp;&ensp;&ensp; 对于使用指针传递方式和引用方式传递参数的函数，因为函数内部有修改外部变量数据的能力，因此使用不当可能出现问题。对于一个命名为 printInfo 函数大概率只会使用数据而不会修改数据，应该避免在之后的维护中出现修改参数的情况，这时可以通过 const 关键字来修饰函数的参数，达到禁止函数修改参数的目的。示例如下：

```C++
// 下面指针传递示例
// 内部可修改arr
void printInfo(int arr[]， int size); 

// 内部不可修改arr
void printInfo(const int arr[], int size); 

// 下面是引用传递示例
// 内部可以修改info
void printInfo(std::string& info); 

// 内部不可以修改info
void printInfo(const std::string& info); 
```

__2.4.2.6、传参方式选择原则__

&ensp;&ensp;&ensp;&ensp; 在函数定义时，选择合适的参数传递方式对于代码的性能和可读性至关重要。以下是一些常见的实践做法。对于仅使用参数的值，并不会进行修改的函数而言，应尽量遵循下面的原则：

* 如果数据对象很小，如内置数据类型或者小型结构，这按值传递。

* 如果数据对象是数组，这使用指针，因为这是唯一的选择，并将指针声明为常量指针。

* 如果数据对象较大的结构，则使用常量指针或者const引用，可以节省复制结构所需要的时间和空间，提高程序的效率。

* 如果数据对象是类对象，则使用const引用。类设计的语义常常要求使用引用。这是C++增加引用的主要原因。因此传递类对参数的标准方式是按引用传递。

&ensp;&ensp;&ensp;&ensp; 而对于需要通过参数修改原来变量值的函数，应遵循下面的原则：

* 如果数据对象是内置数据类型，则使用指针。

* 如果数据对象是数组，则只能使用指针。

* 如果数据对象是结构，则使用指针或者引用。

* 如果数据对象是类对象，则使用引用。

__2.4.3、函数重载__

&ensp;&ensp;&ensp;&ensp; 函数重载是一种允许多个具有相同名称但参数列表不同的函数共存的特性。函数重载允许使用相同的函数名来执行不同的任务，只要它们的参数类型或数量不同即可。编译器通过查看函数的参数列表（也称之为函数签名）来区分重载的函数。

```C++
// 下面是一组重载函数，同样是计算两个数的和，针对不同类型提供了不同的定义
int add(int a, int b) {        // 版本1
    return a + b;
}      

float add(float a, float b) {    // 版本2
    return a + b;
}    

double add(double a, double b) {  // 版本3
    return a + b;
}  

add(1, 2);      // 匹配版本1
add(1.0f, 2.0f);   // 匹配版本2
add(1.0, 2.0);    // 匹配版本3

add(1.0f, 2.0)    // 匹配 ？？？（匹配版本3，原因可以搜索 ”重载解析“）
```

__2.4.3.1、重载规则__

&ensp;&ensp;&ensp;&ensp; 先介绍一个概念：函数签名。在C++中函数签名包含两个部分：

* 函数名称。

* 参数列表：包括参数的类型、数量和顺序。注意一个参数是否使用引用并不能作为签名不同的依据。参数是否是 const 能作为不同的依据。

&ensp;&ensp;&ensp;&ensp; 函数重载遵循下面的原则：

* 函数签名必须不同.

* 作用域必须相同：重载的函数必须处于同一个作用域，否则它们被视为不同作用域中的不相关函数。

* 最佳实践是尽量保持重载函数的明确性，避免产生容易混淆的重载集合。

&ensp;&ensp;&ensp;&ensp; 一些注意点：

```C++
// 下面两个版本的函数不算重载，因为两者调用时的表达式都是 add(x, y), 编译器无法区分
int add(int a, int b);
int add(int & a, int & b);

// 下面两个版本算重载，编译器会根据实参是否是常量来匹配更合适的版本
int add(const int a, const int b);
int add(int a, int b);
```

&ensp;&ensp;&ensp;&ensp; 拓展：重载函数匹配规则。

__2.4.4、函数模板__

__2.4.4.1、函数模板的声明__

&ensp;&ensp;&ensp;&ensp; C++ 中泛型编程的基础构建块。它们允许程序员编写与类型无关的代码，从而使得相同的函数逻辑可以应用于不同的数据类型。函数模板通过模板参数化来实现，在实例化时，编译器根据传递给模板的实际参数类型生成具体的函数实例。对于在函数重载一节提到过的add函数，可以看到所有add函数的实现代码都是一样的，只是数据类型不一致。这里通过函数模板来实现同样的功能。

```C++
template <typename T>
T add(T a, T b) {
    return a + b;
}

// 多类型的定义
template <typename T1, typename T2>
void funcName(T1 a, T2 b);
```

&ensp;&ensp;&ensp;&ensp; 下面是一个实际示例:

```C++
#include <iostream>
using namespace std;

// 函数原型
template <typename T>
T add(T a, T b);    

int main() {
    cout << add(1, 2) << endl;       // 3
    cout << add(1.0f, 2.1f) << endl;   // 3.1
    cout << add(1.0, 3.2) << endl;    // 4.2

    return 0;
}

template <typename T>
T add(T a, T b) {
    return  a + b;
}
```

&ensp;&ensp;&ensp;&ensp; 注意，编译器在编译时会根据调用的参数类型生成对应的实际函数，这个过程被称为模板的实例化，该示例中实际会生成3个版本的add函数，只是不可见而已。另外使用模板不会减小最终的可执行程序，因为最终程序中依然会包含多个版本的add函数实例。

__2.4.4.2、重载的模板__

&ensp;&ensp;&ensp;&ensp; 依然以add函数举例，现在需要一个计算3个数据和的函数，并且也可能需要多种类型的版本，可以这么做：

```C++
// 函数原型
template <typename T>
T add(T a, T b);

template <class T>      // 声明模板时 typename 和 class 等价
T add(T a, T b, T c);

// 函数定义略
```

__2.4.4.3、模板的局限__

&ensp;&ensp;&ensp;&ensp; 考虑下面的模板：

```C++
template <typename T1, typename T2>
void funcName(T1 x, T2 y) {
    ...
    ?type? temp = x + y;
    ...
}
```

&ensp;&ensp;&ensp;&ensp; temp 这行应该怎么声明呢？这个类型取决于 x + y 的结果，可能是int， double，甚至更加复杂。C++11为了解决这个问题提供了 decltype 关键字，可以这样使用：

```C++
template <typename T1, typename T2>
void funcName(T1 x, T2 y) {
    ...
    decltype(x + y) temp = x + y;
    ...
}
```

&ensp;&ensp;&ensp;&ensp; 关于 decltype 如何确定最终类型，可以自行搜索，这里不展开。下面考虑另一个模板：

```C++
emplate <typename T1, typename T2>
？type？funcName(T1 x, T2 y) {
    ...
    return x + y;
}
```

&ensp;&ensp;&ensp;&ensp; 这里的返回值类型应该怎么声明？好像可以使用 decltype(x + y)，但这里不行，因为这里还未定义x、y，编译器无法使用这种方式推断。C++11新增了新的语法返回类型后置解决该问题：

```C++
// 正常函数声明
int add(int a, int b);
// 返回类型后置声明
auto add(int a, int b) -> int;

// 利用该语法可以这么声明上面的函数（推荐C+11中使用）
template <typename T1, typename T2>
auto funcName(T1 x, T2 y) -> decltype(x + y) {
    ...
    return x + y;
}

// C++14及以后得标准拓展了auto的类型推导能力
auto funcName(T1 x, T2 y) {
    ...
    return x + y;
}
```

&ensp;&ensp;&ensp;&ensp; 更多拓展：模板函数具体化、全特化 (Full Specialization)、 auto类型推导规则（区分C+11、C++14）、decltype类型推导规则、模板元编程。

__2.4.5、回调函数__

&ensp;&ensp;&ensp;&ensp; 在复杂的应用程序中，回调函数是经常需要使用的技术。在C++中要实现回调函数有以下几种方式。

__2.4.5.1、函数指针__

&ensp;&ensp;&ensp;&ensp; 函数名本身就是函数的指针。函数指针在定义时必须指明所指向函数的类型，包括返回类型和参数列表。以下是函数指针的定义语法：

```C++
// 返回类型 (*指针变量名)(参数列表);

// 示例
int add(int a, int b) {
    return a + b;
}

int (*pf)(int, int) = add;  // 可以这么理解定义：因为(*pf)表示函数，那么pf就是函数的指针

// 类似数组，函数指针也有两种使用方式
cout << (*pf)(2, 3) << endl;    // 5 指针使用方式
cout << pf(2, 3) << endl;    // 5 直接作为函数名使用

// 函数指针的定义一般都不怎么直接，使用也不方面

// 经典C++中可以使用typedef简化这个定义
typedef int (*p_fun)(int, int);    // 现在p_fun就是一种类型名称
p_fun pAdd = add;          // 精简很多

// 现代C++提供了 using 语法让这个过程更加直观，推荐使用
using p_fun = int (*)(int, int);   // 可读性更强
p_fun pAdd = add;

// auto大杀器
auto pAdd = add;          // 懒人利器
```

&ensp;&ensp;&ensp;&ensp; 知道怎么定义函数指针类型后，就可以定义支持回调函数的函数了，如下：

```C++
#include <iostream>

void callBack(int costTimeMs);
void work(void (*pf)(int));

int main() {
    work(callBack);
}

void callBack(int costTimeMs) {
    using namespace std;

    cout << "costTime:" << costTimeMs << endl; 
}

void work(void (*pf)(int)) {
    std::cout << "do some work" << std::endl;
    // ...
    pf(123);  // (*pf)(123) 也ok
}
```

__2.4.5.2、std::function__

&ensp;&ensp;&ensp;&ensp; 上面介绍的函数指针在定义时不怎么直观，C++标准库中提供了std::function 容器来简化这个过程。其实现技术原理可以自行搜索。这里给出代码示例：

```C++
#include <functional>
#include <iostream>

using namespace std;

void callBack(int costTimeMs) {
    cout << "costTime:" << costTimeMs << endl; 
}

void work(function<void(int)> callBack) {
    callBack(1234);
}

int main() {
    function<void(int)> func = callBack;
    work(func);
    return 0;
}
```

__2.4.5.3、更多方式__

&ensp;&ensp;&ensp;&ensp; C++是面向对象的语言，回调的场景更多的涉及到对象。对此C++提供了 函数对象（Functors、成员函数指针和 std::bind 作为回调函数。这里先不展开。

__2.5、类（class）__

&ensp;&ensp;&ensp;&ensp; C++通过引入类支持了面向对象编程（OOP）。在 C++ 中，类是创建自定义数据类型的核心概念之一。类用于定义与特定类型相关的数据（成员变量）及操作这些数据的函数（成员函数）。通过类，可以实现面向对象编程（OOP）的基本原则，如封装、继承和多态。关于C++类的知识非常多且复杂，这里介绍常用和重要的部分。

__2.5.1、定义类__

&ensp;&ensp;&ensp;&ensp; 类是通过关键字 class 定义的，后跟类名和类体：

```C++
class MyClass {
public:
    // 公共成员，通常的对外提供的方法定义
    void setMember(int member);
private:
    // 私有成员，成员变量，仅供内部调用函数
    int mMember;    // 集团规范推荐,使用m前缀
    void innerFunc();  // 函数一律小驼峰
protected:
    // 受保护成员，成员变量，供子类调用函数
};
```

&ensp;&ensp;&ensp;&ensp; 下面是类的实际定义：

```C++
// person.hpp
// C++一般使用 hpp 后缀的头文件，表明包含C++特性的代码（模板、引用、类等）
// .h .hpp只是约定的做法，不是语法上的必要性
// 类的定义一般放到头文件中，用来对外声明类
// 类的头文件规范：类名小写 + '_'分割(如果有多个单词的case)
// 如果类名：PersonInfo 对应头文件：person_info.hpp
#ifndef PERSON_H
#define PERSON_H

#include <string>
#include <iostream>

// 声明 'Person' 类
class Person {
public:
    // 构造函数声明
    Person(const std::string & name, int age);

    // 成员函数声明
    void printInfo() const; // const成员函数，保证函数不会修改调用对象

    // Setters 和 Getters 声明
    void setName(const std::string & name);
    const std::string & getName() const;

    void setAge(int age);
    int getAge() const;

private:
    // 成员变量
    std::string mName;
    int mAge;
};

#endif // PERSON_H

// person.cpp
// 实现代码放到同名cpp文件中
#include "person.hpp"

// 构造函数定义
Person::Person(const std::string & name, int age) : mName(name), mAge(age) {}

// 成员函数定义
void Person::printInfo() const {
    std::cout << "Name: " << mName << ", Age: " << mAge << std::endl;
}

// Setters 和 Getters 定义
void Person::setName(const std::string & name) {
    mName = name;
}

const std::string & Person::getName() const {
    return mName;
}

void Person::setAge(int age) {
    mAge = age;
}

int Person::getAge() const {
    return mAge;
}
```

&ensp;&ensp;&ensp;&ensp; 拓展：const成员函数。

__2.5.2、访问控制__

&ensp;&ensp;&ensp;&ensp; 类成员的访问权限可以是 public、private 或 protected：

* Public（公共）：公共成员可以在类的外部被访问。

* Private（私有）：私有成员只能在类的内部被访问。

* Protected（受保护）：受保护成员可以在类的内部以及其派生类中被访问。

__2.5.3、构造函数__

&ensp;&ensp;&ensp;&ensp; 构造函数是一种特殊的成员函数，它在创建类实例时自动调用。构造函数可以被重载，以提供不同的初始化方式。成员初始化列表提供了初始化成员变量的一种更高效的方式，对于类中的常量成员、引用成员来说，成员初始化列表是必须的：

```C++
class MyClass {
public:
    MyClass(int m1, int m2, int m3) : mM1(m1), mM2(m2), mM3(m3) {}
private:
    int mM1;
    const int mM2；
    int & mM3;
};

// 类的初始化方式
MyClass a1(1, 2, 3);         // 传统构造函数
MyClass a1 = MyClass(1, 2, 3);   // 同上
MyClass a2 = {1, 2, 3};     // 列表初始化，会匹配最合适的构造函数
MyClass a3{1, 2, 3};        // 同上
```

&ensp;&ensp;&ensp;&ensp; 拓展：explicit 关键字。

__2.5.4、构造函数__

&ensp;&ensp;&ensp;&ensp; 析构函数是类的一个特殊成员函数，它在类的对象生命周期结束时自动被调用以执行清理工作。主要用途是释放对象占用的资源，并执行一些必要的清理操作，例如释放动态分配的内存、关闭文件和数据库连接等。示例：

```C++
class MyClass {
public:
    MyClass() {
        // 构造函数分配资源或执行初始化
        data = new int[10]; // 假设动态分配了内存
    }

    ~MyClass() {
        // 析构函数释放资源
        delete[] data;     // 释放动态分配的内存
    }

private:
    int* data;         // 指向动态分配的内存
};
```

&ensp;&ensp;&ensp;&ensp; 自动调用析构函数的情况：

* 局部对象：当局部对象的作用域结束时，例如函数结束时，其中的局部对象会被销毁，调用析构函数。

* 动态分配的对象：当使用 delete 操作符删除一个动态分配的对象时，析构函数会被调用。

* 静态和全局对象：当程序结束时，所有的静态和全局对象会被销毁，调用析构函数。

* 临时对象：当临时对象的生命周期结束时，例如临时对象作为函数参数传递，或者在它们创建的表达式结束后，析构函数会被调用。

* 通过 std::unique_ptr 或 std::shared_ptr 管理的对象：当智能指针销毁或被重新赋值，造成引用计数降为零时，析构函数会被调用。

&ensp;&ensp;&ensp;&ensp; 在 C++ 中，通常应用“资源获取即初始化”（RAII）原则来管理资源。RAII 建议在构造函数中获取资源，并在析构函数中释放资源。这样，资源的生命周期就与包含它的对象的生命周期绑定在一起，简化了资源管理并防止了资源泄漏。

&ensp;&ensp;&ensp;&ensp; 当正确使用 RAII 原则时，通常不需要手动调用析构函数，因为 C++ 会确保在对象生命周期结束时自动调用析构函数。然而，如果你使用“裸”指针手动管理资源，就必须非常小心地确保每个分配的资源最终都被释放，否则可能会导致资源泄漏。智能指针（如 std::unique_ptr 和 std::shared_ptr）是现代 C++ 推荐的资源管理方式，它们可以自动管理资源的生命周期，从而避免直接手动管理资源的复杂性和危险。

__2.5.5、运算符重载__

&ensp;&ensp;&ensp;&ensp; 类可以重载各种运算符，以提供类似于内建类型的行为：

```C++
class MyClass {
public:
    MyClass() : data(new int[10]) { }   // 构造函数
    ~MyClass() { delete[] data; }     // 析构函数

    // 拷贝赋值运算符
    MyClass & operator=(const MyClass& other) {
        if (this != &other) { // 避免自赋值
            std::copy(other.data, other.data + 10, data);
        }
        return *this;
    }

private:
    int* data;
};

// 使用
MyClass a;
MyClass b = a;    // 默认的赋值操作是浅拷贝，这里因为重载了 = 运算符，变成深拷贝

// C++11开始可以删除默认的赋值操作符，从而防止因浅拷贝带来的风险
class MyClass2 {
    // ...
    MyClass2 & operator=(const MyClass2 & other) = delete; // 禁用赋值操作符
    // ...
};

MyClass2 a;
MyClass2 b = a; // 非法，MyClass2的 = 运算符被禁用
```

&ensp;&ensp;&ensp;&ensp; 一些注意事项：

* 运算符重载并不改变运算符的优先级、结合性或操作数个数。这些都是由语言规范定义的。

* 不要滥用运算符重载。重载的运算符应该和它的原始意图保持相关性，否则可能导致代码难以阅读和理解。

* 记得检查自赋值。特别是在重载赋值运算符时（如 operator=），要确保它能正确处理自赋值的情况。

* 为了保持一致性，考虑重载对应的复合赋值运算符。例如，如果你重载了 operator+，那么也应该重载 operator+=。

* 当重载某些运算符，如 ==，通常也需要重载相应的运算符，如 !=，以确保逻辑一致性。

* 某些运算符最好重载为非成员函数。像 << 和 >> 这类运算符，如果要用于输入输出流的话，通常作为非成员函数重载比较合适，因为它们的左操作数通常是流对象。

&ensp;&ensp;&ensp;&ensp; 拓展：

* C++支持重载的运算符。

* 转换函数（这个不算运算符重载，例：operator int()）。

__2.5.6、拷贝构造函数和拷贝赋值运算符__

&ensp;&ensp;&ensp;&ensp; 对象的赋值操作是常见的操作，应该尽量避免使用浅拷贝，因为这种方式存在潜在风向。为解决这个问题类可以定义专门的拷贝构造函数和拷贝赋值运算符，以控制对象如何被复制：

```C++
#include <iostream>

class MyClass {
public:
    MyClass() : data(new int[10]) { } // 默认构造函数

    ~MyClass() { delete[] data; } // 析构函数

    // 拷贝构造函数
    MyClass(const MyClass & other) : data(new int[10]) {
        std::copy(other.data, other.data + 10, data);
        std::cout << "copy init" << std::endl;
    }

    // 拷贝赋值运算符
    MyClass & operator=(const MyClass & other) {
        if (this != &other) { // 避免自赋值
            std::copy(other.data, other.data + 10, data);
        }
        std::cout << "copy =" << std::endl;
        return *this;
    }

private:
    int* data;
};


int main() {
    MyClass a;
    MyClass b;
    MyClass c = a;
    c = b;
    return 0;
}

// 程序输出
// copy init
// copy =
```

&ensp;&ensp;&ensp;&ensp; 拓展：浅拷贝、深拷贝。

__2.5.7、移动构造函数和移动赋值运算符（C++11）__

&ensp;&ensp;&ensp;&ensp; 在 C++11 中引入了移动语义，允许从临时对象“移动”资源，而不是复制它们：

```C++
#include <iostream>

using namespace std;

class BigMemoryPool {
    private:
        static const int POOL_SIZE = 4096;
        int* mPool;

    public:
        BigMemoryPool() : mPool(new int[POOL_SIZE]{0}) {
            cout << "call default init" << endl;
        }

        // 编译器会优化移动构造函数，正常情况可能不会被执行
        // 可以添加编译选项 “-fno-elide-constructors” 关闭优化来观察效果
        BigMemoryPool(BigMemoryPool && other) noexcept {
            mPool = other.mPool;
            other.mPool = nullptr;
            cout << "call move init" << endl;
        }

        BigMemoryPool & operator=(BigMemoryPool && other) noexcept {
            if (this != &other) {
                this->mPool = other.mPool;
                other.mPool = nullptr;
            }
            cout << "call op move" << endl;
            return *this;
        }
        void showPoolAddr() {
            cout << "pool addr:" << &(mPool[0]) << endl;
        }

        ~BigMemoryPool() {
            cout << "call destructor" << endl;
        }
};

BigMemoryPool makeBigMemoryPool() {
    BigMemoryPool x;  // 调用默认构造函数
    x.showPoolAddr();
    return x;         // 返回临时变量，属于右值
}

int main() {
    BigMemoryPool a(makeBigMemoryPool());  
    a.showPoolAddr();
    a = makeBigMemoryPool();  
    a.showPoolAddr();
    return 0;
}

// 输出内容
call default init
pool addr:0x152009600
instance addr:0x16fdfeda0
pool addr:0x152009600
instance addr:0x16fdfeda0  // 编译器优化，这里a和x其实是同一个实例，因此不会触发移动构造
call default init
pool addr:0x15200e600    // 新的临时变量，堆内存重新分配
instance addr:0x16fdfed88  // 临时变量对象地址
call op move        // 移动赋值
call destructor
pool addr:0x15200e600    // a的Pool指向的内存地址变成新临时对象分配的地址，完成转移
instance addr:0x16fdfeda0  // a对象的地址没有变化
call destructor
```

&ensp;&ensp;&ensp;&ensp; 拓展：返回值优化（RVO）、命名返回值优化（NRVO）。

&ensp;&ensp;&ensp;&ensp; C++11引入移动语义之前，类似的做法需要返回指针或者通过拷贝的方式来保存临时对象，前者会引入资源管理问题后者会有拷贝的性能损耗。

__2.5.8、友元函数和友元类__

__2.5.8.1、友元函数__

&ensp;&ensp;&ensp;&ensp; 友元函数是定义在类外部的普通函数，它被某个类声明为其“友元”。这意味着友元函数可以访问该类的所有成员，包括私有和受保护的成员。友元函数不是类成员函数，也不受类的封装性约束。友元函数的声明方式是在类的定义内部使用关键字 friend，后跟函数的原型，友元函数实现时不能加类名作用域限定：

```C++
#include <iostream>

// 声明 Vector2D 类
class Vector2D {
private:
    float x_;
    float y_;

public:
    Vector2D(float x = 0.0f, float y = 0.0f) : x_(x), y_(y) {}

    // 友元函数声明，用于重载 + 操作符
    friend Vector2D operator+(const Vector2D & a, const Vector2D & b);

    // 输出 Vector2D 对象的友元函数
    friend std::ostream & operator<<(std::ostream & out, const Vector2D & v);
};

// 重载 + 操作符的友元函数定义
Vector2D operator+(const Vector2D & a, const Vector2D & b) {
    return Vector2D(a.x_ + b.x_, a.y_ + b.y_);
}

// 重载 << 操作符的友元函数定义，用于输出 Vector2D 对象
std::ostream & operator<<(std::ostream & out, const Vector2D & v) {
    out << "(" << v.x_ << ", " << v.y_ << ")";
    return out;
}

int main() {
    Vector2D vec1(1.0, 2.0);
    Vector2D vec2(3.0, 4.0);
    Vector2D vec3;

    vec3 = vec1 + vec2; // 使用友元函数重载的 + 操作符

    std::cout << "vec1: " << vec1 << std::endl;
    std::cout << "vec2: " << vec2 << std::endl;
    std::cout << "vec3: " << vec3 << std::endl; // 输出: vec3: (4, 6)

    return 0;
}
```

__2.5.8.2、友元类__

&ensp;&ensp;&ensp;&ensp; 友元类是一个允许特定类访问另一个类的私有和受保护成员的机制。在 C++ 中，通常情况下，一个类无法访问另一个类的私有（private）和受保护（protected）成员，即使它们需要彼此协作。友元类提供了一种方式，让你可以指定某些类之间有更紧密的关系，并允许它们访问对方的非公共接口。下面是示例：

```C++
#include <iostream>

class MyClass; // 前向声明

// 声明一个类（FriendClass），该类将访问MyClass的私有和受保护成员
class FriendClass {
public:
    void accessMyClass(MyClass & obj);
};

// 声明主类（MyClass）
class MyClass {
private:
    int secret;

public:
    MyClass(int val) : secret(val) {}

    // 声明FriendClass为MyClass的友元类
    friend class FriendClass;
};

// FriendClass成员函数实现
void FriendClass::accessMyClass(MyClass & obj) {
    // 可以访问MyClass的私有成员'secret'
    std::cout << "MyClass secret value is: " << obj.secret << std::endl;
}

int main() {
    MyClass obj(42);       // 创建MyClass对象
    FriendClass friendObj; // 创建FriendClass对象

    friendObj.accessMyClass(obj); // 访问MyClass的私有成员
    return 0;
}
```

&ensp;&ensp;&ensp;&ensp; 使用友元可能会破坏类的封装性和数据隐藏原则，因为它们允许外部函数或者类直接访问类的私有成员。因此，建议谨慎使用友元，只在确实需要时才使用，并寻找是否有其他设计替代方案。在设计类时，应尽可能通过公共成员函数或成员函数的重载来提供类的行为和操作，而将友元作为特定情况下的解决方案。

__2.5.9、继承__

&ensp;&ensp;&ensp;&ensp; 类可以从其他类继承，从而获得基类的成员和行为：

```C++
class Base {
    // 基类成员
};

class Derived : public Base {
    // 派生类成员
};
```

C++继承方式有三种：

* 公有继承（public）最常见的继承类型。在公有继承中，基类的公有成员和保护成员在派生类中保持其原有的访问级别，而基类的私有成员在派生类中是不可访问的。

* 保护继承（protected）基类的公有成员和保护成员都成为派生类的保护成员。这意味着它们只能被派生类或其进一步的派生类中的成员函数访问。

* 私有继承（private）私有继承会将基类的公有成员和保护成员都变成派生类的私有成员。这意味着这些成员只能被派生类的成员函数访问，而不能被派生类的派生类访问。

&ensp;&ensp;&ensp;&ensp; C++是支持多重继承的，即可以从多个类派生一个类，但是通常建议谨慎使用，因为多重继承可能会引起一些复杂的问题。

&ensp;&ensp;&ensp;&ensp; 拓展：虚继承。

__2.5.9、多态__

&ensp;&ensp;&ensp;&ensp; 多态允许派生类重写基类的虚拟函数，使得通过基类引用或指针调用这些函数时可以执行派生类的版本：

````C++
#include <iostream>

class Base {
public:
    void baseMethod() {
        std::cout << "Base method" << std::endl;
    }

    virtual void polymorphicMethod() {
        std::cout << "Base polymorphic method" << std::endl;
    }

    virtual ~Base() {} // 虚析构函数，用于多态
};

// 公有继承派生类
class Derived : public Base {
public:
    // 重写基类的虚函数
    void polymorphicMethod() override {
        Base::polymorphicMethod();  // 可以通过添加限定域调用基类实现
        std::cout << "Derived polymorphic method" << std::endl;
    }
};

int main() {
    Derived d;
    d.baseMethod();           // 调用基类的方法
    d.polymorphicMethod();    // 调用派生类重写的方法

    Base *b = &d;
    b->polymorphicMethod();   // 通过基类指针调用派生类的方法，体现多态
    return 0;
}
````

&ensp;&ensp;&ensp;&ensp; 在类继承的场景中，基类的析构函数一般要声明为虚析构函数，这样才能保证在通过基类指针删除对象时，派生类的资源也能被正确的释放。

&ensp;&ensp;&ensp;&ensp; 拓展：虚函数表、动态绑定。

__2.5.9、抽象类和纯虚函数__

&ensp;&ensp;&ensp;&ensp; 如果一个类包含至少一个纯虚函数（以 = 0 结尾），则该类被认为是抽象类，不能直接实例化，只包含纯虚函数而没有成员变量的抽象类和Java中的接口（Interface）功能类似。

```C++
// Interface in C++
class IShape {
public:
    virtual void draw() const = 0; // 纯虚函数
    virtual ~IShape() {} // 虚析构函数以确保派生类的析构函数被调用
};

class Circle : public IShape {
public:
    void draw() const override {
        // 实现绘制圆形的代码
    }
};

class Rectangle : public IShape {
public:
    void draw() const override {
        // 实现绘制矩形的代码
    }
};
```

__2.5.10、模板类__

&ensp;&ensp;&ensp;&ensp; C++模板类是一种强大的特性，它允许程序员编写泛型且可重用的代码。模板类可以用来定义在编译时可以指定类型参数的类，这意味着可以用相同的基本代码来处理不同的数据类型。可以这么说现代C++的很多功能强大的特性都和模板技术有关系下面是模板类的一般定义语法：

```C++
emplate <typename T>
class MyTemplateClass {
    const T& getValue();
public:
    T myValue;
};
```

&ensp;&ensp;&ensp;&ensp; 因为模板类的复杂性，这里不做展开。因为模板是一种强大的语言特性，C++中常见的模板类应用在容器上，C++标准库中提供一系列的泛型容器，前面提到过的 vector、list、stack都是模板类实现的。相关容器的用法可以搜索对应的文档。

__2.6、智能指针__

&ensp;&ensp;&ensp;&ensp; 智能指针，同样是利用模板类技术实现的，它们提供了自动内存管理功能，可以帮助避免内存泄漏。下面是现代C++提供的智能指针：

* std::unique_ptr：std::unique_ptr 是一个独有所有权的智能指针。它保证同一时间内只有一个智能指针实例可以拥有一个给定的对象。当 std::unique_ptr 被销毁时，它所拥有的对象也会被销毁。std::unique_ptr 通常用于对资源有独占所有权的情况，并且它是不可以被复制的，但可以被移动，以便所有权可以从一个 std::unique_ptr 转移到另一个。

* std::shared_ptr：std::shared_ptr 实现了共享所有权的概念。它通过内部的引用计数机制来跟踪有多少个 std::shared_ptr 实例共享同一个对象。当最后一个这样的指针被销毁时，所拥有的对象将会被删除。std::shared_ptr 适用于多个拥有者需要管理同一个对象的生命周期的情况。

* std::weak_ptr：std::weak_ptr 是一种非拥有（弱）引用的智能指针。它不会增加对象的引用计数，因此不会阻止所指向的对象被销毁。std::weak_ptr 主要用于解决 std::shared_ptr 之间可能出现的循环引用问题。通过 std::weak_ptr，你可以观察一个对象，但不会造成所有权关系。

```C++
// 简单示例
// 定义智能指针
// C++11语法
std::unique_ptr<MyClass> my_unique_ptr(new MyClass());
std::shared_ptr<MyClass> my_shared_ptr(new MyClass());
// C++14提供了更安全更现代的方法
auto my_unique_ptr = std::make_unique<MyClass>();
auto my_shared_ptr = std::make_shared<MyClass>(); // 可以按照构造函数的定义传参

// 调用类的方法和普通指针类似
my_unique_ptr->func();
my_shared_ptr->func();

// 在需要传对象指针和引用的场景
// 类指针类型
void testFunc1(MyClass * p);
testFunc1(my_unique_ptr.get()); // 通过get获取原始指针

// 引用类型
void testFunc2(MyClass & ref);
testFunc2(*my_unique_ptr);    // 通过*运算符获取对象的引用
```

__2.7、函数对象__

&ensp;&ensp;&ensp;&ensp; 上面介绍函数回调时说过的 std::function也是模板类，它是一个泛型函数封装器，其实例可以存储、复制和调用任何可调用对象，如普通函数、Lambda 表达式、函数对象（functors）以及其他函数指针。下面是一些典型用法：

```C++
// 封装函数
void printHello() {
    std::cout << "Hello, World!" << std::endl;
}
std::function<void()> func = printHello;

// 封装Lambda表达式
std::function<int(int, int)> add = [](int a, int b) -> int {
    return a + b;
};

int sum = add(2, 3); // sum 的值为 5

// 封装成员函数
class MyClass {
public:
    void memberFunction() const {
        std::cout << "Member function called." << std::endl;
    }
};

MyClass obj;
std::function<void(const MyClass &)> f = &MyClass::memberFunction;
f(obj); // 输出: Member function called.

// 封装带有绑定参数的函数
void printSum(int a, int b) {
    std::cout << "Sum: " << a + b << std::endl;
}

int main() {
    using namespace std::placeholders; // 对于 _1, _2, _3...

    // 绑定第二个参数为 10，并将第一个参数留作后面指定
    std::function<void(int)> func = std::bind(printSum, _1, 10);
    func(5); // 输出: Sum: 15
    return 0;
}
```



































































































































































































































































































































