---
title: 从头到尾说一说Java时间日期体系的前世今生
date: 2025-01-06 10:57:37
tags:
- Java 
---

#### __1、突击检查__

&ensp;&ensp;&ensp;&ensp; 如下代码输出什么，机器当下所设定的时区为美国时区，在北京时间 2024-12-07 11:20:51 时，传入字符串“2024-12-07 11:46:36”。最终输出应该是true，还是false呢？

![突击检查](/pic/基本功/编程基础/从头到尾说一说Java时间日期体系的前世今生/突击检查.webp)

#### __2、前言__

&ensp;&ensp;&ensp;&ensp; 约38亿年前地球出现生命体，约46亿年前太阳系形成，大约138亿年前宇宙大爆炸，那再往前呢？想起吕秀才对姬无命发出灵魂之问『时间是否有开端，宇宙是否有尽头』。施一公曾经在一次演讲中说，宇宙中从来不存在时间，只存在运动。地球公转太阳一圈是一年，这是运动，地球自转一圈是一天，这也是运动。从来就没有时间，或者说时间就是空间。

&ensp;&ensp;&ensp;&ensp; 『三十年春，秦晋围郑。郑伯使烛之武如秦』两千多年前我们就以时间记事，在造物主已经缔造的这一片井然有序的世界里，我们凭空创建出一个新的概念，并不断尝试融入这个世界体系--沙漏、水钟、日晷等等。今天站在计算机这个领域，也让我们重新梳理一遍，计算机世界里日期时间体系的前世今生。

#### __3、日期从1970 年1月1日说起__

&ensp;&ensp;&ensp;&ensp; 任何一个软件开发人员对这个时间应该都不陌生，有时我们忘记初始化或者忘记赋值时，日期就会显示为1970-01-01，我们也叫日期初始值。那为什么日期的初始值是从1970-01-01开始呢？有一个说法是说遵循了Unix的时间计数，Unix认为 1970年1月1日0点 [1]是时间纪元，那为什么Unix要以这个时间为准呢？

&ensp;&ensp;&ensp;&ensp; 有一处说法是说，当时操作性系统都是32位，如果每一个数值代表一秒，那么最多可以表示2^32-1，也就是2147483647秒，换算成年大概是68年。而Unix系统就是由Ken Thompson、Dennis Ritchie和Douglas McIlroy等人在贝尔实验室开发于1969年开发的，他们为了让时间尽可能的多利用起来，便用了下一年，即 1970年1月1日作为开始，然后这个约定也逐步延伸到其他各个计算机领域。

![日期从1970 年1月1日说起](/pic/基本功/编程基础/从头到尾说一说Java时间日期体系的前世今生/日期从1970年1月1日说起.webp)

#### __4、时间从GMT与UTC说起__

&ensp;&ensp;&ensp;&ensp; 聊完日期我们再来看时间，爱好体育的应该都知道，看欧冠得半夜起来看，看NBA得早上起来看，现在是北京时间的14点，同时也是纽约时间的凌晨1点半。那是因为我们各地处不同时区，那时区以什么为初始划分的呢？

##### __4.1、GMT 格林威治时间__

&ensp;&ensp;&ensp;&ensp; GMT的全称是 Greenwich Mean Time [2]即格林威治标准时间，是一种与地球自转相关、以太阳日为单位的时间标准。在十七世纪，格林威治皇家天文台为了海上霸权的扩张计划，选择了穿过英国伦敦格林威治天文台子午仪中心的一条经线作为零度参考线，也就是我们教科书上记载的本初子午线。

![格林威治时间](/pic/基本功/编程基础/从头到尾说一说Java时间日期体系的前世今生/格林威治时间.webp)

&ensp;&ensp;&ensp;&ensp; 并约定从本初子午线起，经度每向东或者向西间隔15°，就划分一个新的时区[3]，每个时区间隔1小时，在这个区域内，大家使用同样的标准时间。但各个国家也会基于各个国家的情况拆分或合并时区，比如中国横跨5个时区，但我们统一使用东八区；而美国则有东部时间、西部时间、夏威夷时间等等。

&ensp;&ensp;&ensp;&ensp; 从 1924 年开始，格林威治天文台每小时就会向全世界播报时间，最终截止到 1979 年。至于为什么会终止，自然有它的缺点和局限性，那我们就得聊聊UTC时间了。

