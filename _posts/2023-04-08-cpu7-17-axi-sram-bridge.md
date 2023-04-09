---
title: 替换chiplab里的axi-sram-bridge
published: true
---

前两天自己搞了个最简单的axi-sram-bridge，只支持单次的读写，准备替换chiplab里的IP/AXI_SRAM_BRIDGE/soc_axi_sram_bridge.v


chiplab代码里默认定义的是AXI64，也就是数据是64位宽，地址宽都是还是32。

试了下把数据宽改为32，出错了，这个错也可能是因为之前把TLB拿掉，改了不少地方，现在不好确定了。

所以还是用64的。

把自己的axi_sram_bridge替换上去，结果取指没取到。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-04-08-0.png)

结果发现是数据在下降沿到了，比rvalid晚了半个cycle。

可能是verilator里testbench模拟的时候搞错了？先试试把chiplab里的模拟delay的AXI_DELAY_RAND去掉。

这个模拟读内存delay的模块之前也没搞清楚怎么用，每次delay没变化。


-----------------------

奇怪的事。

soc_axi_sram_bridge.v文件如果在IP/AXI_SRAM_BRIDGE/目录下，虽然在makefile里看，是会被编译，但并没有用到。

可这个文件在的话，不但编译了，还加到工程里了。比如随便一搜，有好多。

`````shell
../run_func/obj_dir/Vsimu_top___024root__39.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_data_push 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:        = ((IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_push) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:           & ((IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_pop) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:              | (~ (IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_valid))));
../run_func/obj_dir/Vsimu_top___024root__39.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_queue_push 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:        = ((((IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_push) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:             & (IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_valid)) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:            & (~ (IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_pop))) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:           & (~ (IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_queue_valid)));
../run_func/obj_dir/Vsimu_top___024root__39.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_queue_pop 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:        = ((IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_pop) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:           & (IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_queue_valid));
../run_func/obj_dir/Vsimu_top___024root__39.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_data_push 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:        = ((IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_push) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:           & ((IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_pop) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:              | (~ (IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_valid))));
../run_func/obj_dir/Vsimu_top___024root__39.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_queue_push 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:        = ((((IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_push) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:             & (IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_valid)) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:            & (~ (IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_pop))) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:           & (~ (IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_queue_valid)));
../run_func/obj_dir/Vsimu_top___024root__39.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_w_b_queue_push 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:        = ((((IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_a_pop) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:             & (IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_b_valid)) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:            & (~ (IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_b_pop))) 
../run_func/obj_dir/Vsimu_top___024root__39.cpp:           & (~ (IData)(vlSelf->soc_axi_sram_bridge__DOT__ram_w_b_queue_valid)));
../run_func/obj_dir/Vsimu_top.h:    VL_IN8(&soc_axi_sram_bridge__02Eaclk,0,0);
../run_func/obj_dir/Vsimu_top.h:    VL_IN8(&soc_axi_sram_bridge__02Earesetn,0,0);
../run_func/obj_dir/Vsimu_top.h:    VL_OUT(&soc_axi_sram_bridge__02Eram_raddr,31,0);
../run_func/obj_dir/Vsimu_top.h:    VL_IN64(&soc_axi_sram_bridge__02Eram_rdata,63,0);
../run_func/obj_dir/Vsimu_top.h:    VL_OUT8(&soc_axi_sram_bridge__02Eram_ren,0,0);
../run_func/obj_dir/Vsimu_top.h:    VL_OUT(&soc_axi_sram_bridge__02Eram_waddr,31,0);
../run_func/obj_dir/Vsimu_top.h:    VL_OUT64(&soc_axi_sram_bridge__02Eram_wdata,63,0);
../run_func/obj_dir/Vsimu_top.h:    VL_OUT8(&soc_axi_sram_bridge__02Eram_wen,7,0);
Binary file ../run_func/obj_dir/.Vsimu_top___024root.h.swp matches
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->__Vclklast__TOP__soc_axi_sram_bridge__02Eaclk 
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:        = vlSelf->soc_axi_sram_bridge__02Eaclk;
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__02Eaclk = VL_RAND_RESET_I(1);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__02Earesetn = VL_RAND_RESET_I(1);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__02Eram_raddr = VL_RAND_RESET_I(32);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__02Eram_rdata = VL_RAND_RESET_Q(64);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__02Eram_ren = VL_RAND_RESET_I(1);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__02Eram_waddr = VL_RAND_RESET_I(32);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__02Eram_wdata = VL_RAND_RESET_Q(64);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__02Eram_wen = VL_RAND_RESET_I(8);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_data_araddr = VL_RAND_RESET_I(32);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_data_araddr_next = VL_RAND_RESET_I(32);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_data_araddr_wrap = VL_RAND_RESET_I(32);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_data_arburst = VL_RAND_RESET_I(2);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_data_arid = VL_RAND_RESET_I(4);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_data_arlen = VL_RAND_RESET_I(4);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_data_arlen_last = VL_RAND_RESET_I(1);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_data_arsize = VL_RAND_RESET_I(3);
../run_func/obj_dir/Vsimu_top___024root__2__Slow.cpp:    vlSelf->soc_axi_sram_bridge__DOT__ram_r_a_data_push = VL_RAND_RESET_I(1);

`````

