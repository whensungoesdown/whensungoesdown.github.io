---
title: icache用linear address，effective address预测
published: false
---

教科书里常见的icache都VIPT，virtual address index, physial tag.

virtual address index其实也就是low 12-bit，和physical address里这部分都是相同的。

而tag需要用physical address里的bits。这就需要TLB做virtual address到physical address的转换。如果TLB hit，速度很快，TLB少的1 cycle？

如果TLB miss，在x86里就需要page table walk了。


但如果是在大型的cpu里，TLB数量很多，可能不能很快给回结果。比如TLB是icache和dcache共用，cpu又是多线程。可能TLB不能很快给回结果。

还有个问题就是prefetch，prefetch是需要用linear address的。

所以有的icache是先用linear address做index和tag，先predict。等后面physical address结果返回后再看是不是预测正确。


大该结构是这样，分几部分。

`````c
icache

icache directory (idir)       stores real address

icache effective (ieadir)     stores effective address

icache effective real address translation (ierat)
`````

当ifar发出一个ea需要查询ic时，先用ea[]做index，ea[]做tag，在ieadir里查询。

ieadir给出predict_way，用这个在icache的array里查出data。

后续的？ cycle后ierat给出ea对应的ra，用这个ra再去idir里查询，看之前predict的way是否正确。

如果不正确会触发ifu里这个thread的hold。



-------------------------------------------------------

iffbt用ea iffbt_ifar_inn(41 to 51) 先到ieadir查询

cam_ieadir_mac有两个，iffea0和iffea1。

用rd_addr(0 to 4) => iffbt_ifar_inn(56 to 52）作为index去读，但这里的顺序时反的。

用cmp_data(0 to 10) => iffbt_ifar_inn(41 to 51) 作为tag去和regfile里取出来的数据做比较。

同时也要带着thread_cmp_data_thread(0 to 4) => iffec_if1_eadir_thread(0 to 4)。

ieadir去和regfile里取出来的数据做比较。

同时也要带着thread_cmp_data_thread(0 to 4) => iffec_if1_eadir_thread(0 to 4)。


ieadir给出了结果almost_way_select，ic_way_select，way_select。

ic_way_select和way_select只是clk gate不同。

almost_way_select以后再说。


ic_way_select(0 to 8)一共9 bit。

iffea0给出ic_way_select(0 to 3), iffea1给出ic_way_select(4 to 7)。

ic_way_select(8)似乎同write through有关，还不清楚。


用ic_way_select(0 to 8)和iffbt_ifar_inn去8个cab_icache_mac_syn里查询data。iffic0-iffic7

cab_icache_mac_syn里有个early_way_select，先不用管，似乎和powerup时最初的选way有关，后面这个信号不再用，就变成“1111”了。

iffic0-iffic7分别读出44 bit，iffic0_if2_data_out_b(0 to 43) - iffic7_if2_data_out_b，似乎应该时32bit cache data，但有些其它不知道是不是校验位还是predecode信息。

icache的8个iffic0-iffic7，每个存一个字节的bit，8个组成一个byte。比如iffic0存44-byte的第0 bit，iffic1存第1 bit。

iffic0-iffic7读出的这8个44-bit，组合成iffic_if2_w4w6_munged_b(0 to 87) 与 iffic_if2_w5w7_munged_b(0 to 87) 传给iffcb0:iffcb_cbufregs_mac。

组合成iffic_if2_w0w1_munged_b(0 to 87) 与 iffic_if2_w2w3_munged_b(0 to 87) 传给iffcb1:iffcb_cbufregs_mac。

然后由iffcb0和iffcb1分别生成8条ppc指令。

`````verilog
iffcb4_if3_ppc_instr(0 to 31)
iffcb4_if3_ppc_predec(0 to 8)

iffcb5_if3_ppc_instr(0 to 31)
iffcb5_if3_ppc_predec(0 to 8)

iffcb6_if3_ppc_instr(0 to 31)
iffcb6_if3_ppc_predec(0 to 8)

iffcb7_if3_ppc_instr(0 to 31)
iffcb7_if3_ppc_predec(0 to 8)

iffcb0_if3_ppc_instr(0 to 31)
iffcb0_if3_ppc_predec(0 to 8)

iffcb1_if3_ppc_instr(0 to 31)
iffcb1_if3_ppc_predec(0 to 8)

iffcb2_if3_ppc_instr(0 to 31)
iffcb2_if3_ppc_predec(0 to 8)

iffcb3_if3_ppc_instr(0 to 31)
iffcb3_if3_ppc_predec(0 to 8)
`````

接下来这8条指令就进到iffrd: iffrd_inc_dec_mac里去decode。

ieadir ea(52 to 56)，5-bit， 可以寻址32 sets，再加上way_select指出是哪个way，就可以在icache里读出data。这个data这时是通过ea预测的。

````verilog
cab_icache_mac_syn

.rd_addr(0 to 2) => iffbt_ifar_inn(56 to 58),
.rd_addr(3 to 6) => iffbt_ifar_inn(52 to 55),
`````
也就是52 to 58，一共7 bits

addressing 32 sets + 2-bit，这2 bits应该是用来确定ram line的。

也就是说p8 L1 icache cacheline是128 byte，ramline 是32 byte，实际iffic读出的是44 byte。