##### __4.2、UTC 世界协调时间__

&ensp;&ensp;&ensp;&ensp; UTC的全称是 Coordinated Universal Time [4]协调世界时间，也称世界标准时间。据说按英语的简称是CUT，按法语的简称是TUC，然后大家相互拉扯一波后，统一叫了UTC。

![地球公转](/pic/基本功/编程基础/从头到尾说一说Java时间日期体系的前世今生/地球公转.png)

&ensp;&ensp;&ensp;&ensp; 上述所说GMT时间是以地球自转与围太阳公转来计时的，GMT时间认为地球自转一圈是24*3600秒，而地球的运动轨迹受很多方面影响，比如潮汐摩擦、气象变化、地震及地质活动等等，运动的时间周期并不是完全规律和相同的。这样会导致其实一天并不完全是24*3600秒，这样平均算下来GMT的一秒就不是完全意义上最精确的一秒。但偏差通常也不会很大，基本为毫秒级偏差，但日积月累如果不加以扶正，就会越差越远。

&ensp;&ensp;&ensp;&ensp; 而UTC的计数是基于 原子钟（Atomic Clock） [5]的计数，比如铯原子钟采用铯-133原子的特性，在特定能级跃迁时会产生一个非常确定的频率9,192,631,770赫兹。然后基于铯-133原子的运动经过换算确定出我们需要的时间周期，据说这种误差可达每百万年内不到一秒。

&ensp;&ensp;&ensp;&ensp; UTC 最终由两部分构成：原子时间与世界时间。原子时间基于原子钟，来标准化我们钟表中每一秒时间前进的数据；世界时间是结合GMT时间，我们用多少个原子时来决定一个地球日的时间长度。从1972年开始，UTC被正式采用为国际标准时间。这年实施了一种新的时间调整机制，包括使用闰秒[6]以便对齐地球自转与原子时间。

#### __5、JDK 时间日期的发展史__

##### __5.1、java.util.Date__

&ensp;&ensp;&ensp;&ensp; 说起Date那可是JDK的正牌嫡系，从1.0开始就一直存在并延续至今。但只要大家用过一些代码扫描工具，基本都是在提示你尽量不要使用Date。在oracle的官方JDK文档中，有超过一半的函数都是deprecated，要细说Date的问题，那可真是一言难尽。 

![java.util.Date](/pic/基本功/编程基础/从头到尾说一说Java时间日期体系的前世今生/java.util.Date.webp)

* __不能单独表示日期或时间：__ Sat Dec 07 17:36:58 CST 2024 这是我们输出new Date()之后的数据，因为Date本质是某一个时刻的时间戳，导致它不能单独表示日期，更不能表示不带日期的时间。

* __令人捉摸不透的API：__ 单就Date的方法名来看，应该是非常友好的。它提供了getYear(), getDay()等等，你但凡用过一次，一定让你抓狂。

* __不支持时区设定：__ day和month是从0开始计数的，所以月最大是11，日最大是30，年输出124是因为2024年距离1900年有124年。

```java
public static void main(String[] args) {
    Date date = new Date();
    // 输出 6
    System.out.println(date.getDay());
    // 输出 11
    System.out.println(date.getMonth());
    // 输出 124
    System.out.println(date.getYear());
}
```

* __不支持时区设定：__ 曾经写过一段这样的代码，取当前的中国时间，被老板臭骂一顿。。。Date的本质是一个时间戳。当前此时此刻，全球任何一个地方的时间戳都是同一个，Date本身不支持时区。PS.本质上这行代码也指定不了时区哦~

```java
Date now = Calendar.getInstance(Locale.CHINA).getTime();
```

* __Date是可变的：__ Date是一个非常基础底层的类，但它却设计为可变。当我们计算这个data3天后是不是周末，如果程序计算中把这个date加了3天，那么你手上拿着得date也变成了3天后的日期。相比同为底层基础类的String，做得就优秀多了。

##### __5.2、难当大任的Calendar__