会导致编译失败。

`````shell
../testbench/include/ram.h: In member function ‘int CpuRam::process(vluint64_t)’:
../testbench/include/ram.h:260:47: error: ‘CpuTool::Vtop’ {aka ‘class Vsimu_top’} has no member named ‘ram_rdata’; did you mean ‘s_rdata’?
  260 |         process_read(main_time,read_addr,top->ram_rdata);
      |                                               ^~~~~~~~~
      |                                               s_rdata
../testbench/include/ram.h:263:27: error: ‘CpuTool::Vtop’ {aka ‘class Vsimu_top’} has no member named ‘ram_ren’
  263 |         read_valid = top->ram_ren;
      |                           ^~~~~~~
../testbench/include/ram.h:264:41: error: ‘CpuTool::Vtop’ {aka ‘class Vsimu_top’} has no member named ‘ram_raddr’
  264 |         if(read_valid)read_addr  = top->ram_raddr;
      |                                         ^~~~~~~~~
../testbench/include/ram.h:265:17: error: ‘CpuTool::Vtop’ {aka ‘class Vsimu_top’} has no member named ‘ram_wen’
  265 |         if(top->ram_wen){
      |                 ^~~~~~~
../testbench/include/ram.h:266:49: error: ‘CpuTool::Vtop’ {aka ‘class Vsimu_top’} has no member named ‘ram_waddr’
  266 |             return process_write(main_time,top->ram_waddr,top->ram_wen,top->ram_wdata);
      |                                                 ^~~~~~~~~
../testbench/include/ram.h:266:64: error: ‘CpuTool::Vtop’ {aka ‘class Vsimu_top’} has no member named ‘ram_wen’
  266 |             return process_write(main_time,top->ram_waddr,top->ram_wen,top->ram_wdata);
      |                                                                ^~~~~~~
../testbench/include/ram.h:266:77: error: ‘CpuTool::Vtop’ {aka ‘class Vsimu_top’} has no member named ‘ram_wdata’; did you mean ‘s_wdata’?
  266 |             return process_write(main_time,top->ram_waddr,top->ram_wen,top->ram_wdata);



../testbench/include/testbench.h: In member function ‘void CpuTestbench::simulate(vluint64_t&, int*)’:
../testbench/include/testbench.h:206:33: error: ‘CpuTool::Vtop’ {aka ‘class Vsimu_top’} has no member named ‘aclk’; did you mean ‘rclk’?
  206 |         vluint8_t& clock = top->aclk;
      |                                 ^~~~
      |                                 rclk
../testbench/include/testbench.h:207:33: error: ‘CpuTool::Vtop’ {aka ‘class Vsimu_top’} has no member named ‘aresetn’; did you mean ‘resetn’?
  207 |         vluint8_t& reset = top->aresetn;

`````

