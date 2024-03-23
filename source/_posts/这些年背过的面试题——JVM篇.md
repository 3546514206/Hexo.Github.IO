---
title: 这些年背过的面试题——JVM篇
date: 2024-03-23 14:47:06
categories:
- 基本功
- 编程基础
tags:
- 基础知识
---


&ensp;&ensp;&ensp;&ensp; __1、JVM运行时数据区域__


&ensp;&ensp;&ensp;&ensp; 堆、方法区（元空间）、虚拟机栈、本地方法栈、程序计数器。

![内存划分](/pic/基本功/编程基础/这些年背过的面试题——JVM篇/内存划分.webp)

&ensp;&ensp;&ensp;&ensp; __Heap(堆)：__

&ensp;&ensp;&ensp;&ensp; 对象的实例以及数组的内存都是要在堆上进行分配的，堆是线程共享的一块区域，用来存放对象实例，也是垃圾回收（GC）的主要区域；开启逃逸分析后，某些未逃逸的对象可以通过标量替换的方式在栈中分配。堆细分：新生代、老年代，对于新生代又分为：Eden 区和 Surviver1 和 Surviver2 区。

&ensp;&ensp;&ensp;&ensp; __方法区：__

&ensp;&ensp;&ensp;&ensp; 对于 JVM 的方法区也可以称之为永久区，它储存的是已经被 java 虚拟机加载的类信息、常量、静态变量；Jdk1.8以后取消了方法区这个概念，称之为元空间（MetaSpace）；当应用中的 Java 类过多时，比如 Spring 等一些使用动态代理的框架生成了很多类，如果占用空间超出了我们的设定值，就会发生元空间溢出。