&ensp;&ensp;&ensp;&ensp; JDK刚推出就发现了问题，于是赶紧在1.1版本推出了Calendar，尝试用来解决令人诟病的Date，并将Date一众函数都标记为了deprecated。但Calendar依然是可变对象、最多也只能精确到毫秒、线程不安全、API的使用复杂且笨重等等，Calendar整体而言并没有挽回颓势。

##### __5.3、曙光来临之JSR310__

&ensp;&ensp;&ensp;&ensp; 在聊JSR310之前，不得不先提一提  Joda-Time [7]这个开源Java库。Joda-Time以清晰的API、良好的时区支持、不可变性、强类型化等特性，得到了开发者社区的广泛好评，并在很多项目中被采用，被视为改善Java日期和时间处理的标杆库。Joda-Time如此优秀，Oracle也开启了收编之旅。2013年Java8发布，其中针对日期时间带来一套全新的标准规约 JSR310 [8]，而JSR310的核心制作者就是Joda-Time的作者Stephen Colebourne。

![JSR310](/pic/基本功/编程基础/从头到尾说一说Java时间日期体系的前世今生/JSR310.webp)

* __Instant：__ Instant这个单词的中文含义是『瞬间』，严格来说Java8之前的Date就应该是现在的Instant。Instant类有维护2个核心字段，当前距离时间纪元的秒数以及秒中的纳秒部分。它指代当前这个时刻，全球任一位置这一时刻都是同一时刻。这一时刻川建国同学在高床软枕打着呼，这一时刻我泡着龙井写着文稿。

```java
/**
 * The number of seconds from the epoch of 1970-01-01T00:00:00Z.
 */
private final long seconds;

/**
 * The number of nanoseconds, later along the time-line, from the seconds field.
 * This is always positive, and never exceeds 999,999,999.
 */
private final int nanos;
```

* __LocalDateTime：__ LocalDateTime由LocalDate和LocalTime组成，分别日期和时间，以此来解决Date中不能单独表示日期和时间的问题。它们都与时区无关，只客观代表一个无时区的时间，比如2024-12-08 13:46:21，LocalDateTime记录着它的年、月、日、时、分、秒、纳秒。但具体是北京时间的13点还是伦敦时间的13点，由上下文语境自行处理。

```java

/******************** LocalDate ********************/
    /**
     * The year.
     */
    private final int year;
    /**
     * The month-of-year.
     */
    private final short month;
    /**
     * The day-of-month.
     */
    private final short day;

/******************** LocalTime ********************/
    /**
     * The hour.
     */
    private final byte hour;
    /**
     * The minute.
     */
    private final byte minute;
    /**
     * The second.
     */
    private final byte second;
    /**
     * The nanosecond.
     */
    private final int nano;
```

* __Duration__

&ensp;&ensp;&ensp;&ensp; Duration中文含义译为『期间』，通常用来计算2个时间之前相差的周期，不得不说这一套时间JDK确实定义得语义非常清晰。

```java
Instant startInstant = xxx;
Instant endInstant = xxx;
Duration.between(startInstant, endInstant).toMinutes();
```

&ensp;&ensp;&ensp;&ensp; 这个很好理解，比较2个时间戳时间的相差分钟数。但如果换成LocalDateTime，会是怎样呢？

```java
LocalDateTime startTime = xxx;
LocalDateTime endTime = xxx;
Duration.between(startTime, endTime).toMinutes();
```

&ensp;&ensp;&ensp;&ensp; 因为LocalDateTime是不带时区的，所以LocalDateTime是不能直接换成成Instant的。而Duration的比较也是不带时区的，或者你可以理解它是把时间放在同一个时区进行比较，来抹去时区的影响。

```java
/********************* JDK Duration.between 部分源码 *******************************/
@Override
public long until(Temporal endExclusive, TemporalUnit unit) {
    LocalDateTime end = LocalDateTime.from(endExclusive);
    if (unit instanceof ChronoUnit) {
        if (unit.isTimeBased()) {
            long amount = date.daysUntil(end.date);
            if (amount == 0) {
                return time.until(end.time, unit);
            }
            long timePart = end.time.toNanoOfDay() - time.toNanoOfDay();
            if (amount > 0) {
                amount--;  // safe
                timePart += NANOS_PER_DAY;  // safe
            } else {
                amount++;  // safe
                timePart -= NANOS_PER_DAY;  // safe
            }
// 余下省略
}
```

