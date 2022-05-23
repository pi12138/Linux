# linux 设置系统默认启动

- 修改 /etc/default/ 下gurb 文件
- 修改文件 GRUB_DEFAULT=0 (数字设置为要优先启动的系统在boot manger页面的顺序)
- 要想修改该文件需要先修改该文件权限
  - su root
  - chmod 777 grub
- 修改完成后保存
- 然后在终端中输入 `sudo update-grub`

## 备注

- GNU GRUB（GRand Unified Bootloader简称“GRUB”）是一个来自[GNU](https://baike.baidu.com/item/GNU)项目的多[操作系统](https://baike.baidu.com/item/%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F/192)启动程序。GRUB是多启动规范的实现，它允许用户可以在[计算机](https://baike.baidu.com/item/%E8%AE%A1%E7%AE%97%E6%9C%BA/140338)内同时拥有多个[操作系统](https://baike.baidu.com/item/%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F/192)，并在计算机启动时选择希望运行的操作系统。GRUB可用于选择[操作系统](https://baike.baidu.com/item/%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F/192)分区上的不同[内核](https://baike.baidu.com/item/%E5%86%85%E6%A0%B8/108410)，也可用于向这些[内核](https://baike.baidu.com/item/%E5%86%85%E6%A0%B8/108410)传递启动参数。