---
title: 香山里的page table walker
published: true
---

ptw里的l1,l2,l3

PTW module里的参数，page cache发给ptw的请求。

`````verilog
  output        io_req_ready,
  input         io_req_valid,
  input  [37:0] io_req_bits_req_info_vpn,
  input  [1:0]  io_req_bits_req_info_s2xlate,
  input  [1:0]  io_req_bits_req_info_source,
  input         io_req_bits_l3Hit,
  input         io_req_bits_l2Hit,
  input  [43:0] io_req_bits_ppn,
  input         io_req_bits_stage1Hit,

`````

其中有l3Hit和l2Hit。

从代码里看，l3Hit是支持Sv48时，根页表（level 3）tlb hit。（这个不好说是不是叫level3页表，香山文档里的叫法和代码里好像不一致）

l3Hit在Sv39时不用。l2Hit在Sv39里是根页表（level 2）tlb hit。

以Sv39为例，l2，l1，l0三级分页，l0是leaf pte。

对于ptw来说，只处理l2，l1的page walk，l0 leaf pte是由llptw（Last Level Page Table Walker）处理。

所以只可能有l2Hit，不可能同时l2Hit，l1Hit，因为这样的情况就发给llptw了。

对于Sv48来说，最多可能有同时l3Hit，l2Hit。

这也是为什么ptw的参数里面没有l1Hit。

ptw里有内部信号level，af\_level（access fault level）表示当前要处理的page table是几级的。这里还没仔细看，大概是这个意思。


一开始比较乱的地方是文档里对l1 l2 l3 sp的解释，这里给出的是l1是根页表，l2是下一级，l3是leaf pte，sp是大页。l1 l2 l3和ptw里的顺序是反的。但这个是page cache的，需要看下代码才能知道是文档写错了，还是page cache里就这样命名的。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/pagecache_l234sp.png)

----------------------------------------------

stage1Hit是在支持虚拟扩展后才用的，stage1是指guest va到guest pa阶段，stage2是指虚拟化里guest pa到host pa，相当于intel x86 vtv里的EPT。

s2xlate(stage 2 translate)

00 noS2xlate, 01 onlyStage1, 10 onlyStage2, 11 allStage

不考虑虚拟化的时候，就用00 noS2xlate。


