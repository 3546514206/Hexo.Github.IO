---
title: JDBC层次关系图
date: 2023-11-30 09:11:25
categories: 
- 基本功
- 编程基础
tags:
- Java
- JDBC
---

&ensp;&ensp;&ensp;&ensp; 总体而言，JDBC包含以下几大角色 : Driver、DriverManager、Connection、Statement、ResultSet。这几大角色之间的层次关系如下图所示：

![JDBC层次关系结构](/pic/基本功/编程基础/JDBC层次关系图/JDBC层次关系结构.png)

&ensp;&ensp;&ensp;&ensp; Connection表示与特定数据库的连接，可以获取到数据库的一些信息，这些信息包括：其表信息，应该支持的SQL语法，数据库内有什么存储过程，此链接功能的信息等等。

![Connection](/pic/基本功/编程基础/JDBC层次关系图/Connecyion.png)

&ensp;&ensp;&ensp;&ensp; Statement 的功能在于根据传入的sql语句，将传入sql经过整理组合成数据库能够识别的sql语句(对于静态的sql语句，不需要整理组合；而对于预编译sql语句和批量语句，则需要整理)，然后传递sql请求，之后会得到返回的结果。对于查询sql，结果会以ResultSet的形式返回。

![Connection](/pic/基本功/编程基础/JDBC层次关系图/statement.png)

&ensp;&ensp;&ensp;&ensp; 当Statement查询sql执行后，会得到ResultSet对象，ResultSet对象是sql语句查询的结果，作为数据库结果的映射，其映射关系如下图所示。ResultSet对从数据库返回的结果进行了封装，使用迭代器的模式逐条取出结果集中的记录。

![ResultSet](/pic/基本功/编程基础/JDBC层次关系图/ResultSet.png)

&ensp;&ensp;&ensp;&ensp; 工作时序图：

![时序图](/pic/基本功/编程基础/JDBC层次关系图/时序图.png)





