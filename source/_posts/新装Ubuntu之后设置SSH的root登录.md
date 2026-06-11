---
title: 新装Ubuntu之后设置SSH的root登录
date: 2024-11-19 10:24:48
tags:
- Ubuntu
- 操作系统
---

#### __1、确定一下我们的root用户存在__

```shell
# 输入命令后会提示你输入密码，不用管密码对不对，随便输入，如果没有此root用户他会提示你
su root
```

#### __2、修改root密码__

```shell
# 他会让你输入新密码，然后就是让你再次输入新密码
sudo passwd root
```

#### __3、安装SSH__

```shell
sudo apt-get install openssh-server openssh-client；
```

#### __4、允许root用户通过SSH连接__

```shell
# 编辑配置文件
sudo vim /etc/ssh/sshd_config
```

&ensp;&ensp;&ensp;&ensp; 作出如下修改：

```text
#PermitRootLogin prohibit-password
# 下面这是我们新添加的一行
PermitRootLogin yes 
```

#### __5、重启SSH服务__

```shell
service sshd restart
```