aclk aresetn ram_rdata ...这些怎么会未定义呢？


一但把IP/AXI_SRAM_BRIDGE/soc_axi_sram_bridge.v给删掉，编译错误就消失了。。。不知道是什么情况，verilator的bug吗?


在改这里的同时，我也把配置文件chip/config-generator.mak里CONFREG和AXI_RAND的y都改成n了，这部分对应的代码已经删掉了。

`````shell
#CONFREG=y
#AXI_RAND=y
# uty: test
CONFREG=n
AXI_RAND=n

`````

没去深究哪部分导致编译成功。


还是没忍住试了下。

上面改的两处都起作用了，删掉soc_axi_sram_bridge.v导致ram_rdata那几个信号未定义的error没有了。

CONFREG=n AXI_RAND=n让后面aclk，aresetn未定义的error消失了。

比如我又把CONFREG=y AXI_RAND=y改回来，错误就只变成aclk,aresetn找不到定义的error了。


`````shell
=============================================================================================================
=============================================================================================================
COMPILING testbench...
=============================================================================================================
=============================================================================================================
g++ -O3 -pthread -DCACHE_SEED=0 -DVL_THREADED -DRESET_VAL=0 -DRESET_SEED=1997 -std=c++11 -DWAVEFORM_SLICE_SIZE=10000 -DTRACE_SLICE_SIZE=100000 -DWAVEFORM_TAIL_SIZE=10000 -DTRACE_TAIL_SIZE=100000 -DRUN_FUNC -DSIMU_TRACE  -DOUTPUT_PC_INFO -DREAD_MISS_CHECK -DPRINT_CLK_TIME -DDUMP_VCD  -DCPU_2CMT  -DAXI64 -I/usr/local/share/verilator/include  -I/usr/local/share/verilator/include/vltstd -I../testbench/include -I./obj_dir /usr/local/share/verilator/include/verilated.cpp /usr/local/share/verilator/include/verilated_threads.cpp  /usr/local/share/verilator/include/verilated_vcd_c.cpp  /usr/local/share/verilator/include/verilated_fst_c.cpp /usr/local/share/verilator/include/verilated_save.cpp ../testbench/sim_main.cpp ./obj_dir/*__ALL.a -o output -lz 
In file included from ../testbench/include/ram.h:4,
                 from ../testbench/include/testbench.h:7,
                 from ../testbench/sim_main.cpp:3:
../testbench/include/rand64.h: In member function ‘int Rand64::tlb_init()’:
../testbench/include/rand64.h:364:40: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 3 has type ‘long long unsigned int’ [-Wformat=]
  364 |                 printf("i = %d,SIZE = %x\n",i,tlb->tlb_size);
      |                                       ~^      ~~~~~~~~~~~~~
      |                                        |           |
      |                                        |           long long unsigned int
      |                                        unsigned int
      |                                       %llx
../testbench/include/rand64.h:367:40: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 3 has type ‘long long unsigned int’ [-Wformat=]
  367 |                 printf("i = %d,SIZE = %x\n",i,tlb->tlb_size);
      |                                       ~^      ~~~~~~~~~~~~~
      |                                        |           |
      |                                        |           long long unsigned int
      |                                        unsigned int
      |                                       %llx
../testbench/include/rand64.h: In member function ‘void Rand64::print_ref(long long int*)’:
../testbench/include/rand64.h:420:47: warning: '0' flag used with ‘%s’ gnu_printf format [-Wformat=]
  420 |             printf("gr_ref[%02d] = %016llx%010sgr_rtl[%02d] = %016llx\n",i,gr_ref[i],"",i,gr_rtl[i]);
      |                                               ^
../testbench/include/rand64.h: In member function ‘int Rand64::compare(long long int*)’:
../testbench/include/rand64.h:432:47: warning: '0' flag used with ‘%s’ gnu_printf format [-Wformat=]
  432 |             printf("gr_ref[%02d] = %016llx%010sgr_rtl[%02d] = %016llx\n",i,gr_ref[i],"",i,gr_rtl[i]);
      |                                               ^
../testbench/include/rand64.h: In member function ‘void Rand64::update_once(vluint64_t)’:
../testbench/include/rand64.h:461:15: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘vluint64_t’ {aka ‘long unsigned int’} [-Wformat=]
  461 |     printf("[%dns] Updating ref reg, instruction is %08x, pc is 0x%016x, result_type is 0x%0x\n",main_time,instructions->data,pcs->data,result_type->data);
      |              ~^                                                                                  ~~~~~~~~~
      |               |                                                                                  |
      |               int                                                                                vluint64_t {aka long unsigned int}
      |              %ld
../testbench/include/rand64.h:461:56: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 3 has type ‘long long int’ [-Wformat=]
  461 |     printf("[%dns] Updating ref reg, instruction is %08x, pc is 0x%016x, result_type is 0x%0x\n",main_time,instructions->data,pcs->data,result_type->data);
      |                                                     ~~~^                                                   ~~~~~~~~~~~~~~~~~~
      |                                                        |                                                                 |
      |                                                        unsigned int                                                      long long int
      |                                                     %08llx
../testbench/include/rand64.h:461:71: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 4 has type ‘long long int’ [-Wformat=]
  461 |     printf("[%dns] Updating ref reg, instruction is %08x, pc is 0x%016x, result_type is 0x%0x\n",main_time,instructions->data,pcs->data,result_type->data);
      |                                                                   ~~~~^                                                       ~~~~~~~~~
      |                                                                       |                                                            |
      |                                                                       unsigned int                                                 long long int
      |                                                                   %016llx
../testbench/include/rand64.h:461:93: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 5 has type ‘long long int’ [-Wformat=]
  461 |     printf("[%dns] Updating ref reg, instruction is %08x, pc is 0x%016x, result_type is 0x%0x\n",main_time,instructions->data,pcs->data,result_type->data);
      |                                                                                           ~~^                                           ~~~~~~~~~~~~~~~~~
      |                                                                                             |                                                        |
      |                                                                                             unsigned int                                             long long int
      |                                                                                           %0llx
In file included from ../testbench/include/testbench.h:7,
                 from ../testbench/sim_main.cpp:3:
../testbench/include/ram.h: In member function ‘void CpuRam::jump(vluint64_t, vluint64_t)’:
../testbench/include/ram.h:82:30: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘vluint64_t’ {aka ‘long unsigned int’} [-Wformat=]
   82 |                 printf("mem[%d][%d].tag = %ld\n", idx, k+1, mem[idx][k+1].tag);
      |                             ~^                    ~~~
      |                              |                    |
      |                              int                  vluint64_t {aka long unsigned int}
      |                             %ld
../testbench/include/ram.h:83:30: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘vluint64_t’ {aka ‘long unsigned int’} [-Wformat=]
   83 |                 printf("mem[%d][%d].tag = %ld\n", idx, k, mem[idx][k].tag);
      |                             ~^                    ~~~
      |                              |                    |
      |                              int                  vluint64_t {aka long unsigned int}
      |                             %ld
../testbench/include/ram.h:84:30: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘vluint64_t’ {aka ‘long unsigned int’} [-Wformat=]
   84 |                 printf("mem[%d].size = %d\n", idx, mem[idx].size());
      |                             ~^                ~~~
      |                              |                |
      |                              int              vluint64_t {aka long unsigned int}
      |                             %ld
../testbench/include/ram.h:84:41: warning: format ‘%d’ expects argument of type ‘int’, but argument 3 has type ‘std::vector<RamSection>::size_type’ {aka ‘long unsigned int’} [-Wformat=]
   84 |                 printf("mem[%d].size = %d\n", idx, mem[idx].size());
      |                                        ~^          ~~~~~~~~~~~~~~~
      |                                         |                       |
      |                                         int                     std::vector<RamSection>::size_type {aka long unsigned int}
      |                                        %ld
../testbench/include/ram.h: In member function ‘int CpuRam::breakpoint_restore(vluint64_t, const char*)’:
../testbench/include/ram.h:331:28: warning: format ‘%s’ expects argument of type ‘char*’, but argument 3 has type ‘char (*)[10]’ [-Wformat=]
  331 |   while(fscanf(brk_file, "%s %ld\n", &tmp1, &tmp_data) != EOF) {
      |                           ~^         ~~~~~
      |                            |         |
      |                            char*     char (*)[10]
../testbench/include/ram.h:341:27: warning: format ‘%x’ expects argument of type ‘unsigned int*’, but argument 3 has type ‘char*’ [-Wformat=]
  341 |      fscanf(brk_file, "%02x\n", &rd_data);
      |                        ~~~^     ~~~~~~~~
      |                           |     |
      |                           |     char*
      |                           unsigned int*
      |                        %02hhx
../testbench/include/ram.h:355:27: warning: format ‘%x’ expects argument of type ‘unsigned int*’, but argument 3 has type ‘char*’ [-Wformat=]
  355 |      fscanf(brk_file, "%02x\n", &rd_data);
      |                        ~~~^     ~~~~~~~~
      |                           |     |
      |                           |     char*
      |                           unsigned int*
      |                        %02hhx
In file included from ../testbench/include/testbench.h:7,
                 from ../testbench/sim_main.cpp:3:
../testbench/include/ram.h: In member function ‘void CpuRam::process_read128(vluint64_t, vluint64_t, unsigned int*)’:
../testbench/include/ram.h:576:42: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 3 has type ‘vluint64_t’ {aka ‘long unsigned int’} [-Wformat=]
  576 |             fprintf(stderr,"Read Catch! %x,%d\n",a,simu_dev);
      |                                         ~^       ~
      |                                          |       |
      |                                          |       vluint64_t {aka long unsigned int}
      |                                          unsigned int
      |                                         %lx
../testbench/include/ram.h: In member function ‘void CpuRam::process_read(vluint64_t, vluint64_t, unsigned int*)’:
../testbench/include/ram.h:597:42: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 3 has type ‘vluint64_t’ {aka ‘long unsigned int’} [-Wformat=]
  597 |             fprintf(stderr,"Read Catch! %x,%d\n",a,simu_dev);
      |                                         ~^       ~
      |                                          |       |
      |                                          |       vluint64_t {aka long unsigned int}
      |                                          unsigned int
      |                                         %lx
In file included from ../testbench/sim_main.cpp:3:
../testbench/include/testbench.h: In member function ‘int CpuTestbench::eval(vluint64_t&)’:
../testbench/include/testbench.h:173:36: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘vluint64_t’ {aka ‘long unsigned int’} [-Wformat=]
  173 |             printf("Dump Start at %d ns\n",main_time,dump_delay);
      |                                   ~^       ~~~~~~~~~
      |                                    |       |
      |                                    int     vluint64_t {aka long unsigned int}
      |                                   %ld
../testbench/include/testbench.h:173:20: warning: too many arguments for format [-Wformat-extra-args]
  173 |             printf("Dump Start at %d ns\n",main_time,dump_delay);
      |                    ^~~~~~~~~~~~~~~~~~~~~~~
../testbench/include/testbench.h: In member function ‘void CpuTestbench::simulate(vluint64_t&, int*)’:
../testbench/include/testbench.h:206:33: error: ‘CpuTool::Vtop’ {aka ‘class Vsimu_top’} has no member named ‘aclk’; did you mean ‘rclk’?
  206 |         vluint8_t& clock = top->aclk;
      |                                 ^~~~
      |                                 rclk
../testbench/include/testbench.h:207:33: error: ‘CpuTool::Vtop’ {aka ‘class Vsimu_top’} has no member named ‘aresetn’; did you mean ‘resetn’?
  207 |         vluint8_t& reset = top->aresetn;
      |                                 ^~~~~~~
      |                                 resetn
In file included from ../testbench/include/testbench.h:7,
                 from ../testbench/sim_main.cpp:3:
../testbench/include/ram.h: In member function ‘int CpuRam::breakpoint_restore(vluint64_t, const char*)’:
../testbench/include/ram.h:336:11: warning: ignoring return value of ‘int fscanf(FILE*, const char*, ...)’, declared with attribute warn_unused_result [-Wunused-result]
  336 |     fscanf(brk_file, "@tag %ld\n", &tag);
      |     ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../testbench/include/ram.h:341:12: warning: ignoring return value of ‘int fscanf(FILE*, const char*, ...)’, declared with attribute warn_unused_result [-Wunused-result]
  341 |      fscanf(brk_file, "%02x\n", &rd_data);
      |      ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../testbench/include/ram.h:350:11: warning: ignoring return value of ‘int fscanf(FILE*, const char*, ...)’, declared with attribute warn_unused_result [-Wunused-result]
  350 |     fscanf(brk_file, "@tag %ld\n", &tag);
      |     ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../testbench/include/ram.h:355:12: warning: ignoring return value of ‘int fscanf(FILE*, const char*, ...)’, declared with attribute warn_unused_result [-Wunused-result]
  355 |      fscanf(brk_file, "%02x\n", &rd_data);
      |      ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
make[1]: *** [Makefile:215: testbench] Error 1
make[1]: Leaving directory '/home/u/prjs/cpu7/sims/verilator/run_func'
make: *** [Makefile:50: compile] Error 2

`````


