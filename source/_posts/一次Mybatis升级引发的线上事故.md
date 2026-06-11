---
title: 深入 OGNL 与  Mybatis 源代码分析一次 Mybatis 升级引发的线上事故
date: 2023-08-31 10:16:04
tags:
- MyBatis
---


&ensp;&ensp;&ensp;&ensp; 项目中对 Mybatis 做了一次升级。前后版本如下，3.2.5 -> 3.4.4：

![mybatis前后版本升级](/pic/工程/问题记录与事故复盘/一次Mybatis升级引发的线上事故/mybatis前后版本升级.png)

&ensp;&ensp;&ensp;&ensp; 结果第二天巡检发现如下报错，过了两个小时业务高峰期，前台业务人员不断反馈某最核心的业务无法进行：

![报错信息](/pic/工程/问题记录与事故复盘/一次Mybatis升级引发的线上事故/报错信息.png)

&ensp;&ensp;&ensp;&ensp; 我们当时定位到错误的地方，根据经验修改之后验证通过，重新上线之后得以解决。可能涉及敏感数据，所以不展示实际的报错与弥补方案。

&ensp;&ensp;&ensp;&ensp; 以下是我在本地的问题复现。在本地的一个标准的 SSM 工程中分别引入以下两个版本的 Mybatis 依赖:

![分别引入两个版本的依赖](/pic/工程/问题记录与事故复盘/一次Mybatis升级引发的线上事故/分别引入两个版本的依赖.png)

&ensp;&ensp;&ensp;&ensp; 编写如下数据库脚本:

![数据库脚本](/pic/工程/问题记录与事故复盘/一次Mybatis升级引发的线上事故/数据库脚本.png)

&ensp;&ensp;&ensp;&ensp; dao 层调用方法如下：

![dao层方法调用](/pic/工程/问题记录与事故复盘/一次Mybatis升级引发的线上事故/dao层方法调用.png)

&ensp;&ensp;&ensp;&ensp; 当 Mybatis 依赖为 3.2.5 的较低版本时，不会报错；当 Mybatis 依赖版本为 3.4.4 的较高版本时，则会报出上面的错误:

```shell
invalid comparision:  java.util.HashMap and java.lang.String
```

&ensp;&ensp;&ensp;&ensp; 在本地问题得到复现。问题的关键在于数据库脚本中的 if 条件编译语句的这一个子句 _parameter!='' 将_parameter 与 '' 做比较，_parameter 是 Mybatis 的一个内置对象，你不需要知道它的作用，只需要知道他是 Map 类型的就行了，显然 '' 是 String 类型的。到这里我们其实已经猜出来了，正是因为这种不规范的比较导致数据库脚本执行失败（实际上是 Mybatis 编译 SQL 失败）。

&ensp;&ensp;&ensp;&ensp; 但是问题又来了，__为什么 Mybatis 较低版本的时候没有问题，而较高版本则暴露出这个问题了？__ 我们深入源码分析一下。因为我对 Mybatis 源码比较熟悉，加上实际生产中报错的堆栈信息也很全，所以直接定位到了 Mybatis 的这个类型：

![ifnode](/pic/工程/问题记录与事故复盘/一次Mybatis升级引发的线上事故/ifnode.png)

&ensp;&ensp;&ensp;&ensp; 上述代码的作用：在我们上述 SQL 脚本中，根据 if 子句的测试语句（就是 ... && _parameter!='' 那一坨）判断，当前 if 子句所包裹的 sql 是否需要动态编译进最终的执行sql中。当我们进一步追踪，就进入到了 OGNL 的源码中，OGNL 是一套表达式解析引擎，一直定位下去就到了具体报错的方法。到这里我们补充一下版本依赖关系：

```shell
mybatis-3.2.5  ->  ognl-2.6.9
mybatis-3.4.4  ->  ognl-3.1.14
```

&ensp;&ensp;&ensp;&ensp; 高版本 OGNL 源码如下：

![高版本 OGNL 代码](/pic/工程/问题记录与事故复盘/一次Mybatis升级引发的线上事故/高版本OGNL代码.png)

