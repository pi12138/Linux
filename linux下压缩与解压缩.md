# linux下压缩和解压缩

## .tar文件

- 压缩文件常用：
	- `tar -cvf new_file file1 file2 .....`
- 解压文件常用
	- `tar -xvf filename`
- 查看压缩文件内容
	- `tar -tf filename`

## 压缩

tar –cvf jpg.tar *.jpg       // 将目录里所有jpg文件打包成 tar.jpg 
tar –czf jpg.tar.gz *.jpg    // 将目录里所有jpg文件打包成 jpg.tar 后，并且将其用 gzip 压缩，生成一个 gzip 压缩过的包，命名为 jpg.tar.gz 
tar –cjf jpg.tar.bz2 *.jpg   // 将目录里所有jpg文件打包成 jpg.tar 后，并且将其用 bzip2 压缩，生成一个 bzip2 压缩过的包，命名为jpg.tar.bz2 
tar –cZf jpg.tar.Z *.jpg     // 将目录里所有 jpg 文件打包成 jpg.tar 后，并且将其用 compress 压缩，生成一个 umcompress 压缩过的包，命名为jpg.tar.Z 
rar a jpg.rar *.jpg          // rar格式的压缩，需要先下载 rar for linux 
zip jpg.zip *.jpg            // zip格式的压缩，需要先下载 zip for linux

## 解压

tar –xvf file.tar         // 解压 tar 包 
tar -xzvf file.tar.gz     // 解压 tar.gz 
tar -xjvf file.tar.bz2    // 解压 tar.bz2 
tar –xZvf file.tar.Z      // 解压 tar.Z 
unrar e file.rar          // 解压 rar 
unzip file.zip            // 解压 zip 
