---
title: JavaScript 运行时
date: 2026-01-08 16:11:52
tags:
- 大前端
- JavaScript
---

JavaScript Runtime
├── 一、JS 引擎（Engine）
│   ├── 解析器（Parser）
│   ├── 编译器（Interpreter / JIT）
│   ├── 执行器
│   └── 垃圾回收器（GC）
│
├── 二、执行上下文系统（Execution Model）
│   ├── 全局执行上下文
│   ├── 函数执行上下文
│   ├── 调用栈（Call Stack）            
│   ├── 作用域链（Lexical Environment）
│   └── this 绑定规则
│
├── 三、任务调度系统（Scheduling Model）
│   ├── 事件循环（Event Loop）           
│   ├── 宏任务队列（Task / Macrotask）   
│   ├── 微任务队列（Microtask / Job）    
│   └── 任务优先级与执行时机
│
├── 四、异步执行机制（Async Semantics）
│   ├── Promise 语义
│   ├── async / await
│   ├── continuation（续体）
│   └── 控制权交还模型
│
├── 五、宿主环境（Host Environment）
│   ├── I/O（文件 / 网络 / IPC）
│   ├── 定时器（setTimeout / setInterval）
│   ├── UI 事件（浏览器）
│   ├── 进程 / 信号（Node / Electron）
│   └── 事件源注册系统
│
├── 六、内存与资源管理
│   ├── Heap（堆）
│   ├── Stack（栈）
│   ├── Garbage Collection
│   └── 原生资源句柄（FD / Socket / Timer）
│
└── 七、模块与加载机制（Runtime-level）
    ├── 模块缓存
    ├── 加载时机
    ├── CommonJS / ESM 执行模型
    └── 顶层执行顺序

