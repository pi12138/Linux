# linux 软件安装

## deb包安装方式步骤：  

1. 找到相应的软件包，比如soft.version.deb，下载到本机某个目录； 
2. 打开一个终端，su -成root用户； 
3. cd soft.version.deb所在的目录； 
4. 输入dpkg -i soft.version.deb

- **详细介绍**：

​       这是Debian Linux提供的一个包管理器，它与RPM十分类似。

​	但由于RPM出现得更早，所以在各种版本的Linux都常见到。

​       而debian的包管理器dpkg则只出现在Debina Linux中，其它Linux版本一般都没有。
　　1. **安装**
　    dpkg –i deb的软件包名
　　如：dpkg –i software-1.2.3-1.deb
　　2. **卸载**
　　 dpkg –e 软件名
　　如：dpkg –e software

​       3.**查询**：查询当前系统安装的软件包：

​        dpkg –l ‘*软件包名*’

​      	 	如：dpkg –l '*software*'

## tar.bz2源代码包安装方式： 

1. 找到相应的软件包，比如soft.tar.bz2，下载到本机某个目录；    
2. 打开一个终端，su -成root用户；    
3. cd soft.tar.bz2所在的目录；   
4. tar -xjvf soft.tar.bz2 //一般会生成一个soft目录    
5. cd soft    
6. . /configure    
7. make    
8. make install 



## Ubuntu系统一般安装方式

- 使用 apt-get 命令
- apt-get install xxx 安装xxx  。如果带有参数，那么-d 表示仅下载 ，-f 表示强制安装  
  apt-get remove xxx 卸载xxx  
  apt-get update 更新软件信息数据库  
  apt-get upgrade 进行系统升级  
  apt-cache search 搜索软件包  
  Tips：建议您经常使用“apt-get update”命令来更新您的软件信息数据库