&ensp;&ensp;&ensp;&ensp; 低版本 OGNL 源码如下：

![低版本 OGNL 代码](/pic/工程/问题记录与事故复盘/一次Mybatis升级引发的线上事故/低版本OGNL代码.png)

&ensp;&ensp;&ensp;&ensp; 类型标识相关的源码如下：

![类型标记](/pic/工程/问题记录与事故复盘/一次Mybatis升级引发的线上事故/类型标记.png)

&ensp;&ensp;&ensp;&ensp; case 为 NONUMBERIC 的含义是当比较的值是非数值类型，所以 _parameter!='' 子句的判断自然是走该分支语句的代码。t1、t2，v1、v2 的含义是两个待比值（ _parameter 和 ''）的类型和 value，在这个场景中分别是如下调试面板所示的（不明白的请观察为了复现问题所编写的 SQL 脚本和 dao 层语句）：

![调试信息如下](/pic/工程/问题记录与事故复盘/一次Mybatis升级引发的线上事故/调试信息如下.png)

&ensp;&ensp;&ensp;&ensp; 解释一下：t1 = t2 = 10，表示 _parameter 与 '' 都是非数值类型。v1 表明了 _parameter 是个 HashMap 类型的变量，有一个 (blurname,cat) 的键值对，v2 = ''。另外，类的 Class 实例中有一个 isAssignableFrom 方法，这个方法是用来判断两个类的之间的关联关系，也可以说是一个类是否可以被强制转换为另外一个实例对象。

&ensp;&ensp;&ensp;&ensp; 至此所需信息全部已经准备完毕，我们可以来分析高低版本 OGNL 的源码了。高版本 OGNL 中，我们直接看 case:NONUMBERIC 的分支子句。代码含义为：

&ensp;&ensp;&ensp;&ensp; __如果 V1 是 Comparable 类型的并且 V1 可以强转为 V2 的类型，则进入 if 分支，否则进入 else 分支，而 else 分支直接报错，而且报错信息是我们实际生产环境中遇到的。显然，V1 既不是 Comparable 类型，也无法转换为 V2 的类型（HashMap -> String），所以进入了 else 分支，mybatis 升级之后携带 OGNL 的升级，数据库不规范的写法导致 mybatis 编译 sql 语句报错，阻塞了业务__

&ensp;&ensp;&ensp;&ensp; 低版本的 OGNL 的 case:NONUMBERIC 的分支子句的代码逻辑说实话非常拧巴，含义是：

&ensp;&ensp;&ensp;&ensp; __如果 v1、v2 任一变量为 null，则进入 if 分支，显然不会进入。else 先判断v1、v2 是否能互转，显然不能，直接跳过。接下来是重中之重：如果 equals 为 true ,跳出 case，否则报错。我们根据结果看，equals 必定为 true，因为我们那种不规范的 mybatis 在这个地方，它每没报错——事实上是应该将该问题抛出来的，从而引导开发者更正 mybatis 脚本。接下来我们看方法外面这个 equals 的来源：__

![equals](/pic/工程/问题记录与事故复盘/一次Mybatis升级引发的线上事故/equals.png)

&ensp;&ensp;&ensp;&ensp; 我惊呆了，直接写死传经来的，至于这个 equals 意欲何为，当初作者为什么这么写，也许只有作者自己知道。反正高版本的 OGNL 已经将这部分的代码逻辑全部重构了。

&ensp;&ensp;&ensp;&ensp; 我们可以得到如下结论： __低版本的 mybatis 依赖了低版本的 OGNL ，低版本的 OGNL 在上述分析的函数中存在一定缺陷，这个缺陷会导致我们在编写 Mybatis 脚本的时候类似于 _parameter!='' 的不规范写法不被发现。当我们升级了 Mybatis 之后，这种不规范的写法反而兜不住暴露出来了，加上组件升级测试不充分，直接上到了生产环境。__

&ensp;&ensp;&ensp;&ensp; __反思：__
* __日常开发要严格要求自己，追求正规、大气的编程素养，每一行代码，每一个字符，都要过大脑，不要太随便，不要随便复制粘贴能跑就行。__
* __组件升级要慎之又慎，测试要充分。__














