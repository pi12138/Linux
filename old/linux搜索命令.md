# linux 下的搜索命令

- Linux下主要的5个全局搜索的命令工具。他们分别是find，locate，grep，which，whereis
- find是一个强大实时搜索工具，Linux支持的文件类型它都可以搜索到，locate一般是搜索文件，grep一般是搜索文本文件，
  which和whereis一般是用于搜索程序相关的文件内容。

## find

- find命令在某个目录下查找
- find <pathname> <-option> <filetype> <action> 
	－pathname：所要查找的目录及其所有子目录(默认递归查找)。默认为当前目录。
	－option：指定参数。
	－filetype：想要查找的文件类型。
	－action：对查找结果进行的处理。

## locate

- locate命令在系统全局范围内查找
- locate <-option> <filetype>
	－option：指定参数。
	－filetype：想要查找的文件类型。

- locate是从数据库中读取数据，而不是从文件系统中读取。从数据库中读取时是读取updatedb命令返回的结果，所以如果要查找新
  建立的文件，需要先手动运行`sudo updatedb`命令

## grep

- 和find及locate命令不同的是，grep命令是在指定文件中搜索特定的内容，然后将包含有这些匹配内容的行输出到标准输出。
  如果不指定文件名，则从标准输入读取内容。grep命令经常和find等命令结合使用，其中grep常充当“过滤器”的角色。

## which

- which命令将在PATH变量指定的路径中 查找某个系统命令的位置，并且返回第一个搜索结果。也就是说，使用which命令，就可以
  看到某个系统命令是否存在，以及执行的到底是哪一个位置的命令。

## whereis

- whereis命令用来定位二进制文件（参数-b）、源代码文件（参数-s）和帮助手册文件（即man文件，参数-m）。如果省略参数，
  则返回所有信息。
