---
title: reset的一个有意思的地方
published: true
---

没找到是什么的原因，先看下这个简单的代码。

````verilog
  77    dffr_s #(1) busy_reg (                                                                                                                    
  78       .din   (ar_enter & (~r_retire)),                                                                                                       
  79       .clk   (aclk),                                                                                                                         
  80       .rst   (~resetn),                                                                                                                      
  81       .q     (busy),                                                                                                                         
  82       .se(), .si(), .so());  
````

ar_enter为1，r_retire为0时，输入为1，busy也就此为1。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-03-10-0.png)

图上黄框也是这样显示的，这个时候的reset复位结束变1的时候clk正好在上升沿。（感觉这种时候在实际电路上会让事情更复杂，因为reset和clk应该不会同步的很准。）

接下来是reset为1的时候正是clk的下降沿。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-03-10-1.png)

黄框中这个时候在上升沿ar_enter为1，r_retire为0，而busy得到的是x。虽然busy在下一个cycle有值了，但这时候ar_enter和r_retire全为0了，所以busy为0。

这样busy就错过了开始这个本该为1的cycle。

不知道是什么原因。

如果不用dffr_s，用不带reset的dff_s。

结果则是没问题的。


![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-03-10-2.png)


再试下reset到clk上升沿后面一点。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-03-10-3.png)

还是不对，这时候怎么也不应该是x啊，首先reset的时候应该把dffr_s初始化成0，应该前面就不是x了。


-----------------

原因找到了。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-03-10-4.png)

rst一直是x，结果发现resetn敲错了，应该是aresetn。

白废了这么久，还特意写个blog。

不过问题又来了，rst一直是x，为啥后面q又成0了？