--------------------------

这次编译过了，但例子还是跑失败，看下波形。

![screenshot1](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-04-08-1.png)

还是以前那样，数据比rvalid慢半个cycle。而且rready在等到rvalid后也没有变0，rready是一直拉高的。

rready不下来，这次的传输就一直结束不了，导致只有这一次取指。

看来还是ram模拟的部分出问题了。


verilator看样子是以半个cycle为单位，每次对于top的输入有变化时都eval()。

cpu7/sims/verilator/testbench/include/testbench.h
`````c
    void simulate(vluint64_t& main_time, int* nStatus){
        if(!simu_quiet)fprintf(stderr,"Verilator Simulation Start.\n");
        int emask = status_call_finish;
        vluint8_t& clock = top->aclk;
        vluint8_t& reset = top->aresetn;
        long long clock_total = 0;
        bool uart_div_set = false;
        bool div_reinit = false;
        int p_config;
        unsigned int div_val_1 = 0;
        unsigned int div_val_2 = 0;
        unsigned int div_val_3 = 0;
        static const int reset_valid = 0;
        #define EVAL ((clock=!clock),main_time+=1,this->eval(main_time))
        #define EVAL_no_clock_change (this->eval(main_time))
		if (restore_bp_time == 0){
        	reset = reset_valid;
        	clock = 0;
        	//top->enable_delay = simu_bus_delay;
        	//top->random_seed = simu_bus_delay_random_seed;
            //printf("random seed is %d\n", simu_bus_delay_random_seed);
        	for(int i=0;i<10;i+=1){if(EVAL)break;}
		}
        clock = 0;
        //top->enable_delay = simu_bus_delay;
        //top->random_seed = simu_bus_delay_random_seed;
        if(!EVAL){
            reset = !reset_valid;
            emask = 0;
            #ifdef RAND_TEST
            int init_error = rand64->init_all();
            if (init_error) {
                printf("RAND TEST INIT FAILED\n");
                return ;
            }
            #endif
            printf("Start\n");
            while(true){
                // Simulate until exit
				if ((main_time <= (save_bp_time+1) && main_time >= (save_bp_time-1)) && (break_once == 0)) {
					if (main_time != save_bp_time) {
						printf("Warning: real break point main time is %ld\n", main_time);
					}
					ram->breakpoint_save(main_time, ram_save_bp_file);
					save_model(main_time, top_save_bp_file);
					printf("save break point over!\n");
					break_once = 1;
				}
                emask|= ram->process(main_time);
		// uty: test
                //if(EVAL_no_clock_change)break;

                //uart receive
                top->uart_rx = (*uart)(top->uart_tx);
                //uart reconfig
                if(top->uart_enab && top->uart_rw) {
                    switch(top->uart_addr) {
                        case 0: 
                            if(uart_div_set == true) {
                                div_val_1 = top->uart_datai;
                                div_reinit = true;
                            }
                            break;
                        case 1:
                            if(uart_div_set == true) {
                                div_val_2 = top->uart_datai << 8;
                                div_reinit = true;
                            }
                            break;
                        case 2:
                            if(uart_div_set == true) {
                                div_val_3 = top->uart_datai << 16;
                                div_reinit = true;
                            }
                            break;
                        case 3:
                            if(uart_div_set == false && (top->uart_datai & 0x80) == 0x80) {
                                uart_div_set = true;
                            }
                            else if(uart_div_set == true && (top->uart_datai & 0x80) == 0) {
                                if (div_reinit == true) {
                                    uart_config = (uart_config & 0xff000000) | ((div_val_1 + div_val_2 + div_val_3) * 16);
                                    div_reinit = false;
                                }
                                uart_div_set = false;
                            }
                            switch (top->uart_datai & 0x30) {
                                case 0x00: 
                                    p_config = 0x0;
                                    break;
                                case 0x10:
                                    p_config = 0x1;
                                    break;
                                case 0x20:
                                    p_config = 0x3;
                                    break;
                                case 0x30:
                                    p_config = 0x2;
                                    break;
                                default:
                                    p_config = 0x0;
                            }
                            uart_config = (uart_config & 0x00ffffff) | ((3 - (top->uart_datai & 0x3)) << 28) 
                                                                     | ((top->uart_datai & 0x4) << 25)  
                                                                     | ((top->uart_datai & 0x8) << 23)  
                                                                     | (p_config << 24);
                            /*
                            //set bit
                            uart_config = (uart_config & 0x0fffffff) | ((3 - (top->datai & 0x3)) << 28);
                            //set stop
                            uart_config = (uart_config & 0xf7ffffff) | ((top->datai & 0x4) << 25);
                            //set parity
                            uart_config = (uart_config & 0xfbffffff) | ((top->datai & 0x8) << 23);
                            //set fixdp and evenp
                            uart_config = (uart_config & 0xfcffffff) | (p_config << 24);
                            */
                            //debug
                            //printf("uart datai is %x\n", top->uart_datai);
                            //printf("uart config is %x\n", uart_config);
                            uart->setup(uart_config);
                            break;
                    }
                }
		// uty: test
                if(EVAL)break;
                //if(EVAL_no_clock_change)break;
                emask|= time_limit->process(main_time);
                #ifndef RAND_TEST
//                emask|= golden_trace->process(main_time);
                #endif
                if(EVAL)break;
                if(emask)break;
                clock_total += 1;
            }
        }
        printf("total clock is %lld\n", clock_total);

	// uty: test
//	printf ("uty: test golden_trace->reg[5]: %llx\n", golden_trace->reg[5]);
//
//	if (0x5a == golden_trace->reg[5])
//	{
//		*nStatus = 0;
//	}
//	else
//	{
//		*nStatus = -1;
//	}


        EVAL;
        #undef EVAL
        display_exist_cause(main_time,emask);
        close();
    }
`````

