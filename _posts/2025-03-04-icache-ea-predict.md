---
title: icache用linear address，effective address预测
published: true
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


iffic0-7内部又分top_l top_r bot_l bot_r。

top_l和top_r存着sets 0 4 1 5

bot_l和bot_r存着sets 2 6 3 7

再具体，应该是top_l存着前22-bit的0 4 1 5 sets


从ieadir的ea index (52 to 56) 是可以看出cache line的大小的。因为ea是(0 to 63)，所以用(52 to 56)剩下的就是(57 to 63)，是7 bits。

2的7次方是128，所以cacheline长度是128byte。这个事该怎么想呢，比如ea(52 to 56)分别是00000和00001，这就是2个相邻的cacheline，00000 0000000和00001 0000000相差的就是128字节。

所以p8 L1 icache是 32-set * 8-way * 128-byte = 32KB

每个cam_ieadir_mac里存4个way的tag， iffea0，iffea1一共8 way。

-----------------------------------------------------


现在有个问题要看看，位什么cam_icache_mac_syn的rd_addr是这样

`````verilog
iffic0 - iffic3

rd_addr(0 to 2) => iffbt_ifar_inn(56 to 58),
rd_addr(3 to 6) => iffbt_ifar_inn(52 to 55),


iffic4 - iffic7

rd_addr(0) => iffbt_ifar_inn(56),
rd_addr(1 to 2) => iffbt_ifar_inn(57 to 58),
rd_addr(3 to 6) => iffbt_ifar_inn(52 to 55),
`````

在cam_icache_mac_syn里

`````verilog
assign wr_bank_addr = wr_addr[1:3];
assign rd_bank_addr = rd_addr[0:2];
`````

只看rd的情况，iffbt_ifar_inn(56 to 58）是bank，但这个bank只用做检测read write conflict。

`````verilog
assign rd_wr_bank_conflict = (wr_act == 1'b1) & (rd_act == 1'b1) & (wr_bank_addr == rd_bank_addr);
`````

现在还没搞清楚这个问题。


-------------------------------------------------------------


idir有4个，iffid0 - iffid 3

idir有两个读端口，但长度有点奇怪。

`````verilog
r_addr_in0(0 to 5) => iffec_if1_idir_ea(51 to 56),
r_addr_in1(0 to 4) => iffec_if2_ifar(52 to 56),
`````

首先这两个读端口不一样大，从idir模块名来看

cag_crf_2r1w_nana_d_0064x056_sanowma_idir_hrd 这个regfile有64个entries，每个entry长度是56-bit。

64 entries，就需要6-bit的地址。

这样看端口r_addr_in_1就少了1个bit

`````verilog
iffid0: entity work.cag_crf_2r1w_nana_d_0064x056_sanowma_idir_hrd
port map (

...

   r_addr_in_0 (0 to 5) => iffec_if1_idir_ea (51 to 56),
   r_addr_in_1 (0 to 4) => iffbt_if2_ifar (52 to 56),
   r_data_out_0 (0 to 55) => iffid0_data_out_0 (0 to 55),
   r_data_out_1 (0 to 55) => iffid0_data_out_1 (0 to 55),
   r_en_early_0         => iffec_if1_icbi_prefetch,
   r_en_early_1         => iffec_if2_valid,
   r_en_hc_0            => '1',
   r_en_hc_1            => '1',
   r_en_late_0          => '1',
   r_en_late_1_d        => iffea_if2_way_select (0),          <---
   r_en_late_1_u        => iffea_if2_way_select (2),          <---

...

);

`````

原因是r_addr_in0的r_en_late_0是1，而r_addr_in_1的r_en_late_1_d r_en_late_1_u分别是iffea_if2_way_select(0) iffea_if2_way_select(2)。

idir内部是两个64 entries 28-bit的regfile，看来一个tag是28-bit。iffid0存way0 way2的ra tag。

iffid1存way1 way3，

iffid2存way4 way6,

iffid3存way5 way7。

r_addr_in_1（端口1）是用来验证前面ieadir icache读出的data是否符合ta tag。r_addr_in_0（端口0）的作用还不清楚。

这个验证的过程是由iffed: iffed_erat_dataf_mac做的，如果读回的tag和erat它自己翻译后得到的tag不相同，iffed将hold ifar中的地址生成逻辑。

------------------------------------------------------------------

从时钟周期上看


###if1

`````verilog
iffbt_ifar_inn, iffbt_if1_eadir_thread   ====>  iffea0 iffea1   
                                                     |
                                                      
                                                     |
                                                     V
                                          iffea_ic_way_select
                                                     +
                                                iffbt_ifar_inn  ====> iffic0-iffic7
                                                                            |

`````

###if2

`````verilog
                                                                            |
                                                                            v
                                                                     iffic0_if2_data_out_b
                                                                     iffic7_if2_data_out_b   (predicted cache data)


                                                                            
       iffea_if2_way_select
       iffea_if2_ifar        ====> iffid0-iffid3
                                         |
                                     
`````

###if3

`````verilog
                                         |
                                         v
                                  iffid0_data_out_1
                                  iffid3_data_out_1   ====> iffed (--> if4_idir_data_cg3_in)
                                                                               |
`````

###if4

`````verilog
                                                                               |
                                                                               v
                                                                 iffed(  if4_idir_data_q --> if4_idir_ra
                                                                                                 
                                                                                             if4_erat_ra) --> if4_icache_hit
`````

可以看出，if2时通过ea预测得到icache的数据（也就是指令），要到if4才能知道预测的对不对，是否是真的icache hit。
