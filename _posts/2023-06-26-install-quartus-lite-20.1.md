---
title: 装Quartus Lite 20.1, 在Windows WSL
published: true
---


电脑坏了真烦。


在Windows WSL下没法运行32-bit程序，所以quartus最少也得20.1版本。

装完运行quartus，先设置路径。

~/.bashrc

`````shell
export PATH=$PATH:~/intelFPGA_lite/20.1/quartus/bin
export PATH=$PATH:~/intelFPGA_lite/20.1/modelsim_ase/bin
`````

有几个lib没有。


`````shell
sudo apt-get install -y libsm6 libxext6 libxrender-dev
`````

Then the following errors showed up.

`````shell
warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8): No such file or directory
realloc(): invalid pointer
Aborted (core dumped)

`````

To solve the first warning, run:

`````shell
sudo dpkg-reconfigure locales
`````

It brings a text based GUI. Choose "en_US.UTF-8".




Now the realloc() problem. At first I thought this would solve it.

>  Greetings! 
>  
>   
>  
>  I spent a couple days chewing on this, and eventually found https://github.com/chriz2600/quartus-lite. The interesting thing about their implementation is that they're using tcmalloc (http://goog-perftools.sourceforge.net/doc/tcmalloc.html) instead of the stock malloc, which is unusual enough that I had to try it. Sure enough, installing libtcmalloc-minimal4 and then LD_PRELOADing it did the trick: 
>  
>   
>  
>  
>  export LD_PRELOAD=/usr/lib/libtcmalloc_minimal.so.4
>  ${QUARTUS_PATH}/nios2eds/nios2_command_shell.sh ./build.sh -r ${_revision} -s ${_size}
>   
>  
>   
>  
>  I've also found it beneficial(?) to delete ${QUARTUS_PATH}/quartus/linux64/libboost_system.so, libccl_curl_drl.so, and libstdc++.so.6, leaving it to use the stock Ubuntu versions instead (which are installed by the build-essential package, I believe). This is mostly because of suggestions for solving another error: 
>  
>   
>  
>  Inconsistency detected by ld.so: dl-close.c: 811: _dl_close: Assertion `map->l_init_called' failed!
>   
>  
>   
>  
>  Hopefully this is useful information! Everything is working great with Quartus 17.0 for me, so far. 



So I tried.

`````shell
$ sudo apt install libtcmalloc-minimal4
$ export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4
`````

Turns out, this is a quartus issue with WSL on Windows.



https://community.intel.com/t5/Intel-FPGA-Software-Installation/Running-Quartus-Prime-Standard-on-WSL-crashes-in-libudev-so/m-p/1189032



I don't know what happened in my case, but I did the same thing.

`````shell
$ sudo apt install libudev-dev

$ export LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so     <--- this is not necessary

`````

Solved.


