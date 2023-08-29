---
title: GC-全流程
date: 2023-08-29 15:46:59
categories:
- 基本功
- 编程基础
- Java
- JVM
  tags:
- Java
- JVM
- 基础知识
---


#### __1、minorGC 和 Full GC 区别__
&ensp;&ensp;&ensp;&ensp; 新生代 GC（Minor GC）：指发生新生代的的垃圾收集动作，Minor GC 非常频繁，回收速度一般也比较快。

&ensp;&ensp;&ensp;&ensp; 老年代 GC（Major GC/Full GC）：指发生在老年代的 GC，出现了 Major GC 经常会伴随至少一次的 Minor GC（并非绝对），Major GC 的速度一般会比 Minor GC 的慢 10 倍以上。

#### __2、minorGC 过程详解__
&ensp;&ensp;&ensp;&ensp; 在初始阶段，新创建的对象被分配到 Eden 区，Survivor 的两块空间都为空。

![](https://github.com/3546514206/ImageHost.Github.IO/blob/main/%E5%9F%BA%E6%9C%AC%E5%8A%9F/%E7%BC%96%E7%A8%8B%E5%9F%BA%E7%A1%80/Java/JVM/GC-%E5%85%A8%E6%B5%81%E7%A8%8B/GC%E5%85%A8%E6%B5%81%E7%A8%8B1.png?raw=true)

&ensp;&ensp;&ensp;&ensp; 当Eden区满了的时候，minor garbage 被触发。

![](https://github.com/3546514206/ImageHost.Github.IO/blob/main/%E5%9F%BA%E6%9C%AC%E5%8A%9F/%E7%BC%96%E7%A8%8B%E5%9F%BA%E7%A1%80/Java/JVM/GC-%E5%85%A8%E6%B5%81%E7%A8%8B/GC%E5%85%A8%E6%B5%81%E7%A8%8B2.png?raw=true)

&ensp;&ensp;&ensp;&ensp; 经过扫描与标记，存活的对象被复制到S0，不存活的对象被回收， 并且存活的对象年龄都增大一岁。

![](https://github.com/3546514206/ImageHost.Github.IO/blob/main/%E5%9F%BA%E6%9C%AC%E5%8A%9F/%E7%BC%96%E7%A8%8B%E5%9F%BA%E7%A1%80/Java/JVM/GC-%E5%85%A8%E6%B5%81%E7%A8%8B/GC%E5%85%A8%E6%B5%81%E7%A8%8B3.png?raw=true)

&ensp;&ensp;&ensp;&ensp; 在下一次的 Minor GC 中，Eden 区的情况和上面一致，没有引用的对象被回收，存活的对象被复制到 Survivor区。当 Eden 和 s0区空间满了，S0 的所有的数据都被复制到S1，需要注意的是，在上次 Minor GC 过程中移动到S0 中的两个对象在复制到 S1 后其年龄要加1。此时 Eden 区 S0 区被清空，所有存活的数据都复制到了 S1 区，并且 S1 区存在着年龄不一样的对象，过程如下图所示：

![](https://github.com/3546514206/ImageHost.Github.IO/blob/main/%E5%9F%BA%E6%9C%AC%E5%8A%9F/%E7%BC%96%E7%A8%8B%E5%9F%BA%E7%A1%80/Java/JVM/GC-%E5%85%A8%E6%B5%81%E7%A8%8B/GC%E5%85%A8%E6%B5%81%E7%A8%8B4.png?raw=true)

&ensp;&ensp;&ensp;&ensp; 再下一次 Minor GC 则重复这个过程，这一次 Survivor 的两个区对换，存活的对象被复制到 S0，存活的对象年龄加1，Eden 区和另一个 Survivor 区被清空。

![](https://github.com/3546514206/ImageHost.Github.IO/blob/main/%E5%9F%BA%E6%9C%AC%E5%8A%9F/%E7%BC%96%E7%A8%8B%E5%9F%BA%E7%A1%80/Java/JVM/GC-%E5%85%A8%E6%B5%81%E7%A8%8B/GC%E5%85%A8%E6%B5%81%E7%A8%8B5.png?raw=true)

&ensp;&ensp;&ensp;&ensp; 再经过几次 Minor GC 之后，当存活对象的年龄达到一个阈值之后（-XX：MaxTenuringThreshold 默认是15），就会被从年轻代 Promotion 到老年代。

![](https://github.com/3546514206/ImageHost.Github.IO/blob/main/%E5%9F%BA%E6%9C%AC%E5%8A%9F/%E7%BC%96%E7%A8%8B%E5%9F%BA%E7%A1%80/Java/JVM/GC-%E5%85%A8%E6%B5%81%E7%A8%8B/GC%E5%85%A8%E6%B5%81%E7%A8%8B6.png?raw=true)

&ensp;&ensp;&ensp;&ensp; 随着 MinorGC 一次又一次的进行，不断会有新的对象被 Promote 到老年代。

![](https://github.com/3546514206/ImageHost.Github.IO/blob/main/%E5%9F%BA%E6%9C%AC%E5%8A%9F/%E7%BC%96%E7%A8%8B%E5%9F%BA%E7%A1%80/Java/JVM/GC-%E5%85%A8%E6%B5%81%E7%A8%8B/GC%E5%85%A8%E6%B5%81%E7%A8%8B7.png?raw=true)

&ensp;&ensp;&ensp;&ensp; 上面基本上覆盖了整个年轻代所有的回收过程。最终，MajorGC将会在老年代发生，老年代的空间将会被清除和压缩(标记-清除或者标记-整理)。从上面的过程可以看出，Eden 区是连续的空间，且 Survivor 总有一个为空。经过一次 GC 和复制，一个 Survivor 中保存着当前还活着的对象，而 Eden 区和另一个 Survivor 区的内容都不再需要了，可以直接清空，到下一次 GC 时，两个 Survivor 的角色再互换。因此，这种方式分配内存和清理内存的效率都极高，这种垃圾回收的方式就是著名的“停止-复制（Stop-and-copy）”清理法（将 Eden 区和一个 Survivor 中仍然存活的对象拷贝到另一个 Survivor 中），这不代表着停止复制清理法很高效，其实，它也只在这种情况下（基于大部分对象存活周期很短的事实）高效，如果在老年代采用停止复制，则是非常不合适的。

&ensp;&ensp;&ensp;&ensp; 老年代存储的对象比年轻代多得多，而且不乏大对象，对老年代进行内存清理时，如果使用停止-复制算法，则相当低效。一般，老年代用的算法是标记-压缩算法，即：标记出仍然存活的对象（存在引用的），将所有存活的对象向一端移动，以保证内存的连续。在发生 Minor GC 时，虚拟机会检查每次晋升进入老年代的大小是否大于老年代的剩余空间大小，如果大于，则直接触发一次 Full GC，否则，就查看是否设置了-XX:+HandlePromotionFailure（允许担保失败），如果允许，则只会进行 MinorGC，此时可以容忍内存分配失败；如果不允许，则仍然进行Full GC（ 这代表着如果设置-
XX:+Handle PromotionFailure，则触发MinorGC就会同时触发Full GC，哪怕老年代还有很多内存，所以，最好不要这样做）。

#### __3、整体描述__
&ensp;&ensp;&ensp;&ensp; 大部分情况，对象都会首先在 Eden 区域分配，在一次新生代垃圾回收后，如果对象还存活，则会进入 s1(“To”)，并且对象的年龄还会加 1( Eden 区 -> Survivor 区后对象的初始年龄变为 1)，当它的年龄增加到一定程度（默认为 15 岁），就会被晋升到老年代中。对象晋升到老年代的年龄阈值，可以通过参数 -XX:MaxTenuringThreshold 来设置。经过这次 GC 后，Eden 区和 From 区已经被清空。这个时候，From 和 To 会交换他们的角色，也就是新的 To 就是上次 GC 前的 From ，新的 From 就是上次 GC 前的 To。不管怎样，都会保证名为 To 的 Survivor 区域是空的。Minor GC 会一直重复这样的过程，直到 To 区被填满，To 区被填满之后，会将所有对象移动到年老代中。

#### __4、GC 触发条件__
&ensp;&ensp;&ensp;&ensp; Minor GC 触发条件：Eden 区满时。Full GC 触发条件：
* 调用 System.gc 时，系统建议执行 Full GC，但是不必然执行；
* 老年代空间不足；
* 方法去空间不足；
* 通过Minor GC后进入老年代的平均大小大于老年代的可用内存；
* 由 Eden 区、From Space 区向 To Space 区复制时，对象大小大于 To Space 可用内存，则把该对象转存到老年代，且老年代的可用内存小于该对象大小。

#### __5、对象进入老年代的四种情况__
&ensp;&ensp;&ensp;&ensp; 假如进行Minor GC时发现，存活的对象在ToSpace区中存不下，那么把存活的对象存入老年代。

![](https://github.com/3546514206/ImageHost.Github.IO/blob/main/%E5%9F%BA%E6%9C%AC%E5%8A%9F/%E7%BC%96%E7%A8%8B%E5%9F%BA%E7%A1%80/Java/JVM/GC-%E5%85%A8%E6%B5%81%E7%A8%8B/GC%E5%85%A8%E6%B5%81%E7%A8%8B8.png?raw=true)

&ensp;&ensp;&ensp;&ensp; 大对象直接进入老年代：假设新创建的对象很大，比如为5M(这个值可以通过PretenureSizeThreshold这个参数进行设置，默认3M)，那么即使Eden区有足够的空间来存放，也不会存放在Eden区，而是直接存入老年代。

![](https://github.com/3546514206/ImageHost.Github.IO/blob/main/%E5%9F%BA%E6%9C%AC%E5%8A%9F/%E7%BC%96%E7%A8%8B%E5%9F%BA%E7%A1%80/Java/JVM/GC-%E5%85%A8%E6%B5%81%E7%A8%8B/GC%E5%85%A8%E6%B5%81%E7%A8%8B9.png?raw=true)

&ensp;&ensp;&ensp;&ensp; 长期存活的对象将进入老年代：此外，如果对象在Eden出生并且经过1次Minor GC后仍然存活，并且能被To区容纳，那么将被移动到To区，并且把对象的年龄设置为1，对象没"熬过"一次Minor GC(没有被回收，也没有因为To区没有空间而被移动到老年代中)，年龄就增加一岁，当它的年龄增加到一定程度(默认15岁，配置参数-XX:MaxTenuringThreshold)，就会被晋升到老年代中。

&ensp;&ensp;&ensp;&ensp; 动态对象年龄判定：还有一种情况，如果在From空间中，相同年龄所有对象的大小总和大于Survivor空间的一半，那么年龄大于等于该年龄的对象就会被移动到老年代，而不用等到15岁(默认)。

![](https://github.com/3546514206/ImageHost.Github.IO/blob/main/%E5%9F%BA%E6%9C%AC%E5%8A%9F/%E7%BC%96%E7%A8%8B%E5%9F%BA%E7%A1%80/Java/JVM/GC-%E5%85%A8%E6%B5%81%E7%A8%8B/GC%E5%85%A8%E6%B5%81%E7%A8%8B10.png?raw=true)

#### __6、空间分配担保__
&ensp;&ensp;&ensp;&ensp; 在发生 Minor GC 之前，虚拟机会先检查老年代最大可用的连续空间是否大于新生代所有对象总空间，如果这个条件成立，那么 Minor GC 可以确保是安全的。如果不成立，则虚拟机会查看 HandlerPromotionFailure 这个参数设置的值（ true 或 flase ）是否允许担保失败（如果这个值为 true，代表着 JVM 说，我允许在这种条件下尝试执行 Minor GC，出了事我负责）。

&ensp;&ensp;&ensp;&ensp; 如果允许，那么会继续检查老年代最大可用的连续空间是否大于历次晋升到老年代对象的平均大小，如果大于，将尝试进行一次 Minor GC，尽管这次 Minor GC 是有风险的；如果小于，或者 HandlerPromotionFailure 为 false，那么这次 Minor GC 将升级为 Full GC。如果老年代最大可用的连续空间大于历次晋升到老年代对象的平均大小，那么 HandlerPromotionFailure 为 true 的情况下，可以尝试进行一次 Minor GC，但这是有风险的，如果本次将要晋升到老年代的对象很多，那么 Minor GC 还是无法执行，此时还得改为 Full GC。

&ensp;&ensp;&ensp;&ensp; 注意：JDK 6Update 24 之后，只要老年代的连续空间大于新生代对象总大小或者历次晋升的平均大 小就会进行 Minor GC，否则进行 Full GC。