&ensp;&ensp;&ensp;&ensp; 上述是Duration部分源码，它首先计算出2个时间相差多少天，再比较当天的时间里相差多少纳秒，再进行累加。所以你传过来2024-12-08 和 2024-12-04，那就是相差4天，至于是北京时间的12-08还是伦敦时间的12-04，在Duration里都被抹去了时区的概念。看到这里，上面的编程题里做对了吗？

* __ZonedDateTime__

&ensp;&ensp;&ensp;&ensp; 真正需要使用时区，我们就需要用到ZonedDateTime。「zoned」这个单词在英汉词典中是zone的过去分时，译为『划为区域的』。

```java 
// 输出：2024-12-08T14:18:32.554144+08:00[Asia/Shanghai]
ZonedDateTime defaultZoneTime = ZonedDateTime.now(); // 默认时区
// 输出：2024-12-08T01:18:32.560931-05:00[America/New_York]
ZonedDateTime usZoneTime = ZonedDateTime.now(ZoneId.of("America/New_York")); // 用指定时区获取当前时间
```

&ensp;&ensp;&ensp;&ensp; 因为LocalDateTime是没有时区的，如果我们需要将LocalDateTime转成ZonedDateTime，就需要带上时区信息。

```java 
LocalDateTime localDateTime = LocalDateTime.of(2024, 12, 8, 14, 21, 17);
ZonedDateTime zonedDateTime = localDateTime.atZone(ZoneId.systemDefault());
ZonedDateTime usZonedDateTime = localDateTime.atZone(ZoneId.of("America/New_York"));
 ```

&ensp;&ensp;&ensp;&ensp; 随着JDK不断地发布演进，Time模块确实得到了质的提升，这里不一一细说Java日期时间相关API。如果你还在苦于对Date做各种Utils的花式包装，请拥抱java.time吧。

#### __6、时间日期引起的惨案__

##### __6.1、夏令时与冬令时__

&ensp;&ensp;&ensp;&ensp; 曾经小A做了一个鉴权系统，用于对请求做加密解密，保证每一次都是真实合法有效的接口请求。其中做了一个判定，如果请求的时间距现在已经超过10分钟，就会拒绝该次请求。从逻辑上来说，这很合理，但问题的雪崩却出现在3月的那个晚上。。。

![夏令时与冬令时](/pic/基本功/编程基础/从头到尾说一说Java时间日期体系的前世今生/夏令时与冬令时.webp)

* __什么是夏令时__

&ensp;&ensp;&ensp;&ensp; 夏令时[9]又称夏时制，英文原文为Daylight Saving Time，从名字上可以看出，夏令时诞生的背景是为了更好的利用白天的时间。夏令时概念的提出最早可以追溯到1895年，新西兰昆虫学家乔治·哈德逊向惠灵顿哲学学会提出，提前2小时的日光节约提案，以此在工作结束后，可以获得多出一段的白昼时间。

&ensp;&ensp;&ensp;&ensp; 具体夏令时的实施，以美国为例，美国会在每年3月的第二个星期日的凌晨2:00，时钟会往前调1个小时变为3:00。再在每年11月的第一个星期日的凌晨2:00，将时钟在往后调1个小时变成1:00，此时的回拨也被称为“冬令时”。

* __夏令时实施的国家与地区__

![夏令时实施的国家与地区](/pic/基本功/编程基础/从头到尾说一说Java时间日期体系的前世今生/夏令时实施的国家与地区.webp)

> 蓝色为正在实施夏令时的过去和地区
> 灰色为曾经实施但现在已经取消夏令时的国家和地区
> 黑色为从未实施夏令时的过去和地区

&ensp;&ensp;&ensp;&ensp; 1916年4月30日，德国与奥匈帝国成为世界上第一组实施夏时制的国家，目的是为了能在战争期间节约煤炭消耗。在1970年代，由于美洲与欧洲地区也受到能源危机影响，至此夏令时开始广泛被实施。当下全球有共约70多个国家和时区在使用夏令时，我国也曾短暂使用过夏令时，但因节约能源效果不显著，以及对日常生活工作等带来的一些影响，到1992年全国宣布取消夏令时。


































