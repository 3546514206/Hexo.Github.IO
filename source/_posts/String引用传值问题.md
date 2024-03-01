---
title: String引用传值问题
date: 2024-03-01 09:05:27
categories:
- 基本功
- 编程基础
tags:
- Java
- 基础知识
---

&ensp;&ensp;&ensp;&ensp; Java 中是没有引用传递的，Java 中只有值传递。Java 中所谓的引用传递，也只是传递了"引用变量保存的地址值"。
Java 中判断"引用传递"有没有达到你预期的效果，前提要基于内存模型，并结合你的上下文，根据有没有利用引用变量"传递"的这个地址值去修改实际内
存对象的数据来判断。


```java
package edu.zjnu;

/**
 * @author 杨海波
 * @date 2024/2/29 20:49
 * @description String 引用传值
 */
public class Main {

    public static void main(String[] args) {
        test01();
        test02();
    }

    private static void test01() {
        String str = "out";
        // str = "out2";
        f01(str);
        System.out.println(str);
    }

    /**
     * 工程实践表明，java 中没有引用传递，只有值传递。
     * <p>
     * Java 中所谓的引用传递，也只是传递了"引用变量保存的地址值"，如果无法做到根据这个引用指向的地址去修改实际对象的值，那么函数外部的实际对象无法被修改。
     * 特别的，String 是不可变对象：
     * 在 test01 这个例子中， 外部的 ' str = "out2";  这行代码只是在方法区的字符串常量池新建了一个字符串常量对象 "out2",并将该对象
     * 的地址赋值给引用变量 str。内部的 str = "in"; 也是同理，但是当 f01 函数执行 str = "in"; 这行代码时，引用变量保存的值（该值是尊从值传递的）
     * 是新的字符串常量对象 "in" 的地址，当 f01 执行完毕，这个值尊从函数作用域规则消失了。
     *
     * @param str
     */
    private static void f01(String str) {
        str = "in";
    }


    /**
     * 解决办法如下
     */
    private static void test02() {
        StringWrapper str = new StringWrapper("out");
        f02(str);
        System.out.println(str.value);
    }

    private static void f02(StringWrapper str) {
        str.value = "in";
    }


    static class StringWrapper {
        // 实际值
        public String value;

        public StringWrapper(String value) {
            this.value = value;
        }
    }
}
```
