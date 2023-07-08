---
title: Sample Page
published: true
---

core到memory的接口要好，这个接口可以是由cache收，也可以是没cache时axi_interface收。

现在cpu7b里还是chiplab里原来的接口样式。

比如，

`````shell
inst_req
inst_addr
inst_valid
inst_rdata

data_req
data_addr
data_wr
data_data_ok
`````
现在只用到了简单的几个，能把数据读写出来就行，出错处理的还都没用上。

chiplab的这个接口也是后面改了的。

所以要参考别的代码，自己把这个接口定下来。

现在的想法是

inst_req inst_addr data_req data_addr都是只给一个pulse，由axi_interface负责保存。

给回的inst_valid inst_rdata data_data_ok data_rdata也都只给1一个cycle的pulse，由core保存。


是不是要有个valid ready的机制？