这个代码里最不显眼的EVAL，就是这里的关键。对于soc_top来说，外界的输入变化，只有ram，uart和中断。

这里不考虑uart。

因为ram是模拟的，当ram_rdata从文件里读出给出来后，需要更新soc_top的状态。

比如`emask|= ram->process(main_time);`以后，后面就有`if(EVAL)break;`

`````c
#define EVAL ((clock=!clock),main_time+=1,this->eval(main_time))
`````

这个宏里有clock的翻转，还有时间加1。

试了下clock不翻转，时间也不加1，就直接eval()。

结果确实可以把延后半个cycle的问题解决，如下图。

![screenshot3](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-04-08-3.png)

但同时运行时也给出了很多warning，像这种。

`````shell
Read Miss For Addr18.
%Warning: previous dump at t=1567, requesting t=1567, dump call ignored
Read Miss For Addr18.
%Warning: previous dump at t=1568, requesting t=1568, dump call ignored
Read Miss For Addr18.
%Warning: previous dump at t=1569, requesting t=1569, dump call ignored
Read Miss For Addr18.
%Warning: previous dump at t=1570, requesting t=1570, dump call ignored
Read Miss For Addr18.
%Warning: previous dump at t=1571, requesting t=1571, dump call ignored
Read Miss For Addr18.
%Warning: previous dump at t=1572, requesting t=1572, dump call ignored
Read Miss For Addr18.
%Warning: previous dump at t=1573, requesting t=1573, dump call ignored
Read Miss For Addr18.
%Warning: previous dump at t=1574, requesting t=1574, dump call ignored
Read Miss For Addr18.
%Warning: previous dump at t=1575, requesting t=1575, dump call ignored
Read Miss For Addr18.
%Warning: previous dump at t=1576, requesting t=1576, dump call ignored
Read Miss For Addr18.
%Warning: previous dump at t=1577, requesting t=1577, dump call ignored
Read Miss For Addr18.
%Warning: previous dump at t=1578, requesting t=1578, dump call ignored
Read Miss For Addr18.
%Warning: previous dump at t=1579, requesting t=1579, dump call ignored

`````
感觉要搞这个，还得把verilator搞清楚，先得保证测试框架是正确的，还得确定出chiplab里l1cache的axi master也没问题，最终才能验证我写的axi_sram_bridge中的问题。

