---
title: 一些JVM平台上的并发知识
date: 2024-10-29 09:35:20
tags:
- JVM
- Java
---

#### __1、处理器缓存设计__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 处理器缓存通过减少写入延迟、批量刷新数据、限定缓存的局部可见性，并合理安排内存操作顺序，有效提升了处理器的运行效率和内存总线的利用率。

![处理器缓存设计](/pic/笔记/一些JVM平台上的知识点/1.png)

#### __2、重排序__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 源代码从编译器到最终执行的指令序列的优化过程，通过编译器重排、指令级并行重排以及内存系统重排，逐步优化指令执行顺序，以提升处理器的执行效率。

![重排序](/pic/笔记/一些JVM平台上的知识点/2.png)

#### __3、happens-before__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; "happens-before" 确保操作结果的可见性而不一定要求实际执行顺序。主要规则包括：程序顺序规则、监视器锁规则、volatile 变量规则和传递性规则，用于保证多线程环境下操作的有序性和一致性。

![happens-before](/pic/笔记/一些JVM平台上的知识点/3.png)

#### __4、数据依赖性__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 数据依赖性在单个处理器和单线程操作中的重要性，强调了写后读、写后写和读后写等依赖类型。如果这些操作顺序被交换，执行结果会发生变化。然而，不同处理器或线程之间的依赖性不在编译器和处理器的考虑范围内。

![数据依赖性](/pic/笔记/一些JVM平台上的知识点/4.png)

#### __5、as-if-serial__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; “as-if-serial” 语义，保证在单线程环境下操作的执行结果不受重排序的影响，无需担心内存可见性。代码执行顺序可以在不改变最终结果的前提下进行优化，例如图中 A、B、C 操作的顺序在编译器和处理器的重排序下仍保持一致的执行结果。

![as-if-serial](/pic/笔记/一些JVM平台上的知识点/5.png)

#### __6、程序顺序规则__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 程序顺序规则中的传递性和可见性要求：如果操作 A happens-before B，且 B happens-before C，则 A happens-before C，但这并不强制要求执行顺序。只要B能够看到 A 的结果，即使 B 先于 A 执行也是合法的，JVM 允许这种非严格顺序的优化。

![程序顺序规则](/pic/笔记/一些JVM平台上的知识点/6.png)

#### __7、内存屏障__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 下图介绍了内存屏障的不同类型及其作用，包括 LoadLoad、StoreStore、LoadStore 和 StoreLoad 屏障。每种屏障用于确保不同类型的内存操作顺序，从而在多处理器环境下保持数据一致性。其中，StoreLoad 屏障最强大且开销最高，用于在执行后续指令前确保当前处理器的所有写操作已刷新到内存。

![内存屏障](/pic/笔记/一些JVM平台上的知识点/7.png)

#### __8、重排序导致的问题__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 在多线程环境下，线程 A 的写操作 a=1 和 flag=true 可能被重排序，线程 B 在读取 flag 后立即使用变量 a，但此时 a 可能尚未更新，导致不正确的结果。这种重排序问题会破坏程序的预期执行顺序，可能引发逻辑错误。

![重排序导致的问题](/pic/笔记/一些JVM平台上的知识点/8.png)

#### __9、数据竞争问题__

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; 在多线程环境中，通过同步机制（如synchronized、volatile等）可以确保数据一致性和操作的原子性，避免数据竞争问题，但Java内存模型（JMM）不能对顺序一致性和原子性同时提供保证。

![数据竞争问题](/pic/笔记/一些JVM平台上的知识点/9.png)