并且注意到chiplab里发出的axi请求是带burst的，而现在我还没搞burst。

做这个axi_sram_bridge目的是为做l1 cache做准备，现在感觉搞复杂了。

还不如用modelsim做验证，重写之前的测试例子。

------------------------------------------------------------------------
刚注意到发过来的ar请求是带burst的，arid是7，我也没处理。


这ram_rdata晚半个cycle的问题，在原来的soc_axi_sram_bridge里，它的ram_rdata是在收到arvalid后，间隔1个cycle后，才给出的rdata和rvalid。也就是说读ram要2个cycle，但这时rdata和rvalid是对齐的。

![screenshot2](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-04-08-2.png)

但是这个rready还是没见低下去。


-------------------

后来后来我又想了下，rready是不需要在rvalid high后必须拉低的，表示仍然可以在下一个cycle接收数据。

我之前实现的方式是rready在rvalid一起high后，rready拉低至少一个cycle。现在看来，如果是burst，rvalid可以好几个cycle都是high，rready一直high也没问题。

---------------------------------------------------------

chiplab的代码把soc_axi_sram_bridge改回去，去掉了axi_apb_bridge和CONFREG，以及AXI_RAND，AXI_SLAVE_MUX等模块。现在是只有cpu和soc_axi_sram_bridge直接到sram。

代码能编译，测试例子也全都跑通了，说明取指啥的都没问题，应该和之前一样。

但我看了下波形，发现soc_axi_sram的实现还是有问题，还是rdata比rvalid晚半个cycle。

只是说这个问题在verilator模拟的时候被错误的模拟了，所以读的值是对的，但这个协议从波形上看是有问题的。

![screenshot4](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-04-08-4.png)

黄框这里上升沿rvalid rready都是1，这里就应该rdata取值了，而这时的rdata是0，真正的值在下降沿才到，所以这样肯定是有问题的。
