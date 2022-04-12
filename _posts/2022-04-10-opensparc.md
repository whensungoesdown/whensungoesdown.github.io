---
title: 试试OpenSPARC
published: true
---

准备试下OpenSPARC T1, 但我没有VCS，NCV这些。
看看modelsim能不能模拟，iverilog或者Xilin ISE能不能合成。

OpenSPARC T1的包解压，比如到~\prjs\OpenSPARCT1，再建一个~\prjs\OpenSPARCT1_model，一会要用。

cd OpenSPARCT1

然后看README里说的。我现在有OpenSPARC T1 Processor Design and Verification User's Guide，还有OpenSPARC Internals。但最后还是看README。

用bash shell的，就改OpenSPARCT1.bash。主要就改目录地址和安装的EDA工具，我现在啥也没有，就有mdoelsim，先不管，都注释掉。

`````shell
# User needs to define these new variables

export DV_ROOT=/home/u/prjs/OpenSPARCT1
export MODEL_DIR=/home/u/prjs/OpenSPARCT1_model

if [ `uname -s` = "SunOS" ]
then
  export CC_BIN="/usr/dist/pkgs/sunstudio_`uname -p`/SUNWspro/bin"
else
  export CC_BIN=/usr/bin
fi

# Please define VERA_HOME only if you have VERA, otherwise comment it out.

#if [ `uname -s` = "SunOS" -a `uname -p` = "sparc" ]
#then
#  export VERA_HOME=/import/EDAtools/vera/vera,v6.2.10/5.x
#else
#  export VERA_HOME
#fi

# Please define VCS_HOME only if you have VCS, otherwise comment it out.

#export VCS_HOME=/import/EDAtools/vcs/vcs7.1.1R21

# Please define NCV_HOME only if you have NC-Verilog, otherwise comment it out.

#export NCV_HOME=/import/EDAtools/ncverilog/ncverilog.v5.3.s2/5.x

# Please define NOVAS_HOME only if you have Debussy, otherwise comment it out.

#if [ `uname -s` = "SunOS" -a `uname -p` = "sparc" ]
#then
#  export NOVAS_HOME=/import/EDAtools/debussy/debussy,v5.3v19/5.x
#fi

`````

这之后，就按README里说的，`source OpenSPARCT1.bash`

然后
`````shell
$ cd ..
$ cd OpenSPARCT1_model
$ sims -sim_type=vcs -group=core1_mini
`````

我没有vcs，先试下，因为后面马上出错了。

`````shell
u@unamed:~/prjs/OpenSPARCT1_model$ sims -sim_type=vcs -group=core1_mini
sims -> .local_tool_wrapper: configsrch returned error code 127 Exiting ...
`````

这个是完全没一点出错信息，tools/src/configsrch/里虽然是这个程序的源码，但也没找到127。
网上有人回答这个问题。

> I don't think that re-compilation is needed. Most likely, the environment needs to be set up properly. Here's a list of variables that need to be set for any of the OpenSPARC tools to work properly:
> DV_ROOT=<path to your OpenSPARC installation>
> TRE_ENTRY=/
> TRE_SEARCH=$DV_ROOT/tools/env/tools.iver
> And, of course, you need the correct setup for any other CAD tools you are using.
> You can debug by using the following procedure
> % touch /tmp/tre_log.log
> % setenv TRE_LOG /tmp/tre_log.log
> % rsynp
> % cat /tmp/tre_log.log
> Then you can paste the contents of the log file back to this forum, to help debugging.
> Most tools that have some configuration error will report debugging information to a file if the environment variable TRE_LOG points to a real file that is writable. However, the sims script is different, and doesn't do this. However, if configsrch returns 127 for sims, it will most likely return 127 for any other OpenSPARC tool. That's why I suggeset running rsynp.
> Hope this helps,
> Tom 
> 
> this is the Error I get in my log file
> ERROR: configsrch returned error code 1
> DATE: Thu Apr 30 18:20:22 CEST 2009
> WRAPPER: /home/dj/SPARCT2/SparcT2/tools/bin/perl_wrapper
> USER:
> HOST: woodstock
> SYS: Linux 2.6.22-gentoo-r5
> PWD: /home/dj/SPARCT2/SparcT2
> ARGV:
> TOOL: rsynp
> VERSION: /home/dj/SPARCT2/SparcT2/tools/bin/configsrch: line 11: /home/dj/SPARCT2/Sp
> arcT2/tools/Linux/x86_64/configsrch: cannot execute binary file /home/dj/SPARCT2/SparcT2/tools
> /bin/configsrch: line 11: /home/dj/SPARCT2/SparcT2/tools/Linux/x86_64/configsrch: Success
> TRE_SEARCH: /home/dj/SPARCT2/SparcT2/tools/env/OpenSparc_N2.iver
> TRE_ENTRY: / 
> 
> rsynp (FPGA synthesis using Synplicity) is not supported in OpenSPARC T2.
> This flow is only supported in OpenSPARC T1.
> current rsynp in the T2 bundle is just a place holder for a future support.




照着做。

`````shell
u@unamed:~/prjs/OpenSPARCT1_model$ touch /tmp/tre_log.log
u@unamed:~/prjs/OpenSPARCT1_model$ export TRE_LOG=/tmp/tre_log.log
u@unamed:~/prjs/OpenSPARCT1_model$ rsynp
rsynp -> perl_wrapper: configsrch returned error code 127 Exiting ...
u@unamed:~/prjs/OpenSPARCT1_model$ cat /tmp/tre_log.log
#
ERROR:             configsrch returned error code 127
DATE:              Sat 09 Apr 2022 10:54:21 PM EDT
WRAPPER:           /home/u/prjs/OpenSPARCT1/tools/bin/perl_wrapper
USER:              
HOST:              unamed
SYS:               Linux 5.13.0-39-generic
PWD:               /home/u/prjs/OpenSPARCT1_model
ARGV:              
TOOL:              rsynp
VERSION:           /home/u/prjs/OpenSPARCT1/tools/Linux/x86_64/configsrch: error while loading shared libraries: libstdc++.so.5: cannot open shared object file: No such file or directory
TRE_SEARCH:        /home/u/prjs/OpenSPARCT1/tools/env/tools.iver
TRE_ENTRY:         /
u@unamed:~/prjs/OpenSPARCT1_model$ sudo apt install libstdc++5:i386
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following packages were automatically installed and are no longer required:
  libfwupdplugin1 libllvm11 shim
Use 'sudo apt autoremove' to remove them.
The following NEW packages will be installed:
  libstdc++5:i386
0 upgraded, 1 newly installed, 0 to remove and 5 not upgraded.
Need to get 211 kB of archives.
After this operation, 1,068 kB of additional disk space will be used.
Get:1 http://us.archive.ubuntu.com/ubuntu focal/universe i386 libstdc++5 i386 1:3.3.6-30ubuntu2 [211 kB]
Fetched 211 kB in 3s (67.8 kB/s)          
Selecting previously unselected package libstdc++5:i386.
(Reading database ... 355752 files and directories currently installed.)
Preparing to unpack .../libstdc++5_1%3a3.3.6-30ubuntu2_i386.deb ...
Unpacking libstdc++5:i386 (1:3.3.6-30ubuntu2) ...
Setting up libstdc++5:i386 (1:3.3.6-30ubuntu2) ...
Processing triggers for libc-bin (2.31-0ubuntu9.7) ...
u@unamed:~/prjs/OpenSPARCT1_model$ sims -sim_type=ls -group=core1_mini
Unescaped left brace in regex is passed through in regex; marked by <-- HERE in m/\${ <-- HERE *(\w+)}*/ at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3979.
sims -sim_type=ls -group=core1_mini 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Sat 09 Apr 2022 11:23:30 PM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_09_0/tre/sims.iver
sims: Frozen tre_search /home/u/prjs/OpenSPARCT1/tools/env/tools.iver
sims: processing diaglist /home/u/prjs/OpenSPARCT1/verif/diag/master_diaglist () ..
sh: 1: bw_cpp: not found
sims: Caught a SIGDIE. Could not pre-process the master_diaglist at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 1182.
`````

接着处理这个错。

bw_cpp其实是这里的/home/u/prjs/OpenSPARCT1/tools/bin/bw_cpp，是个脚本。
bin目录也都加到PATH里了，出错的真正原因是这个脚本本身是csh脚本，而我电脑上没装csh。
所以可以装个csh的shell，在前面source OpenSPARCT1.cshrc。
或者把这个文件改成bash的语法。

`````bash
#!/bin/bash

if [[ "`uname -s`" == "SunOS" ]]; then
  if ( -f /usr/lib/cpp ) then
    /usr/lib/cpp $*
    exit
  fi
fi

# check cpp style
cpp -V < /dev/null >& /dev/null

# if GNU style, add traditional-cpp flag and remove -B flag

if [[ $status == 1 ]]; then
  cpp -E -traditional-cpp `/bin/echo $* | /bin/sed 's/-B/ /g' ` | \
  sed 's/\/\/.*//'
else
  cpp $*
fi

`````

--------------


下一个错误。
`````shell
u@unamed:~/prjs/OpenSPARCT1_model$ sims -sim_type=ls -group=core1_mini
Unescaped left brace in regex is passed through in regex; marked by <-- HERE in m/\${ <-- HERE *(\w+)}*/ at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3979.
sims -sim_type=ls -group=core1_mini 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Sun 10 Apr 2022 04:35:17 AM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_10_12/tre/sims.iver
sims: Frozen tre_search /home/u/prjs/OpenSPARCT1/tools/env/tools.iver
sims: processing diaglist /home/u/prjs/OpenSPARCT1/verif/diag/master_diaglist () ..
sims: processing group core1_mini
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
Unescaped left brace in regex is passed through in regex; marked by <-- HERE in m/\${ <-- HERE *(\w+)}*/ at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3979.
sims -nosimslog -sim_build -vera_build -sys=core1 -vcs_rel_name=core1_2022_04_10_3 -nosas -novcs_run 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Sun 10 Apr 2022 04:35:19 AM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_10_12/tre/sims.iver
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
sims: using random seed 1110687129
sims: creating model directory /home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_3
sims: building vera model
sims: vera_start Sun 10 Apr 2022 04:35:19 AM EDT
sims: building vera model in /home/u/prjs/OpenSPARCT1/verif/env/cmp/vera
sims: setenv VERA_LIBDIR /home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_3/vera
sims: gmake p=4 VERA_LIBDIR=/home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_3/vera
/home/u/prjs/OpenSPARCT1/tools/Linux/x86_64/gmake,1.0: 3: /usr/bin/gmake: not found
sims: Caught a SIGDIE. failed making vera testbench in /home/u/prjs/OpenSPARCT1/verif/env/cmp/vera at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 1780.

sims: Caught a SIGDIE. Could not build model for regression at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 1272.
`````

没有gmake，这样就可以了。

`````shell
sudo ln -s /usr/bin/make  /usr/bin/gmake
`````

前面我还忘了这个：

`````shell
% cd $DV_ROOT/tools/env
% ln -s Makefile.Linux.x86_64 Makefile.system
`````

--------------

`````shell
u@unamed:~/prjs/OpenSPARCT1_model$ sims -sim_type=ls -group=core1_mini
Unescaped left brace in regex is passed through in regex; marked by <-- HERE in m/\${ <-- HERE *(\w+)}*/ at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3979.
sims -sim_type=ls -group=core1_mini 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Sun 10 Apr 2022 04:36:46 AM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_10_13/tre/sims.iver
sims: Frozen tre_search /home/u/prjs/OpenSPARCT1/tools/env/tools.iver
sims: processing diaglist /home/u/prjs/OpenSPARCT1/verif/diag/master_diaglist () ..
sims: processing group core1_mini
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
Unescaped left brace in regex is passed through in regex; marked by <-- HERE in m/\${ <-- HERE *(\w+)}*/ at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3979.
sims -nosimslog -sim_build -vera_build -sys=core1 -vcs_rel_name=core1_2022_04_10_4 -nosas -novcs_run 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Sun 10 Apr 2022 04:36:48 AM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_10_13/tre/sims.iver
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
sims: using random seed 1635829362
sims: creating model directory /home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_4
sims: building vera model
sims: vera_start Sun 10 Apr 2022 04:36:48 AM EDT
sims: building vera model in /home/u/prjs/OpenSPARCT1/verif/env/cmp/vera
sims: setenv VERA_LIBDIR /home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_4/vera
sims: gmake p=4 VERA_LIBDIR=/home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_4/vera
generating /home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_4/vera/iop_rtl.h from /home/u/prjs/OpenSPARCT1/design/sys/iop/include/iop.h
generating /home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_4/vera/sys_rtl.h from /home/u/prjs/OpenSPARCT1/design/sys/iop/include/sys.h
Copying include/cpxorder_ports_binds.vrh
Copying include/l2jbi_ports_binds.vrh
Copying include/l2order_ports_binds.vrh
Copying include/cmp_ports_binds.vrh
Copying include/l2jbi.vcon
Copying include/cpxorder.vcon
Copying include/cmp_top.vcon
Copying include/ucb.vcon
Copying include/l2order.vcon
Copying include/sparc.vcon
Copying include/l2jbi.if.vrh
Copying include/cpxorder.if.vrh
Copying include/cmp_top.if.vrh
Copying include/l2order.if.vrh
Copying include/cmp_defines.vri
Copying include/diag.vri
Copying cpx_record.vr
Vera: generating headers for cpx_record.vr
vera -cmp -I . -max_error 5 -q -H cpx_record.vr cpx_record
/bin/sh: 1: vera: not found
gmake: *** [Makefile:206: /home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_4/vera/cpx_record.vrh] Error 127
sims: Caught a SIGDIE. failed making vera testbench in /home/u/prjs/OpenSPARCT1/verif/env/cmp/vera at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 1780.

sims: Caught a SIGDIE. Could not build model for regression at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 1272.

`````

我没有vera，这个很老了，是synopsys收购的，现在这个语言的一部分已经成了systemverilog。
> By default, the simulations are run with Vera. If you do not want to use Vera, add following option to the sims command:
> `-novera_build -novera_run`



`````shell
u@unamed:~/prjs/OpenSPARCT1_model$ sims -sim_type=vsim -group=core1_mini -novera_build -novera_run
Unescaped left brace in regex is passed through in regex; marked by <-- HERE in m/\${ <-- HERE *(\w+)}*/ at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3979.
sims -sim_type=vsim -group=core1_mini -novera_build -novera_run 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Sun 10 Apr 2022 09:43:20 PM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_10_16/tre/sims.iver
sims: Frozen tre_search /home/u/prjs/OpenSPARCT1/tools/env/tools.iver
sims: processing diaglist /home/u/prjs/OpenSPARCT1/verif/diag/master_diaglist () ..
sims: processing group core1_mini
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
Unescaped left brace in regex is passed through in regex; marked by <-- HERE in m/\${ <-- HERE *(\w+)}*/ at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3979.
sims -nosimslog -sim_build -novera_build -sys=core1 -vcs_rel_name=core1_2022_04_10_7 -novera_run -nosas -novcs_run 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Sun 10 Apr 2022 09:43:22 PM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_10_16/tre/sims.iver
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
sims: using random seed 3864168019
sims: creating model directory /home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_7
sims: setenv VERA_LIBDIR /home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_7/vera
sims: LM_LICENSE_FILE : /import/EDAtools/licenses/synopsys_key:/import/EDAtools/licenses/ncverilog_key
sims: NOVAS_HOME not defined, Debussy will not be used.
sims: Building rtl model
sims: Caught a SIGDIE. sim_build_cmd not defined at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 2252.

sims: Caught a SIGDIE. Could not build model for regression at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 1272.
`````

命令行里我随便填的-sim_type=vsim，所以是sim_build_cmd not defined。要是填-sim_type=vcs，那脚本就会去找是不是装了vcs。
`````shell
sims: Caught a SIGDIE. VCS_HOME not defined. at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 1889.
`````

> 3.2.3
> Running Regression With Other Simulators
> To use a Verilog simulator other than VCS or NCVerilog, use following options for
> the sims command:
> -sim_type=”Your simulator name”
> -sim_build_cmd=”Your simulator command to build/compile RTL”
> -sim_run_cmd=”Your simulator command to run simulations”
> -sim_build_args=”Arguments to build/compile”
> -sim_run_args=”Arguments to run simulations”
> You only need to specify the sim_type, sim_build_cmd, and sim_run_cmd
> options once. You can specify sim_build_args and sim_run_args multiple times
> to specify multiple argument options.


先用vlib创建work library，然后在vlog的参数里指定work。vlog是用来build/compile verilog的。
`````shell
u@unamed:~/prjs/OpenSPARCT1_model$ vlib work
u@unamed:~/prjs/OpenSPARCT1_model$ sims -sim_type=vlog -sim_build_cmd=vlog -sim_build_args="-work ~/prjs/OpenSPARCT1_model/work" -group=core1_mini -novera_build -novera_run
`````

还真的开始编译了，后面出现了新的错误。
`````shell
u@unamed:~/prjs/OpenSPARCT1_model$ sims -sim_type=vlog -sim_build_cmd=vlog -sim_build_args="-work ~/prjs/OpenSPARCT1_model/work" -group=core1_mini -novera_build -novera_run
Unescaped left brace in regex is passed through in regex; marked by <-- HERE in m/\${ <-- HERE *(\w+)}*/ at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3979.
sims -sim_type=vlog -sim_build_cmd=vlog -sim_build_args="-work ~/prjs/OpenSPARCT1_model/work" -group=core1_mini -novera_build -novera_run 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Sun 10 Apr 2022 11:46:30 PM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_10_24/tre/sims.iver
sims: Frozen tre_search /home/u/prjs/OpenSPARCT1/tools/env/tools.iver
sims: processing diaglist /home/u/prjs/OpenSPARCT1/verif/diag/master_diaglist () ..
sims: processing group core1_mini
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
Unescaped left brace in regex is passed through in regex; marked by <-- HERE in m/\${ <-- HERE *(\w+)}*/ at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3979.
sims -nosimslog -sim_build -novera_build -sys=core1 -vcs_rel_name=core1_2022_04_10_15 -sim_build_cmd=vlog -sim_build_args="-work ~/prjs/OpenSPARCT1_model/work" -novera_run -nosas -novcs_run 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Sun 10 Apr 2022 11:46:32 PM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_10_24/tre/sims.iver
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
sims: using random seed 2841798902
sims: creating model directory /home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_15
sims: setenv VERA_LIBDIR /home/u/prjs/OpenSPARCT1_model/core1/core1_2022_04_10_15/vera
sims: LM_LICENSE_FILE : /import/EDAtools/licenses/synopsys_key:/import/EDAtools/licenses/ncverilog_key
sims: NOVAS_HOME not defined, Debussy will not be used.
sims: Building rtl model
sims: vlog -work ~/prjs/OpenSPARCT1_model/work -f flist 
Model Technology ModelSim ALTERA vlog 10.1d Compiler 2012.11 Nov  2 2012
-- Compiling module jbus_monitor
-- Compiling module jp_sjm
-- Compiling module cmp_top
-- Compiling module pad_efc
-- Compiling module efc
-- Compiling module efc_stdc
-- Compiling module efc_saed
-- Compiling module efc_tck
-- Compiling module bw_r_efa
-- Compiling module bw_clk_cl_efc_jbus
-- Compiling module bw_ctu_pad_cluster
-- Compiling module ctu_clsp_clkgn_1div
-- Compiling module ctu_clsp_clkgn_syncp
-- Compiling module ctu_clsp_clkgn_shadreg
-- Compiling module ctu_clsp_clkgn_ddiv
-- Compiling module ctu_clsp_clkgn_fstlog
-- Compiling module ctu_clsp_clkgn_clksel
-- Compiling module ctu_clsp_clkgn_clksw
-- Compiling module ctu_clsp_clkgn_nstep_cnt
-- Compiling module ctu_clsp_clkgn_nstep
-- Compiling module ctu_clsp_clkgn_ssiclk
-- Compiling module ctu_clsp_clkgn
-- Compiling module ctu_clsp_dramgif
-- Compiling module ctu_clsp_jbusgif
-- Compiling module ctu_clsp_cmpgif
-- Compiling module ctu_clsp_creg
-- Compiling module ctu_clsp_clkctrl
-- Compiling module ctu_clsp_ctrl
-- Compiling module ctu_clsp_pllcnt
-- Compiling module ctu_clsp_synch_cljl
-- Compiling module ctu_clsp_synch_jlcl
-- Compiling module ctu_clsp_synch_jldl
-- Compiling module ctu_clsp_synch_dldg
-- Compiling module ctu_clsp
-- Compiling module ctu_dft_jtag_tap
-- Compiling module ctu_dft_jtag
-- Compiling module ctu_dft_bist
-- Compiling module ctu_dft_creg
-- Compiling module ctu_dft
-- Compiling module ctu_test_stub_scan
-- Compiling module ctu_revision
-- Compiling module ctu_mask_id
-- Compiling module ctu_jtag_id
-- Compiling module ctu
-- Compiling module ctu_sync_pulse_check
-- Compiling module bw_clk_cl_ctu_jbus
-- Compiling module bw_clk_cl_ctu_cmp
-- Compiling module bw_ctu_clk_sync_mux_1path
-- Compiling module bw_ctu_clk_sync_mux
-- Compiling module bw_clk_cl_ctu_2xcmp
-- Compiling module bw_clk_cl_ctu_2xcmp_b
-- Compiling module ctu_sync_header
-- Compiling module bw_zzctu_sync
-- Compiling module bw_rng
-- Compiling module bw_pll
-- Compiling module bw_tsr
-- Compiling module pad_misc
-- Compiling module bw_io_misc_chunk1
-- Compiling module bw_io_misc_chunk2
-- Compiling module bw_io_misc_chunk3
-- Compiling module bw_io_misc_chunk5
-- Compiling module bw_io_misc_chunk6
-- Compiling module bw_clk_cl_misc_jbus
-- Compiling module bw_io_schmitt
-- Compiling module bw_io_hstl_pad
-- Compiling module bw_io_cmos_pad
-- Compiling module bw_io_cmos2_pad
-- Compiling module bw_io_hstl_edgelogic
-- Compiling module bw_io_cmos_edgelogic
-- Compiling module bw_io_hstl_drv
-- Compiling module bw_io_misc_rpt
-- Compiling module bw_io_cmos2_pad_up
-- Compiling module bw_io_cmos2_term_up
-- Compiling module bw_io_cmos2_pad_dn
-- Compiling module bw_io_cmos2_term_dn
-- Compiling module bw_io_dtlhstl_rcv
-- Compiling module bw_io_dq_pscan
-- Compiling module bw_io_jp_bs_baseblk
-- Compiling module bw_io_jp_sstl_bscan
-- Compiling module bw_io_jp_sstl_dq_bscan
-- Compiling module bw_io_jp_sstl_oebscan
-- Compiling module bw_io_sstl_bscan

...


/bin/rmdir: failed to remove '/var/tmp/u:mt_dcache_falseraw:model_core1:core1_mini:0:28099': No such file or directory
sims: mt_alu_ldx:model_core1:core1_mini:0
Unescaped left brace in regex is passed through in regex; marked by <-- HERE in m/\${ <-- HERE *(\w+)}*/ at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3979.
sims -sim_run -sys=core1 -vcs_rel_name=core1_2022_04_10_15 -regress_id=2022_04_10_24 -alias=mt_alu_ldx:model_core1:core1_mini:0 -dv_root=/home/u/prjs/OpenSPARCT1 -model_dir=/home/u/prjs/OpenSPARCT1_model -result_dir=/home/u/prjs/OpenSPARCT1_model -sims_config=/home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config -group_name=core1_mini -regress_date=2022_04_10 -regress_time=23_46_30 -sas -sas -rtl_timeout=50000 -max_cycle=300000 -finish_mask=7 mt_alu_ldx.s -sim_build_cmd=vlog -sim_build_args="-work ~/prjs/OpenSPARCT1_model/work" -novera_run -nobuild -regress -nosas -nouse_oolm 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Sun 10 Apr 2022 11:47:05 PM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_10_24/tre/sims.iver
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
sims: using random seed 108972634
sims: group_name = core1_mini
sims: regress_date = 2022_04_10
sims: regress_time = 23_46_30
sims: locating diag mt_alu_ldx.s
sims: Looking for diag under $DV_ROOT/verif/diag
sims: Found diag under /home/u/prjs/OpenSPARCT1/verif/diag/assembly/arch/mt/generated/mt_alu_ldx.s
sims: assembling diag
sims: midas -mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
/usr/bin/perl: symbol lookup error: /home/u/prjs/OpenSPARCT1/tools/perlmod/Linux-x86_64/auto/Bit/Vector/Vector.so: undefined symbol: Perl_Gthr_key_ptr
sims: Caught a SIGDIE. midas compilation error at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 4089.

/bin/rmdir: failed to remove '/var/tmp/u:mt_alu_ldx:model_core1:core1_mini:0:28206': No such file or directory
sims: mtblkldst_loop:model_core1:core1_mini:0
Unescaped left brace in regex is passed through in regex; marked by <-- HERE in m/\${ <-- HERE *(\w+)}*/ at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3979.
sims -sim_run -sys=core1 -vcs_rel_name=core1_2022_04_10_15 -regress_id=2022_04_10_24 -alias=mtblkldst_loop:model_core1:core1_mini:0 -dv_root=/home/u/prjs/OpenSPARCT1 -model_dir=/home/u/prjs/OpenSPARCT1_model -result_dir=/home/u/prjs/OpenSPARCT1_model -sims_config=/home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config -group_name=core1_mini -regress_date=2022_04_10 -regress_time=23_46_30 -sas -sas -sim_run_args=+spc_pipe=0 -finish_mask=f mtblkldst_loop.s -sim_build_cmd=vlog -sim_build_args="-work ~/prjs/OpenSPARCT1_model/work" -novera_run -nobuild -regress -nosas -nouse_oolm 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Sun 10 Apr 2022 11:47:06 PM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_10_24/tre/sims.iver
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
sims: using random seed 283903339
sims: group_name = core1_mini
sims: regress_date = 2022_04_10
sims: regress_time = 23_46_30
sims: locating diag mtblkldst_loop.s
sims: Looking for diag under $DV_ROOT/verif/diag
sims: Found diag under /home/u/prjs/OpenSPARCT1/verif/diag/assembly/arch/mt/mtblkldst_loop.s
sims: assembling diag
sims: midas -mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
/usr/bin/perl: symbol lookup error: /home/u/prjs/OpenSPARCT1/tools/perlmod/Linux-x86_64/auto/Bit/Vector/Vector.so: undefined symbol: Perl_Gthr_key_ptr
sims: Caught a SIGDIE. midas compilation error at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 4089.

/bin/rmdir: failed to remove '/var/tmp/u:mtblkldst_loop:model_core1:core1_mini:0:28313': No such file or directory
sims: stop_time Sun 10 Apr 2022 11:47:06 PM EDT
`````

后面的midas编译错。

midas也是OpenSPARCT1/tools/bin/里面的一个脚本，单独运行midas也会出现相同的错误，就是Perl_Gthr_key_ptr函数没有。
搜了以后，开始以为是perl的版本不对，Vertor.so里面搜字串，看到编译时用的是perl 5.8.0，而我系统上装的是5.30.0。
所以用perlbrew下载安装不同版本的perl。
装perlbrew用下面这个：

`````shell
$ curl -L https://install.perlbrew.pl | bash
`````

> \# Initialize
> perlbrew init
>  
> \# See what is available
> perlbrew available
>  
> \# Install some Perls
> perlbrew install 5.18.2
> perlbrew install perl-5.8.1
> perlbrew install perl-5.19.9
>  
> \# See what were installed
> perlbrew list
>  
> \# Swith to an installation and set it as default
> perlbrew switch perl-5.18.2
>  
> \# Temporarily use another version only in current shell.
> perlbrew use perl-5.8.1
> perl -v
>  
> \# Or turn it off completely. Useful when you messed up too deep.
> \# Or want to go back to the system Perl.
> perlbrew off
>  
> \# Use 'switch' command to turn it back on.
> perlbrew switch perl-5.12.2
>  
> \# Exec something with all perlbrew-ed perls
> perlbrew exec -- perl -E 'say $]'

用perlbrew available看支持哪些版本，看到有5.8.9，就装这个。
`````shell
$ perlbrew install perl-5.8.9
`````
但发现还是不行，同样的错误，我也试了5.8.0，甚至还试了32bit的perl，都不行。

在64位机器上装32bit perl的参数也放在这。
`````shell
$ perlbrew install 5.8.9 -Accflags="-m32 -march=i686" -Aldflags="-m32 -march=i686" -Alddlflags="-shared -m32 -march=i686"
`````

后来搜到，是因为perl支不支持thread的原因，所以编译的时候带thread。
`````shell
$ perlbrew install perl-5.8.9 -Dusethreads
`````
装完以后还要改这个变量。
`````shell
u@unamed:~/prjs/OpenSPARCT1_model$ export PERL_CMD=/home/u/perl5/perlbrew/perls/perl-5.8.9/bin/perl
`````
这样这个bug就过去了，接着就是新问题。


---------------------

`````shell
sims -sim_run -sys=core1 -vcs_rel_name=core1_2022_04_11_4 -regress_id=2022_04_11_4 -alias=mt_alu_ldx:model_core1:core1_mini:0 -dv_root=/home/u/prjs/OpenSPARCT1 -model_dir=/home/u/prjs/OpenSPARCT1_model -result_dir=/home/u/prjs/OpenSPARCT1_model -sims_config=/home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config -group_name=core1_mini -regress_date=2022_04_11 -regress_time=10_58_36 -sas -sas -rtl_timeout=50000 -max_cycle=300000 -finish_mask=7 mt_alu_ldx.s -sim_build_cmd=vlog -sim_build_args="-work ~/prjs/OpenSPARCT1_model/work" -novera_run -nobuild -regress -nosas -nouse_oolm 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Mon 11 Apr 2022 10:59:15 AM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_11_4/tre/sims.iver
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
sims: using random seed 2456996947
sims: group_name = core1_mini
sims: regress_date = 2022_04_11
sims: regress_time = 10_58_36
sims: locating diag mt_alu_ldx.s
sims: Looking for diag under $DV_ROOT/verif/diag
sims: Found diag under /home/u/prjs/OpenSPARCT1/verif/diag/assembly/arch/mt/generated/mt_alu_ldx.s
sims: assembling diag
sims: midas -mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/lib/site_perl/5.8.0
/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/bin/midas
/home/u/perl5/perlbrew/perls/perl-5.8.9/bin/perl
-mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
midas: init_config, project is OpenSPARCT1.
midas: Setting project defaults for project 'OpenSPARCT1'.
midas: midas -mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
midas: Running from /home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/bin/midas
midas: ###########################################################
midas: ##  SETUP PHASE
midas: ###########################################################
midas: ### Will build in directory "/var/tmp/u:mt_alu_ldx:model_core1:core1_mini:0:273151/build"
midas: mkdir /var/tmp/u:mt_alu_ldx:model_core1:core1_mini:0:273151/build
midas: cp diag.s build/diag.src
midas: cd build
midas: Splitting diag.src into diag.s and diag.pl (if necessary).
midas: ###########################################################
midas: ##  PREPROCESSING PHASE
midas: ###########################################################
midas: bw_cpp -B -P -I. -I.. -I/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include -DGOLDFINGER=1 -DMIDAS_VERSION=3.30 -DMIDAS_MAJOR_VERS=3 -DMIDAS_MINOR_VERS=30 -DSUN4V=1 -DNIAGARA diag.s > diag.cpp
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:31,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/xlate.h:947:8: warning: extra tokens at end of #endif directive [-Wendif-labels]
  947 | #endif */ __XLATE_H__ */
      |        ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:165,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot_dramctl_init.s:56: warning: "CAS_LATENCY" redefined
   56 | #define CAS_LATENCY  0x3
      | 
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot_dramctl_init.s:34: note: this is the location of the previous definition
   34 | #define CAS_LATENCY 3
      | 
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:860:30: warning: extra tokens at end of #ifndef directive
  860 | #ifndef USER_PAGE_CUSTOM_MAP !added as per the request of "Bob Rethemeyer" to support MBLIMP on 06/24/04
      |                              ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:1015:8: warning: extra tokens at end of #endif directive [-Wendif-labels]
 1015 | #endif ! ifdef USE_STACK
      |        ^
midas: bw_m4  --include=. --include=.. < diag.cpp > diag.m4
/home/u/prjs/OpenSPARCT1/tools/Linux/x86_64/m4_gmp: error while loading shared libraries: libgmp.so.3: cannot open shared object file: No such file or directory
midas: At pkg=Midas::Interface, file=/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/lib/site_perl/5.8.0/Midas/Interface.pm, line=368
midas: FATAL ERROR: M_M4FAIL (#20): M4 preprocessor failed.
midas: FATAL ERROR: Command "bw_m4  --include=. --include=.. < diag.cpp > diag.m4" failed with status 127. 
sims: Caught a SIGDIE. midas compilation error at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 4089.

/bin/rmdir: failed to remove '/var/tmp/u:mt_alu_ldx:model_core1:core1_mini:0:273151': No such file or directory
sims: mtblkldst_loop:model_core1:core1_mini:0
sims -sim_run -sys=core1 -vcs_rel_name=core1_2022_04_11_4 -regress_id=2022_04_11_4 -alias=mtblkldst_loop:model_core1:core1_mini:0 -dv_root=/home/u/prjs/OpenSPARCT1 -model_dir=/home/u/prjs/OpenSPARCT1_model -result_dir=/home/u/prjs/OpenSPARCT1_model -sims_config=/home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config -group_name=core1_mini -regress_date=2022_04_11 -regress_time=10_58_36 -sas -sas -sim_run_args=+spc_pipe=0 -finish_mask=f mtblkldst_loop.s -sim_build_cmd=vlog -sim_build_args="-work ~/prjs/OpenSPARCT1_model/work" -novera_run -nobuild -regress -nosas -nouse_oolm 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Mon 11 Apr 2022 10:59:15 AM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_11_4/tre/sims.iver
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
sims: using random seed 907444985
sims: group_name = core1_mini
sims: regress_date = 2022_04_11
sims: regress_time = 10_58_36
sims: locating diag mtblkldst_loop.s
sims: Looking for diag under $DV_ROOT/verif/diag
sims: Found diag under /home/u/prjs/OpenSPARCT1/verif/diag/assembly/arch/mt/mtblkldst_loop.s
sims: assembling diag
sims: midas -mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/lib/site_perl/5.8.0
/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/bin/midas
/home/u/perl5/perlbrew/perls/perl-5.8.9/bin/perl
-mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
midas: init_config, project is OpenSPARCT1.
midas: Setting project defaults for project 'OpenSPARCT1'.
midas: midas -mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
midas: Running from /home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/bin/midas
midas: ###########################################################
midas: ##  SETUP PHASE
midas: ###########################################################
midas: ### Will build in directory "/var/tmp/u:mtblkldst_loop:model_core1:core1_mini:0:273312/build"
midas: mkdir /var/tmp/u:mtblkldst_loop:model_core1:core1_mini:0:273312/build
midas: cp diag.s build/diag.src
midas: cd build
midas: Splitting diag.src into diag.s and diag.pl (if necessary).
midas: ###########################################################
midas: ##  PREPROCESSING PHASE
midas: ###########################################################
midas: bw_cpp -B -P -I. -I.. -I/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include -DGOLDFINGER=1 -DMIDAS_VERSION=3.30 -DMIDAS_MAJOR_VERS=3 -DMIDAS_MINOR_VERS=30 -DSUN4V=1 -DNIAGARA diag.s > diag.cpp
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:31,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:40:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/xlate.h:947:8: warning: extra tokens at end of #endif directive [-Wendif-labels]
  947 | #endif */ __XLATE_H__ */
      |        ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:165,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:40:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot_dramctl_init.s:56: warning: "CAS_LATENCY" redefined
   56 | #define CAS_LATENCY  0x3
      | 
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot_dramctl_init.s:34: note: this is the location of the previous definition
   34 | #define CAS_LATENCY 3
      | 
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:40:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:860:30: warning: extra tokens at end of #ifndef directive
  860 | #ifndef USER_PAGE_CUSTOM_MAP !added as per the request of "Bob Rethemeyer" to support MBLIMP on 06/24/04
      |                              ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:40:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:1015:8: warning: extra tokens at end of #endif directive [-Wendif-labels]
 1015 | #endif ! ifdef USE_STACK
      |        ^
midas: bw_m4  --include=. --include=.. < diag.cpp > diag.m4
/home/u/prjs/OpenSPARCT1/tools/Linux/x86_64/m4_gmp: error while loading shared libraries: libgmp.so.3: cannot open shared object file: No such file or directory
midas: At pkg=Midas::Interface, file=/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/lib/site_perl/5.8.0/Midas/Interface.pm, line=368
midas: FATAL ERROR: M_M4FAIL (#20): M4 preprocessor failed.
midas: FATAL ERROR: Command "bw_m4  --include=. --include=.. < diag.cpp > diag.m4" failed with status 127. 
sims: Caught a SIGDIE. midas compilation error at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 4089.

/bin/rmdir: failed to remove '/var/tmp/u:mtblkldst_loop:model_core1:core1_mini:0:273312': No such file or directory
sims: stop_time Mon 11 Apr 2022 10:59:16 AM EDT
`````

一堆warning，但有个问题就是libgmp.so.3没有找到。

这个版本太老了，deb都找不到，我系统上是libgmp.so.10，临时凑合下：

`````shell
$ sudo ln -s /lib/i386-linux-gnu/libgmp.so.10.4.0 /usr/lib/libgmp.so.3
`````

能凑合着跑，接下来又说找不到libelf.so.1，我系统上有64位的，但这里要32位的。

`````shell
$ sudo apt install libelf-dev:i386
`````

接下来还好像有进步了。前面还有出错，后面好像编译过了一些。


`````shell
midas: At pkg=Midas::Interface, file=/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/lib/site_perl/5.8.0/Midas/Interface.pm, line=368
midas: FATAL ERROR: M_ILLEGALPARAM (#9): Illegal parameter.
midas: FATAL ERROR: SECTION '.MAIN': No such attribute '#918"/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s"'
midas: FATAL ERROR:   At File=diag.m4, Line=14436
midas: Finding sections in diag.midas
midas: Processing directives in diag.midas
sims: Caught a SIGDIE. midas compilation error at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 4089.

/bin/rmdir: failed to remove '/var/tmp/u:mt_dhit_specload:model_core1:core1_mini:0:311706': No such file or directory
sims: mt_dcache_falseraw:model_core1:core1_mini:0
sims -sim_run -sys=core1 -vcs_rel_name=core1_2022_04_11_7 -regress_id=2022_04_11_7 -alias=mt_dcache_falseraw:model_core1:core1_mini:0 -dv_root=/home/u/prjs/OpenSPARCT1 -model_dir=/home/u/prjs/OpenSPARCT1_model -result_dir=/home/u/prjs/OpenSPARCT1_model -sims_config=/home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config -group_name=core1_mini -regress_date=2022_04_11 -regress_time=13_13_32 -sas -sas -finish_mask=f mt_Dcache_falseraw.s -sim_build_cmd=vlog -sim_build_args="-work ~/prjs/OpenSPARCT1_model/work" -novera_run -nobuild -regress -nosas -nouse_oolm 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Mon 11 Apr 2022 01:14:15 PM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_11_7/tre/sims.iver
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
sims: using random seed 3216166516
sims: group_name = core1_mini
sims: regress_date = 2022_04_11
sims: regress_time = 13_13_32
sims: locating diag mt_Dcache_falseraw.s
sims: Looking for diag under $DV_ROOT/verif/diag
sims: Found diag under /home/u/prjs/OpenSPARCT1/verif/diag/assembly/arch/mt/cache_buf/mt_Dcache_falseraw.s
sims: assembling diag
sims: midas -mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/lib/site_perl/5.8.0
/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/bin/midas
/home/u/perl5/perlbrew/perls/perl-5.8.9/bin/perl
-mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
midas: init_config, project is OpenSPARCT1.
midas: Setting project defaults for project 'OpenSPARCT1'.
midas: midas -mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
midas: Running from /home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/bin/midas
midas: ###########################################################
midas: ##  SETUP PHASE
midas: ###########################################################
midas: ### Will build in directory "/var/tmp/u:mt_dcache_falseraw:model_core1:core1_mini:0:311890/build"
midas: mkdir /var/tmp/u:mt_dcache_falseraw:model_core1:core1_mini:0:311890/build
midas: cp diag.s build/diag.src
midas: cd build
midas: Splitting diag.src into diag.s and diag.pl (if necessary).
midas: ###########################################################
midas: ##  PREPROCESSING PHASE
midas: ###########################################################
midas: bw_cpp -B -P -I. -I.. -I/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include -DGOLDFINGER=1 -DMIDAS_VERSION=3.30 -DMIDAS_MAJOR_VERS=3 -DMIDAS_MINOR_VERS=30 -DSUN4V=1 -DNIAGARA diag.s > diag.cpp
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:31,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:36:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/xlate.h:947:8: warning: extra tokens at end of #endif directive [-Wendif-labels]
  947 | #endif */ __XLATE_H__ */
      |        ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:165,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:36:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot_dramctl_init.s:56: warning: "CAS_LATENCY" redefined
   56 | #define CAS_LATENCY  0x3
      | 
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot_dramctl_init.s:34: note: this is the location of the previous definition
   34 | #define CAS_LATENCY 3
      | 
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:36:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:860:30: warning: extra tokens at end of #ifndef directive
  860 | #ifndef USER_PAGE_CUSTOM_MAP !added as per the request of "Bob Rethemeyer" to support MBLIMP on 06/24/04
      |                              ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:36:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:1015:8: warning: extra tokens at end of #endif directive [-Wendif-labels]
 1015 | #endif ! ifdef USE_STACK
      |        ^
midas: bw_m4  --include=. --include=.. < diag.cpp > diag.m4
midas: rm -f mem.image diag.ev symbol.tbl diag*.exe
midas: ###########################################################
midas: ##  SECTION PARSING PHASE
midas: ###########################################################
midas: goldfinger -v -splitsec diag.m4 -midasfile diag.midas -prefix 'midas: '
midas: goldfinger: Writing midas directives to diag.midas
midas: goldfinger: Writing section RED_SEC to sec0.red_sec.s
midas: goldfinger: Writing section RED_EXT_SEC to sec1.red_ext_sec.s
midas: goldfinger: Writing section HPRIV_RESET to sec2.hpriv_reset.s
midas: goldfinger: Writing section HTRAPS to sec3.htraps.s
midas: goldfinger: Writing section TRAPS to sec4.traps.s
midas: goldfinger: Writing section KERNEL to sec5.kernel.s
midas: goldfinger: Writing section USER_HEAP to sec6.user_heap.s
midas: goldfinger: Writing section MAIN to sec7.main.s
midas: At pkg=Midas::Interface, file=/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/lib/site_perl/5.8.0/Midas/Interface.pm, line=368
midas: FATAL ERROR: M_ILLEGALPARAM (#9): Illegal parameter.
midas: FATAL ERROR: SECTION '.MAIN': No such attribute '#918"/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s"'
midas: FATAL ERROR:   At File=diag.m4, Line=14450
midas: Finding sections in diag.midas
midas: Processing directives in diag.midas
sims: Caught a SIGDIE. midas compilation error at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 4089.

/bin/rmdir: failed to remove '/var/tmp/u:mt_dcache_falseraw:model_core1:core1_mini:0:311890': No such file or directory
sims: mt_alu_ldx:model_core1:core1_mini:0
sims -sim_run -sys=core1 -vcs_rel_name=core1_2022_04_11_7 -regress_id=2022_04_11_7 -alias=mt_alu_ldx:model_core1:core1_mini:0 -dv_root=/home/u/prjs/OpenSPARCT1 -model_dir=/home/u/prjs/OpenSPARCT1_model -result_dir=/home/u/prjs/OpenSPARCT1_model -sims_config=/home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config -group_name=core1_mini -regress_date=2022_04_11 -regress_time=13_13_32 -sas -sas -rtl_timeout=50000 -max_cycle=300000 -finish_mask=7 mt_alu_ldx.s -sim_build_cmd=vlog -sim_build_args="-work ~/prjs/OpenSPARCT1_model/work" -novera_run -nobuild -regress -nosas -nouse_oolm 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Mon 11 Apr 2022 01:14:15 PM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_11_7/tre/sims.iver
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
sims: using random seed 1026643392
sims: group_name = core1_mini
sims: regress_date = 2022_04_11
sims: regress_time = 13_13_32
sims: locating diag mt_alu_ldx.s
sims: Looking for diag under $DV_ROOT/verif/diag
sims: Found diag under /home/u/prjs/OpenSPARCT1/verif/diag/assembly/arch/mt/generated/mt_alu_ldx.s
sims: assembling diag
sims: midas -mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/lib/site_perl/5.8.0
/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/bin/midas
/home/u/perl5/perlbrew/perls/perl-5.8.9/bin/perl
-mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
midas: init_config, project is OpenSPARCT1.
midas: Setting project defaults for project 'OpenSPARCT1'.
midas: midas -mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
midas: Running from /home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/bin/midas
midas: ###########################################################
midas: ##  SETUP PHASE
midas: ###########################################################
midas: ### Will build in directory "/var/tmp/u:mt_alu_ldx:model_core1:core1_mini:0:312074/build"
midas: mkdir /var/tmp/u:mt_alu_ldx:model_core1:core1_mini:0:312074/build
midas: cp diag.s build/diag.src
midas: cd build
midas: Splitting diag.src into diag.s and diag.pl (if necessary).
midas: ###########################################################
midas: ##  PREPROCESSING PHASE
midas: ###########################################################
midas: bw_cpp -B -P -I. -I.. -I/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include -DGOLDFINGER=1 -DMIDAS_VERSION=3.30 -DMIDAS_MAJOR_VERS=3 -DMIDAS_MINOR_VERS=30 -DSUN4V=1 -DNIAGARA diag.s > diag.cpp
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:31,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/xlate.h:947:8: warning: extra tokens at end of #endif directive [-Wendif-labels]
  947 | #endif */ __XLATE_H__ */
      |        ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:165,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot_dramctl_init.s:56: warning: "CAS_LATENCY" redefined
   56 | #define CAS_LATENCY  0x3
      | 
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot_dramctl_init.s:34: note: this is the location of the previous definition
   34 | #define CAS_LATENCY 3
      | 
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:860:30: warning: extra tokens at end of #ifndef directive
  860 | #ifndef USER_PAGE_CUSTOM_MAP !added as per the request of "Bob Rethemeyer" to support MBLIMP on 06/24/04
      |                              ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:1015:8: warning: extra tokens at end of #endif directive [-Wendif-labels]
 1015 | #endif ! ifdef USE_STACK
      |        ^
midas: bw_m4  --include=. --include=.. < diag.cpp > diag.m4
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:26,
                 from <stdin>:31:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:450:25: warning: missing terminating ' character
  450 |   $1, 31, THR_31_PARTID)')
      |                         ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:510:18: warning: missing terminating ' character
  510 | define(ra2pa,``0x'mpeval($1 +
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:518:26: warning: missing terminating ' character
  518 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:531:26: warning: missing terminating ' character
  531 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:544:26: warning: missing terminating ' character
  544 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:548:18: warning: missing terminating ' character
  548 | define(pa2ra,``0x'mpeval($1 -
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:556:26: warning: missing terminating ' character
  556 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:569:26: warning: missing terminating ' character
  569 |   $2, 7, PART_7_BASE),16)')
      |                          ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/defines.h:26,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:27,
                 from <stdin>:31:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:96:37: warning: missing terminating ' character
   96 | ! ICACHE Diagnostic Access registers' field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:101:37: warning: missing terminating ' character
  101 | ! DCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:106:37: warning: missing terminating ' character
  106 | ! WCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:111:37: warning: missing terminating ' character
  111 | ! PCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:119:37: warning: missing terminating ' character
  119 | ! ECACHE Diagnostic Access registers' field definitions
      |                                     ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:28,
                 from <stdin>:31:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:89:81: warning: missing terminating ' character
   89 | dnl This macro enumerates from zero to the mask width.  It only expands the user's
      |                                                                                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:108:19: warning: missing terminating ' character
  108 |  ldx [[[%g2]]][[`,']] %g3   ! %g3 has coreavail
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:109:20: warning: missing terminating ' character
  109 |  rd      %asr26[[`,']] %l1
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:110:27: warning: missing terminating ' character
  110 |         set     0x1f00[[`,']] %g1
      |                           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:113:12: warning: missing terminating ' character
  113 |  mov 63[[`,']] %g1
      |            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:117:14: warning: missing terminating ' character
  117 |  brnz %g3[[`,']] skip_start_th
      |              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:129:11: warning: missing terminating ' character
  129 |  mov i[[`,']] %g1
      |           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:135:13: warning: missing terminating ' character
  135 |  stx %g1[[`,']] [[[%g3]]]  ! write to INT_VEC_DIS
      |             ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:141:40: warning: missing terminating ' character
  141 | define([th_expand], start_th_expand(`$1'))dnl
      |                                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:164:44: warning: missing terminating ' character
  164 | define([fork_expand], start_fork_expand(`$1'))dnl
      |                                            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:165:52: warning: missing terminating ' character
  165 | define([fork_expand_jmp], start_fork_expand_jmp(`$1'))dnl
      |                                                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:167:15: warning: missing terminating ' character
  167 | changequote(`,')dnl
      |               ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:172:22: warning: missing terminating ' character
  172 | define(`start_threads', th_expand(start_th))dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:178:21: warning: missing terminating ' character
  178 | define(`sync_threads', `
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:193:1: warning: missing terminating ' character
  193 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:204:1: warning: missing terminating ' character
  204 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:212:1: warning: missing terminating ' character
  212 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:217:1: warning: missing terminating ' character
  217 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:229:1: warning: missing terminating ' character
  229 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:237:1: warning: missing terminating ' character
  237 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:244:1: warning: missing terminating ' character
  244 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:259:1: warning: missing terminating ' character
  259 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:280:1: warning: missing terminating ' character
  280 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:297:1: warning: missing terminating ' character
  297 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:309:1: warning: missing terminating ' character
  309 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:315:1: warning: missing terminating ' character
  315 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:321:1: warning: missing terminating ' character
  321 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:328:1: warning: missing terminating ' character
  328 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:337:1: warning: missing terminating ' character
  337 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:345:1: warning: missing terminating ' character
  345 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:352:1: warning: missing terminating ' character
  352 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:358:1: warning: missing terminating ' character
  358 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:365:1: warning: missing terminating ' character
  365 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:371:1: warning: missing terminating ' character
  371 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:378:1: warning: missing terminating ' character
  378 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:386:1: warning: missing terminating ' character
  386 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:395:1: warning: missing terminating ' character
  395 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:397:22: warning: missing terminating ' character
  397 | define(make_reg, `%$1')dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:422:1: warning: missing terminating ' character
  422 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:446:1: warning: missing terminating ' character
  446 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:452:1: warning: missing terminating ' character
  452 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:458:1: warning: missing terminating ' character
  458 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:465:1: warning: missing terminating ' character
  465 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:469:20: warning: missing terminating ' character
  469 |  `define( `init_val', $1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:470:21: warning: missing terminating ' character
  470 |   define( `data_size', mpeval($3))
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:471:19: warning: missing terminating ' character
  471 |   define( `blk_len', mpeval($2))
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:472:20: warning: missing terminating ' character
  472 |   define( `it_count', 1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:473:19: warning: missing terminating ' character
  473 |   define( `sec_val', $5)
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:474:16: warning: missing terminating ' character
  474 |   define( `opr1', $4)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:475:16: warning: missing terminating ' character
  475 |   define( `opr2', $6)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:476:17: warning: missing terminating ' character
  476 |   define( `opnd3', $7)
      |                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:477:32: warning: missing terminating ' character
  477 |   ifelse(data_size,8,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:478:32: warning: missing terminating ' character
  478 |          data_size,4,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:479:39: warning: missing terminating ' character
  479 |                 data_size,2,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:480:39: warning: missing terminating ' character
  480 |                 data_size,1,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:484:32: warning: missing terminating ' character
  484 |  `ifelse(data_size,8,.xword `0x'mpeval(init_val opr1 sec_val,16,16),
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:485:24: warning: missing terminating ' character
  485 |   data_size,4,.word `0x'mpeval(init_val opr1 sec_val,16,8),
      |                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:486:38: warning: missing terminating ' character
  486 |                 data_size,2,.half `0x'mpeval(init_val opr1 sec_val,16,4),
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:487:38: warning: missing terminating ' character
  487 |                 data_size,1,.byte `0x'mpeval(init_val opr1 sec_val,16,2)) dnl
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:488:94: warning: missing terminating ' character
  488 |          ifelse(mpeval(len(opr1)>0),1,`define(`sec_val',`0x'mpeval(sec_val opr2 opnd3,16,16))') dnl
      |                                                                                              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:489:26: warning: missing terminating ' character
  489 |          define(`it_count', incr(it_count))
      |                          ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:26,
                 from <stdin>:34:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:450:25: warning: missing terminating ' character
  450 |   $1, 31, THR_31_PARTID)')
      |                         ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:510:18: warning: missing terminating ' character
  510 | define(ra2pa,``0x'mpeval($1 +
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:518:26: warning: missing terminating ' character
  518 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:531:26: warning: missing terminating ' character
  531 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:544:26: warning: missing terminating ' character
  544 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:548:18: warning: missing terminating ' character
  548 | define(pa2ra,``0x'mpeval($1 -
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:556:26: warning: missing terminating ' character
  556 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:569:26: warning: missing terminating ' character
  569 |   $2, 7, PART_7_BASE),16)')
      |                          ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/defines.h:26,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:27,
                 from <stdin>:34:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:96:37: warning: missing terminating ' character
   96 | ! ICACHE Diagnostic Access registers' field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:101:37: warning: missing terminating ' character
  101 | ! DCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:106:37: warning: missing terminating ' character
  106 | ! WCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:111:37: warning: missing terminating ' character
  111 | ! PCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:119:37: warning: missing terminating ' character
  119 | ! ECACHE Diagnostic Access registers' field definitions
      |                                     ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:28,
                 from <stdin>:34:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:89:81: warning: missing terminating ' character
   89 | dnl This macro enumerates from zero to the mask width.  It only expands the user's
      |                                                                                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:108:19: warning: missing terminating ' character
  108 |  ldx [[[%g2]]][[`,']] %g3   ! %g3 has coreavail
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:109:20: warning: missing terminating ' character
  109 |  rd      %asr26[[`,']] %l1
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:110:27: warning: missing terminating ' character
  110 |         set     0x1f00[[`,']] %g1
      |                           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:113:12: warning: missing terminating ' character
  113 |  mov 63[[`,']] %g1
      |            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:117:14: warning: missing terminating ' character
  117 |  brnz %g3[[`,']] skip_start_th
      |              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:129:11: warning: missing terminating ' character
  129 |  mov i[[`,']] %g1
      |           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:135:13: warning: missing terminating ' character
  135 |  stx %g1[[`,']] [[[%g3]]]  ! write to INT_VEC_DIS
      |             ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:141:40: warning: missing terminating ' character
  141 | define([th_expand], start_th_expand(`$1'))dnl
      |                                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:164:44: warning: missing terminating ' character
  164 | define([fork_expand], start_fork_expand(`$1'))dnl
      |                                            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:165:52: warning: missing terminating ' character
  165 | define([fork_expand_jmp], start_fork_expand_jmp(`$1'))dnl
      |                                                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:167:15: warning: missing terminating ' character
  167 | changequote(`,')dnl
      |               ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:172:22: warning: missing terminating ' character
  172 | define(`start_threads', th_expand(start_th))dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:178:21: warning: missing terminating ' character
  178 | define(`sync_threads', `
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:193:1: warning: missing terminating ' character
  193 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:204:1: warning: missing terminating ' character
  204 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:212:1: warning: missing terminating ' character
  212 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:217:1: warning: missing terminating ' character
  217 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:229:1: warning: missing terminating ' character
  229 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:237:1: warning: missing terminating ' character
  237 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:244:1: warning: missing terminating ' character
  244 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:259:1: warning: missing terminating ' character
  259 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:280:1: warning: missing terminating ' character
  280 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:297:1: warning: missing terminating ' character
  297 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:309:1: warning: missing terminating ' character
  309 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:315:1: warning: missing terminating ' character
  315 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:321:1: warning: missing terminating ' character
  321 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:328:1: warning: missing terminating ' character
  328 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:337:1: warning: missing terminating ' character
  337 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:345:1: warning: missing terminating ' character
  345 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:352:1: warning: missing terminating ' character
  352 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:358:1: warning: missing terminating ' character
  358 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:365:1: warning: missing terminating ' character
  365 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:371:1: warning: missing terminating ' character
  371 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:378:1: warning: missing terminating ' character
  378 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:386:1: warning: missing terminating ' character
  386 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:395:1: warning: missing terminating ' character
  395 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:397:22: warning: missing terminating ' character
  397 | define(make_reg, `%$1')dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:422:1: warning: missing terminating ' character
  422 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:446:1: warning: missing terminating ' character
  446 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:452:1: warning: missing terminating ' character
  452 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:458:1: warning: missing terminating ' character
  458 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:465:1: warning: missing terminating ' character
  465 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:469:20: warning: missing terminating ' character
  469 |  `define( `init_val', $1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:470:21: warning: missing terminating ' character
  470 |   define( `data_size', mpeval($3))
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:471:19: warning: missing terminating ' character
  471 |   define( `blk_len', mpeval($2))
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:472:20: warning: missing terminating ' character
  472 |   define( `it_count', 1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:473:19: warning: missing terminating ' character
  473 |   define( `sec_val', $5)
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:474:16: warning: missing terminating ' character
  474 |   define( `opr1', $4)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:475:16: warning: missing terminating ' character
  475 |   define( `opr2', $6)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:476:17: warning: missing terminating ' character
  476 |   define( `opnd3', $7)
      |                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:477:32: warning: missing terminating ' character
  477 |   ifelse(data_size,8,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:478:32: warning: missing terminating ' character
  478 |          data_size,4,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:479:39: warning: missing terminating ' character
  479 |                 data_size,2,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:480:39: warning: missing terminating ' character
  480 |                 data_size,1,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:484:32: warning: missing terminating ' character
  484 |  `ifelse(data_size,8,.xword `0x'mpeval(init_val opr1 sec_val,16,16),
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:485:24: warning: missing terminating ' character
  485 |   data_size,4,.word `0x'mpeval(init_val opr1 sec_val,16,8),
      |                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:486:38: warning: missing terminating ' character
  486 |                 data_size,2,.half `0x'mpeval(init_val opr1 sec_val,16,4),
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:487:38: warning: missing terminating ' character
  487 |                 data_size,1,.byte `0x'mpeval(init_val opr1 sec_val,16,2)) dnl
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:488:94: warning: missing terminating ' character
  488 |          ifelse(mpeval(len(opr1)>0),1,`define(`sec_val',`0x'mpeval(sec_val opr2 opnd3,16,16))') dnl
      |                                                                                              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:489:26: warning: missing terminating ' character
  489 |          define(`it_count', incr(it_count))
      |                          ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:26,
                 from <stdin>:35:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:450:25: warning: missing terminating ' character
  450 |   $1, 31, THR_31_PARTID)')
      |                         ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:510:18: warning: missing terminating ' character
  510 | define(ra2pa,``0x'mpeval($1 +
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:518:26: warning: missing terminating ' character
  518 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:531:26: warning: missing terminating ' character
  531 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:544:26: warning: missing terminating ' character
  544 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:548:18: warning: missing terminating ' character
  548 | define(pa2ra,``0x'mpeval($1 -
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:556:26: warning: missing terminating ' character
  556 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:569:26: warning: missing terminating ' character
  569 |   $2, 7, PART_7_BASE),16)')
      |                          ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/defines.h:26,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:27,
                 from <stdin>:35:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:96:37: warning: missing terminating ' character
   96 | ! ICACHE Diagnostic Access registers' field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:101:37: warning: missing terminating ' character
  101 | ! DCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:106:37: warning: missing terminating ' character
  106 | ! WCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:111:37: warning: missing terminating ' character
  111 | ! PCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:119:37: warning: missing terminating ' character
  119 | ! ECACHE Diagnostic Access registers' field definitions
      |                                     ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:28,
                 from <stdin>:35:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:89:81: warning: missing terminating ' character
   89 | dnl This macro enumerates from zero to the mask width.  It only expands the user's
      |                                                                                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:108:19: warning: missing terminating ' character
  108 |  ldx [[[%g2]]][[`,']] %g3   ! %g3 has coreavail
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:109:20: warning: missing terminating ' character
  109 |  rd      %asr26[[`,']] %l1
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:110:27: warning: missing terminating ' character
  110 |         set     0x1f00[[`,']] %g1
      |                           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:113:12: warning: missing terminating ' character
  113 |  mov 63[[`,']] %g1
      |            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:117:14: warning: missing terminating ' character
  117 |  brnz %g3[[`,']] skip_start_th
      |              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:129:11: warning: missing terminating ' character
  129 |  mov i[[`,']] %g1
      |           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:135:13: warning: missing terminating ' character
  135 |  stx %g1[[`,']] [[[%g3]]]  ! write to INT_VEC_DIS
      |             ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:141:40: warning: missing terminating ' character
  141 | define([th_expand], start_th_expand(`$1'))dnl
      |                                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:164:44: warning: missing terminating ' character
  164 | define([fork_expand], start_fork_expand(`$1'))dnl
      |                                            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:165:52: warning: missing terminating ' character
  165 | define([fork_expand_jmp], start_fork_expand_jmp(`$1'))dnl
      |                                                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:167:15: warning: missing terminating ' character
  167 | changequote(`,')dnl
      |               ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:172:22: warning: missing terminating ' character
  172 | define(`start_threads', th_expand(start_th))dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:178:21: warning: missing terminating ' character
  178 | define(`sync_threads', `
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:193:1: warning: missing terminating ' character
  193 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:204:1: warning: missing terminating ' character
  204 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:212:1: warning: missing terminating ' character
  212 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:217:1: warning: missing terminating ' character
  217 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:229:1: warning: missing terminating ' character
  229 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:237:1: warning: missing terminating ' character
  237 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:244:1: warning: missing terminating ' character
  244 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:259:1: warning: missing terminating ' character
  259 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:280:1: warning: missing terminating ' character
  280 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:297:1: warning: missing terminating ' character
  297 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:309:1: warning: missing terminating ' character
  309 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:315:1: warning: missing terminating ' character
  315 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:321:1: warning: missing terminating ' character
  321 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:328:1: warning: missing terminating ' character
  328 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:337:1: warning: missing terminating ' character
  337 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:345:1: warning: missing terminating ' character
  345 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:352:1: warning: missing terminating ' character
  352 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:358:1: warning: missing terminating ' character
  358 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:365:1: warning: missing terminating ' character
  365 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:371:1: warning: missing terminating ' character
  371 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:378:1: warning: missing terminating ' character
  378 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:386:1: warning: missing terminating ' character
  386 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:395:1: warning: missing terminating ' character
  395 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:397:22: warning: missing terminating ' character
  397 | define(make_reg, `%$1')dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:422:1: warning: missing terminating ' character
  422 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:446:1: warning: missing terminating ' character
  446 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:452:1: warning: missing terminating ' character
  452 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:458:1: warning: missing terminating ' character
  458 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:465:1: warning: missing terminating ' character
  465 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:469:20: warning: missing terminating ' character
  469 |  `define( `init_val', $1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:470:21: warning: missing terminating ' character
  470 |   define( `data_size', mpeval($3))
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:471:19: warning: missing terminating ' character
  471 |   define( `blk_len', mpeval($2))
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:472:20: warning: missing terminating ' character
  472 |   define( `it_count', 1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:473:19: warning: missing terminating ' character
  473 |   define( `sec_val', $5)
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:474:16: warning: missing terminating ' character
  474 |   define( `opr1', $4)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:475:16: warning: missing terminating ' character
  475 |   define( `opr2', $6)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:476:17: warning: missing terminating ' character
  476 |   define( `opnd3', $7)
      |                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:477:32: warning: missing terminating ' character
  477 |   ifelse(data_size,8,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:478:32: warning: missing terminating ' character
  478 |          data_size,4,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:479:39: warning: missing terminating ' character
  479 |                 data_size,2,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:480:39: warning: missing terminating ' character
  480 |                 data_size,1,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:484:32: warning: missing terminating ' character
  484 |  `ifelse(data_size,8,.xword `0x'mpeval(init_val opr1 sec_val,16,16),
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:485:24: warning: missing terminating ' character
  485 |   data_size,4,.word `0x'mpeval(init_val opr1 sec_val,16,8),
      |                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:486:38: warning: missing terminating ' character
  486 |                 data_size,2,.half `0x'mpeval(init_val opr1 sec_val,16,4),
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:487:38: warning: missing terminating ' character
  487 |                 data_size,1,.byte `0x'mpeval(init_val opr1 sec_val,16,2)) dnl
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:488:94: warning: missing terminating ' character
  488 |          ifelse(mpeval(len(opr1)>0),1,`define(`sec_val',`0x'mpeval(sec_val opr2 opnd3,16,16))') dnl
      |                                                                                              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:489:26: warning: missing terminating ' character
  489 |          define(`it_count', incr(it_count))
      |                          ^
midas: rm -f mem.image diag.ev symbol.tbl diag*.exe
midas: ###########################################################
midas: ##  SECTION PARSING PHASE
midas: ###########################################################
midas: goldfinger -v -splitsec diag.m4 -midasfile diag.midas -prefix 'midas: '
midas: goldfinger: Writing midas directives to diag.midas
midas: goldfinger: Writing section RED_SEC to sec0.red_sec.s
midas: goldfinger: Writing section RED_EXT_SEC to sec1.red_ext_sec.s
midas: goldfinger: Writing section HPRIV_RESET to sec2.hpriv_reset.s
midas: goldfinger: Writing section HTRAPS to sec3.htraps.s
midas: goldfinger: Writing section TRAPS to sec4.traps.s
midas: goldfinger: Writing section KERNEL to sec5.kernel.s
midas: goldfinger: Writing section USER_HEAP to sec6.user_heap.s
midas: goldfinger: Writing section MAIN to sec7.main.s
midas: goldfinger: Writing section MAIN_0 to sec8.main_0.s
midas: goldfinger: Writing section MAIN_1 to sec9.main_1.s
midas: goldfinger: Writing section MAIN_2 to sec10.main_2.s
midas: Finding sections in diag.midas
midas: Processing directives in diag.midas
midas: Performing sanity check on arguments.
midas: ###########################################################
midas: ##  ASSEMBLY PHASE
midas: ###########################################################
midas: Building 11 sections using 3 build threads.
midas: g_as -xarch=v9b sec1.red_ext_sec.s -o sec1.red_ext_sec.o
midas: g_as -xarch=v9b sec0.red_sec.s -o sec0.red_sec.o
midas: g_as -xarch=v9b sec2.hpriv_reset.s -o sec2.hpriv_reset.o
midas: g_as -xarch=v9b sec4.traps.s -o sec4.traps.o
midas: g_as -xarch=v9b sec3.htraps.s -o sec3.htraps.o
midas: g_as -xarch=v9b sec5.kernel.s -o sec5.kernel.o
midas: g_as -xarch=v9b sec8.main_0.s -o sec8.main_0.o
midas: g_as -xarch=v9b sec6.user_heap.s -o sec6.user_heap.o
midas: g_as -xarch=v9b sec7.main.s -o sec7.main.o
midas: g_as -xarch=v9b sec9.main_1.s -o sec9.main_1.o
midas: g_as -xarch=v9b sec10.main_2.s -o sec10.main_2.o
midas: ###########################################################
midas: ##  LINK PHASE
midas: ###########################################################
midas: Writing linker script diag.ld_scr.
midas: g_ld -b elf64-sparc -no-warn-mismatch --no-check-sections -T diag.ld_scr -o diag.exe
midas: diag.exe successfully created.
midas: ###########################################################
midas: ##  POSTPROCESSING PHASE
midas: ###########################################################
midas: Generating diag.goldfinger...
midas: goldfinger -v -in diag.goldfinger -gentsbs -genimage -imagefile mem.image -gensymtab -symtabfile symbol.tbl -prefix 'midas: '
midas: goldfinger: Opening file 'diag.goldfinger' for input.
midas: symbol.tbl successfully created.
midas: mem.image successfully created.
midas: Generating diag.ev...
midas: diag.ev successfully created.
midas: ###########################################################
midas: ##  COPY PHASE
midas: ###########################################################
midas: rm -f ../diag.s ../mem.image ../diag.ev ../symbol.tbl ../diag.exe ../diag.pl
midas: Hard linking diag.s to '..'.
midas: Hard linking mem.image to '..'.
midas: Hard linking diag.ev to '..'.
midas: Hard linking symbol.tbl to '..'.
midas: Hard linking diag.exe to '..'.
midas: cd ..
midas: ###########################################################
midas: ##  CLEANUP PHASE
midas: ###########################################################
midas: rm -rf build
sims: locating diag default.dat
sims: Looking for diag under $DV_ROOT/verif/diag
sims: Found diag under /home/u/prjs/OpenSPARCT1/verif/diag/efuse/default.dat
sims: Caught a SIGDIE. sim_run_cmd not defined at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3284.

/bin/rmdir: failed to remove '/var/tmp/u:mt_alu_ldx:model_core1:core1_mini:0:312074': No such file or directory
sims: mtblkldst_loop:model_core1:core1_mini:0
sims -sim_run -sys=core1 -vcs_rel_name=core1_2022_04_11_7 -regress_id=2022_04_11_7 -alias=mtblkldst_loop:model_core1:core1_mini:0 -dv_root=/home/u/prjs/OpenSPARCT1 -model_dir=/home/u/prjs/OpenSPARCT1_model -result_dir=/home/u/prjs/OpenSPARCT1_model -sims_config=/home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config -group_name=core1_mini -regress_date=2022_04_11 -regress_time=13_13_32 -sas -sas -sim_run_args=+spc_pipe=0 -finish_mask=f mtblkldst_loop.s -sim_build_cmd=vlog -sim_build_args="-work ~/prjs/OpenSPARCT1_model/work" -novera_run -nobuild -regress -nosas -nouse_oolm 
sims: ================================================
sims:   Simulation Script for OpenSPARC T1
sims:   Copyright (c) 2001-2006 Sun Microsystems, Inc.
sims:   All rights reserved.
sims: ================================================
sims: start_time Mon 11 Apr 2022 01:14:16 PM EDT
sims: running on unamed
sims: uname is Linux unamed 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
sims: version 1.262
sims: dv_root /home/u/prjs/OpenSPARCT1
sims: model_dir /home/u/prjs/OpenSPARCT1_model
sims: tre_search /home/u/prjs/OpenSPARCT1_model/2022_04_11_7/tre/sims.iver
sims: using config file /home/u/prjs/OpenSPARCT1/tools/src/sims/sims.config ()
sims: using random seed 1567029624
sims: group_name = core1_mini
sims: regress_date = 2022_04_11
sims: regress_time = 13_13_32
sims: locating diag mtblkldst_loop.s
sims: Looking for diag under $DV_ROOT/verif/diag
sims: Found diag under /home/u/prjs/OpenSPARCT1/verif/diag/assembly/arch/mt/mtblkldst_loop.s
sims: assembling diag
sims: midas -mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/lib/site_perl/5.8.0
/home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/bin/midas
/home/u/perl5/perlbrew/perls/perl-5.8.9/bin/perl
-mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
midas: init_config, project is OpenSPARCT1.
midas: Setting project defaults for project 'OpenSPARCT1'.
midas: midas -mmu=niagara -diag_root=/home/u/prjs/OpenSPARCT1 diag.s
midas: Running from /home/u/prjs/OpenSPARCT1/tools/perlmod/Midas/3.30/bin/midas
midas: ###########################################################
midas: ##  SETUP PHASE
midas: ###########################################################
midas: ### Will build in directory "/var/tmp/u:mtblkldst_loop:model_core1:core1_mini:0:312450/build"
midas: mkdir /var/tmp/u:mtblkldst_loop:model_core1:core1_mini:0:312450/build
midas: cp diag.s build/diag.src
midas: cd build
midas: Splitting diag.src into diag.s and diag.pl (if necessary).
midas: ###########################################################
midas: ##  PREPROCESSING PHASE
midas: ###########################################################
midas: bw_cpp -B -P -I. -I.. -I/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include -DGOLDFINGER=1 -DMIDAS_VERSION=3.30 -DMIDAS_MAJOR_VERS=3 -DMIDAS_MINOR_VERS=30 -DSUN4V=1 -DNIAGARA diag.s > diag.cpp
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:31,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:40:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/xlate.h:947:8: warning: extra tokens at end of #endif directive [-Wendif-labels]
  947 | #endif */ __XLATE_H__ */
      |        ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:165,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:40:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot_dramctl_init.s:56: warning: "CAS_LATENCY" redefined
   56 | #define CAS_LATENCY  0x3
      | 
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot_dramctl_init.s:34: note: this is the location of the previous definition
   34 | #define CAS_LATENCY 3
      | 
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:40:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:860:30: warning: extra tokens at end of #ifndef directive
  860 | #ifndef USER_PAGE_CUSTOM_MAP !added as per the request of "Bob Rethemeyer" to support MBLIMP on 06/24/04
      |                              ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/boot.s:27,
                 from diag.s:40:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/hboot.s:1015:8: warning: extra tokens at end of #endif directive [-Wendif-labels]
 1015 | #endif ! ifdef USE_STACK
      |        ^
midas: bw_m4  --include=. --include=.. < diag.cpp > diag.m4
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:26,
                 from <stdin>:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:450:25: warning: missing terminating ' character
  450 |   $1, 31, THR_31_PARTID)')
      |                         ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:510:18: warning: missing terminating ' character
  510 | define(ra2pa,``0x'mpeval($1 +
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:518:26: warning: missing terminating ' character
  518 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:531:26: warning: missing terminating ' character
  531 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:544:26: warning: missing terminating ' character
  544 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:548:18: warning: missing terminating ' character
  548 | define(pa2ra,``0x'mpeval($1 -
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:556:26: warning: missing terminating ' character
  556 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:569:26: warning: missing terminating ' character
  569 |   $2, 7, PART_7_BASE),16)')
      |                          ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/defines.h:26,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:27,
                 from <stdin>:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:96:37: warning: missing terminating ' character
   96 | ! ICACHE Diagnostic Access registers' field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:101:37: warning: missing terminating ' character
  101 | ! DCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:106:37: warning: missing terminating ' character
  106 | ! WCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:111:37: warning: missing terminating ' character
  111 | ! PCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:119:37: warning: missing terminating ' character
  119 | ! ECACHE Diagnostic Access registers' field definitions
      |                                     ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:28,
                 from <stdin>:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:89:81: warning: missing terminating ' character
   89 | dnl This macro enumerates from zero to the mask width.  It only expands the user's
      |                                                                                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:108:19: warning: missing terminating ' character
  108 |  ldx [[[%g2]]][[`,']] %g3   ! %g3 has coreavail
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:109:20: warning: missing terminating ' character
  109 |  rd      %asr26[[`,']] %l1
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:110:27: warning: missing terminating ' character
  110 |         set     0x1f00[[`,']] %g1
      |                           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:113:12: warning: missing terminating ' character
  113 |  mov 63[[`,']] %g1
      |            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:117:14: warning: missing terminating ' character
  117 |  brnz %g3[[`,']] skip_start_th
      |              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:129:11: warning: missing terminating ' character
  129 |  mov i[[`,']] %g1
      |           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:135:13: warning: missing terminating ' character
  135 |  stx %g1[[`,']] [[[%g3]]]  ! write to INT_VEC_DIS
      |             ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:141:40: warning: missing terminating ' character
  141 | define([th_expand], start_th_expand(`$1'))dnl
      |                                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:164:44: warning: missing terminating ' character
  164 | define([fork_expand], start_fork_expand(`$1'))dnl
      |                                            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:165:52: warning: missing terminating ' character
  165 | define([fork_expand_jmp], start_fork_expand_jmp(`$1'))dnl
      |                                                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:167:15: warning: missing terminating ' character
  167 | changequote(`,')dnl
      |               ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:172:22: warning: missing terminating ' character
  172 | define(`start_threads', th_expand(start_th))dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:178:21: warning: missing terminating ' character
  178 | define(`sync_threads', `
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:193:1: warning: missing terminating ' character
  193 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:204:1: warning: missing terminating ' character
  204 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:212:1: warning: missing terminating ' character
  212 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:217:1: warning: missing terminating ' character
  217 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:229:1: warning: missing terminating ' character
  229 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:237:1: warning: missing terminating ' character
  237 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:244:1: warning: missing terminating ' character
  244 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:259:1: warning: missing terminating ' character
  259 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:280:1: warning: missing terminating ' character
  280 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:297:1: warning: missing terminating ' character
  297 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:309:1: warning: missing terminating ' character
  309 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:315:1: warning: missing terminating ' character
  315 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:321:1: warning: missing terminating ' character
  321 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:328:1: warning: missing terminating ' character
  328 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:337:1: warning: missing terminating ' character
  337 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:345:1: warning: missing terminating ' character
  345 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:352:1: warning: missing terminating ' character
  352 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:358:1: warning: missing terminating ' character
  358 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:365:1: warning: missing terminating ' character
  365 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:371:1: warning: missing terminating ' character
  371 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:378:1: warning: missing terminating ' character
  378 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:386:1: warning: missing terminating ' character
  386 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:395:1: warning: missing terminating ' character
  395 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:397:22: warning: missing terminating ' character
  397 | define(make_reg, `%$1')dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:422:1: warning: missing terminating ' character
  422 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:446:1: warning: missing terminating ' character
  446 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:452:1: warning: missing terminating ' character
  452 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:458:1: warning: missing terminating ' character
  458 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:465:1: warning: missing terminating ' character
  465 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:469:20: warning: missing terminating ' character
  469 |  `define( `init_val', $1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:470:21: warning: missing terminating ' character
  470 |   define( `data_size', mpeval($3))
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:471:19: warning: missing terminating ' character
  471 |   define( `blk_len', mpeval($2))
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:472:20: warning: missing terminating ' character
  472 |   define( `it_count', 1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:473:19: warning: missing terminating ' character
  473 |   define( `sec_val', $5)
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:474:16: warning: missing terminating ' character
  474 |   define( `opr1', $4)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:475:16: warning: missing terminating ' character
  475 |   define( `opr2', $6)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:476:17: warning: missing terminating ' character
  476 |   define( `opnd3', $7)
      |                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:477:32: warning: missing terminating ' character
  477 |   ifelse(data_size,8,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:478:32: warning: missing terminating ' character
  478 |          data_size,4,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:479:39: warning: missing terminating ' character
  479 |                 data_size,2,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:480:39: warning: missing terminating ' character
  480 |                 data_size,1,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:484:32: warning: missing terminating ' character
  484 |  `ifelse(data_size,8,.xword `0x'mpeval(init_val opr1 sec_val,16,16),
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:485:24: warning: missing terminating ' character
  485 |   data_size,4,.word `0x'mpeval(init_val opr1 sec_val,16,8),
      |                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:486:38: warning: missing terminating ' character
  486 |                 data_size,2,.half `0x'mpeval(init_val opr1 sec_val,16,4),
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:487:38: warning: missing terminating ' character
  487 |                 data_size,1,.byte `0x'mpeval(init_val opr1 sec_val,16,2)) dnl
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:488:94: warning: missing terminating ' character
  488 |          ifelse(mpeval(len(opr1)>0),1,`define(`sec_val',`0x'mpeval(sec_val opr2 opnd3,16,16))') dnl
      |                                                                                              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:489:26: warning: missing terminating ' character
  489 |          define(`it_count', incr(it_count))
      |                          ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:26,
                 from <stdin>:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:450:25: warning: missing terminating ' character
  450 |   $1, 31, THR_31_PARTID)')
      |                         ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:510:18: warning: missing terminating ' character
  510 | define(ra2pa,``0x'mpeval($1 +
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:518:26: warning: missing terminating ' character
  518 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:531:26: warning: missing terminating ' character
  531 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:544:26: warning: missing terminating ' character
  544 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:548:18: warning: missing terminating ' character
  548 | define(pa2ra,``0x'mpeval($1 -
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:556:26: warning: missing terminating ' character
  556 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:569:26: warning: missing terminating ' character
  569 |   $2, 7, PART_7_BASE),16)')
      |                          ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/defines.h:26,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:27,
                 from <stdin>:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:96:37: warning: missing terminating ' character
   96 | ! ICACHE Diagnostic Access registers' field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:101:37: warning: missing terminating ' character
  101 | ! DCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:106:37: warning: missing terminating ' character
  106 | ! WCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:111:37: warning: missing terminating ' character
  111 | ! PCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:119:37: warning: missing terminating ' character
  119 | ! ECACHE Diagnostic Access registers' field definitions
      |                                     ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:28,
                 from <stdin>:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:89:81: warning: missing terminating ' character
   89 | dnl This macro enumerates from zero to the mask width.  It only expands the user's
      |                                                                                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:108:19: warning: missing terminating ' character
  108 |  ldx [[[%g2]]][[`,']] %g3   ! %g3 has coreavail
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:109:20: warning: missing terminating ' character
  109 |  rd      %asr26[[`,']] %l1
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:110:27: warning: missing terminating ' character
  110 |         set     0x1f00[[`,']] %g1
      |                           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:113:12: warning: missing terminating ' character
  113 |  mov 63[[`,']] %g1
      |            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:117:14: warning: missing terminating ' character
  117 |  brnz %g3[[`,']] skip_start_th
      |              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:129:11: warning: missing terminating ' character
  129 |  mov i[[`,']] %g1
      |           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:135:13: warning: missing terminating ' character
  135 |  stx %g1[[`,']] [[[%g3]]]  ! write to INT_VEC_DIS
      |             ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:141:40: warning: missing terminating ' character
  141 | define([th_expand], start_th_expand(`$1'))dnl
      |                                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:164:44: warning: missing terminating ' character
  164 | define([fork_expand], start_fork_expand(`$1'))dnl
      |                                            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:165:52: warning: missing terminating ' character
  165 | define([fork_expand_jmp], start_fork_expand_jmp(`$1'))dnl
      |                                                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:167:15: warning: missing terminating ' character
  167 | changequote(`,')dnl
      |               ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:172:22: warning: missing terminating ' character
  172 | define(`start_threads', th_expand(start_th))dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:178:21: warning: missing terminating ' character
  178 | define(`sync_threads', `
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:193:1: warning: missing terminating ' character
  193 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:204:1: warning: missing terminating ' character
  204 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:212:1: warning: missing terminating ' character
  212 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:217:1: warning: missing terminating ' character
  217 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:229:1: warning: missing terminating ' character
  229 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:237:1: warning: missing terminating ' character
  237 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:244:1: warning: missing terminating ' character
  244 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:259:1: warning: missing terminating ' character
  259 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:280:1: warning: missing terminating ' character
  280 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:297:1: warning: missing terminating ' character
  297 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:309:1: warning: missing terminating ' character
  309 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:315:1: warning: missing terminating ' character
  315 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:321:1: warning: missing terminating ' character
  321 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:328:1: warning: missing terminating ' character
  328 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:337:1: warning: missing terminating ' character
  337 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:345:1: warning: missing terminating ' character
  345 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:352:1: warning: missing terminating ' character
  352 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:358:1: warning: missing terminating ' character
  358 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:365:1: warning: missing terminating ' character
  365 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:371:1: warning: missing terminating ' character
  371 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:378:1: warning: missing terminating ' character
  378 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:386:1: warning: missing terminating ' character
  386 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:395:1: warning: missing terminating ' character
  395 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:397:22: warning: missing terminating ' character
  397 | define(make_reg, `%$1')dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:422:1: warning: missing terminating ' character
  422 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:446:1: warning: missing terminating ' character
  446 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:452:1: warning: missing terminating ' character
  452 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:458:1: warning: missing terminating ' character
  458 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:465:1: warning: missing terminating ' character
  465 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:469:20: warning: missing terminating ' character
  469 |  `define( `init_val', $1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:470:21: warning: missing terminating ' character
  470 |   define( `data_size', mpeval($3))
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:471:19: warning: missing terminating ' character
  471 |   define( `blk_len', mpeval($2))
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:472:20: warning: missing terminating ' character
  472 |   define( `it_count', 1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:473:19: warning: missing terminating ' character
  473 |   define( `sec_val', $5)
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:474:16: warning: missing terminating ' character
  474 |   define( `opr1', $4)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:475:16: warning: missing terminating ' character
  475 |   define( `opr2', $6)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:476:17: warning: missing terminating ' character
  476 |   define( `opnd3', $7)
      |                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:477:32: warning: missing terminating ' character
  477 |   ifelse(data_size,8,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:478:32: warning: missing terminating ' character
  478 |          data_size,4,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:479:39: warning: missing terminating ' character
  479 |                 data_size,2,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:480:39: warning: missing terminating ' character
  480 |                 data_size,1,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:484:32: warning: missing terminating ' character
  484 |  `ifelse(data_size,8,.xword `0x'mpeval(init_val opr1 sec_val,16,16),
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:485:24: warning: missing terminating ' character
  485 |   data_size,4,.word `0x'mpeval(init_val opr1 sec_val,16,8),
      |                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:486:38: warning: missing terminating ' character
  486 |                 data_size,2,.half `0x'mpeval(init_val opr1 sec_val,16,4),
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:487:38: warning: missing terminating ' character
  487 |                 data_size,1,.byte `0x'mpeval(init_val opr1 sec_val,16,2)) dnl
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:488:94: warning: missing terminating ' character
  488 |          ifelse(mpeval(len(opr1)>0),1,`define(`sec_val',`0x'mpeval(sec_val opr2 opnd3,16,16))') dnl
      |                                                                                              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:489:26: warning: missing terminating ' character
  489 |          define(`it_count', incr(it_count))
      |                          ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:26,
                 from <stdin>:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:450:25: warning: missing terminating ' character
  450 |   $1, 31, THR_31_PARTID)')
      |                         ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:510:18: warning: missing terminating ' character
  510 | define(ra2pa,``0x'mpeval($1 +
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:518:26: warning: missing terminating ' character
  518 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:531:26: warning: missing terminating ' character
  531 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:544:26: warning: missing terminating ' character
  544 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:548:18: warning: missing terminating ' character
  548 | define(pa2ra,``0x'mpeval($1 -
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:556:26: warning: missing terminating ' character
  556 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:569:26: warning: missing terminating ' character
  569 |   $2, 7, PART_7_BASE),16)')
      |                          ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/defines.h:26,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:27,
                 from <stdin>:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:96:37: warning: missing terminating ' character
   96 | ! ICACHE Diagnostic Access registers' field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:101:37: warning: missing terminating ' character
  101 | ! DCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:106:37: warning: missing terminating ' character
  106 | ! WCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:111:37: warning: missing terminating ' character
  111 | ! PCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:119:37: warning: missing terminating ' character
  119 | ! ECACHE Diagnostic Access registers' field definitions
      |                                     ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:28,
                 from <stdin>:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:89:81: warning: missing terminating ' character
   89 | dnl This macro enumerates from zero to the mask width.  It only expands the user's
      |                                                                                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:108:19: warning: missing terminating ' character
  108 |  ldx [[[%g2]]][[`,']] %g3   ! %g3 has coreavail
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:109:20: warning: missing terminating ' character
  109 |  rd      %asr26[[`,']] %l1
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:110:27: warning: missing terminating ' character
  110 |         set     0x1f00[[`,']] %g1
      |                           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:113:12: warning: missing terminating ' character
  113 |  mov 63[[`,']] %g1
      |            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:117:14: warning: missing terminating ' character
  117 |  brnz %g3[[`,']] skip_start_th
      |              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:129:11: warning: missing terminating ' character
  129 |  mov i[[`,']] %g1
      |           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:135:13: warning: missing terminating ' character
  135 |  stx %g1[[`,']] [[[%g3]]]  ! write to INT_VEC_DIS
      |             ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:141:40: warning: missing terminating ' character
  141 | define([th_expand], start_th_expand(`$1'))dnl
      |                                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:164:44: warning: missing terminating ' character
  164 | define([fork_expand], start_fork_expand(`$1'))dnl
      |                                            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:165:52: warning: missing terminating ' character
  165 | define([fork_expand_jmp], start_fork_expand_jmp(`$1'))dnl
      |                                                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:167:15: warning: missing terminating ' character
  167 | changequote(`,')dnl
      |               ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:172:22: warning: missing terminating ' character
  172 | define(`start_threads', th_expand(start_th))dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:178:21: warning: missing terminating ' character
  178 | define(`sync_threads', `
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:193:1: warning: missing terminating ' character
  193 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:204:1: warning: missing terminating ' character
  204 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:212:1: warning: missing terminating ' character
  212 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:217:1: warning: missing terminating ' character
  217 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:229:1: warning: missing terminating ' character
  229 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:237:1: warning: missing terminating ' character
  237 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:244:1: warning: missing terminating ' character
  244 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:259:1: warning: missing terminating ' character
  259 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:280:1: warning: missing terminating ' character
  280 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:297:1: warning: missing terminating ' character
  297 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:309:1: warning: missing terminating ' character
  309 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:315:1: warning: missing terminating ' character
  315 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:321:1: warning: missing terminating ' character
  321 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:328:1: warning: missing terminating ' character
  328 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:337:1: warning: missing terminating ' character
  337 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:345:1: warning: missing terminating ' character
  345 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:352:1: warning: missing terminating ' character
  352 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:358:1: warning: missing terminating ' character
  358 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:365:1: warning: missing terminating ' character
  365 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:371:1: warning: missing terminating ' character
  371 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:378:1: warning: missing terminating ' character
  378 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:386:1: warning: missing terminating ' character
  386 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:395:1: warning: missing terminating ' character
  395 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:397:22: warning: missing terminating ' character
  397 | define(make_reg, `%$1')dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:422:1: warning: missing terminating ' character
  422 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:446:1: warning: missing terminating ' character
  446 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:452:1: warning: missing terminating ' character
  452 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:458:1: warning: missing terminating ' character
  458 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:465:1: warning: missing terminating ' character
  465 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:469:20: warning: missing terminating ' character
  469 |  `define( `init_val', $1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:470:21: warning: missing terminating ' character
  470 |   define( `data_size', mpeval($3))
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:471:19: warning: missing terminating ' character
  471 |   define( `blk_len', mpeval($2))
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:472:20: warning: missing terminating ' character
  472 |   define( `it_count', 1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:473:19: warning: missing terminating ' character
  473 |   define( `sec_val', $5)
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:474:16: warning: missing terminating ' character
  474 |   define( `opr1', $4)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:475:16: warning: missing terminating ' character
  475 |   define( `opr2', $6)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:476:17: warning: missing terminating ' character
  476 |   define( `opnd3', $7)
      |                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:477:32: warning: missing terminating ' character
  477 |   ifelse(data_size,8,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:478:32: warning: missing terminating ' character
  478 |          data_size,4,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:479:39: warning: missing terminating ' character
  479 |                 data_size,2,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:480:39: warning: missing terminating ' character
  480 |                 data_size,1,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:484:32: warning: missing terminating ' character
  484 |  `ifelse(data_size,8,.xword `0x'mpeval(init_val opr1 sec_val,16,16),
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:485:24: warning: missing terminating ' character
  485 |   data_size,4,.word `0x'mpeval(init_val opr1 sec_val,16,8),
      |                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:486:38: warning: missing terminating ' character
  486 |                 data_size,2,.half `0x'mpeval(init_val opr1 sec_val,16,4),
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:487:38: warning: missing terminating ' character
  487 |                 data_size,1,.byte `0x'mpeval(init_val opr1 sec_val,16,2)) dnl
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:488:94: warning: missing terminating ' character
  488 |          ifelse(mpeval(len(opr1)>0),1,`define(`sec_val',`0x'mpeval(sec_val opr2 opnd3,16,16))') dnl
      |                                                                                              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:489:26: warning: missing terminating ' character
  489 |          define(`it_count', incr(it_count))
      |                          ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:26,
                 from <stdin>:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:450:25: warning: missing terminating ' character
  450 |   $1, 31, THR_31_PARTID)')
      |                         ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:510:18: warning: missing terminating ' character
  510 | define(ra2pa,``0x'mpeval($1 +
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:518:26: warning: missing terminating ' character
  518 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:531:26: warning: missing terminating ' character
  531 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:544:26: warning: missing terminating ' character
  544 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:548:18: warning: missing terminating ' character
  548 | define(pa2ra,``0x'mpeval($1 -
      |                  ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:556:26: warning: missing terminating ' character
  556 |   $2, 7, PART_7_BASE),16)')
      |                          ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/config.m4:569:26: warning: missing terminating ' character
  569 |   $2, 7, PART_7_BASE),16)')
      |                          ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/defines.h:26,
                 from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:27,
                 from <stdin>:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:96:37: warning: missing terminating ' character
   96 | ! ICACHE Diagnostic Access registers' field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:101:37: warning: missing terminating ' character
  101 | ! DCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:106:37: warning: missing terminating ' character
  106 | ! WCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:111:37: warning: missing terminating ' character
  111 | ! PCACHE Diagnostic Access registers'  field definitions
      |                                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/constants.h:119:37: warning: missing terminating ' character
  119 | ! ECACHE Diagnostic Access registers' field definitions
      |                                     ^
In file included from /home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/mt_body.h:28,
                 from <stdin>:37:
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:89:81: warning: missing terminating ' character
   89 | dnl This macro enumerates from zero to the mask width.  It only expands the user's
      |                                                                                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:108:19: warning: missing terminating ' character
  108 |  ldx [[[%g2]]][[`,']] %g3   ! %g3 has coreavail
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:109:20: warning: missing terminating ' character
  109 |  rd      %asr26[[`,']] %l1
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:110:27: warning: missing terminating ' character
  110 |         set     0x1f00[[`,']] %g1
      |                           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:113:12: warning: missing terminating ' character
  113 |  mov 63[[`,']] %g1
      |            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:117:14: warning: missing terminating ' character
  117 |  brnz %g3[[`,']] skip_start_th
      |              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:129:11: warning: missing terminating ' character
  129 |  mov i[[`,']] %g1
      |           ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:135:13: warning: missing terminating ' character
  135 |  stx %g1[[`,']] [[[%g3]]]  ! write to INT_VEC_DIS
      |             ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:141:40: warning: missing terminating ' character
  141 | define([th_expand], start_th_expand(`$1'))dnl
      |                                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:164:44: warning: missing terminating ' character
  164 | define([fork_expand], start_fork_expand(`$1'))dnl
      |                                            ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:165:52: warning: missing terminating ' character
  165 | define([fork_expand_jmp], start_fork_expand_jmp(`$1'))dnl
      |                                                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:167:15: warning: missing terminating ' character
  167 | changequote(`,')dnl
      |               ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:172:22: warning: missing terminating ' character
  172 | define(`start_threads', th_expand(start_th))dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:178:21: warning: missing terminating ' character
  178 | define(`sync_threads', `
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:193:1: warning: missing terminating ' character
  193 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:204:1: warning: missing terminating ' character
  204 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:212:1: warning: missing terminating ' character
  212 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:217:1: warning: missing terminating ' character
  217 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:229:1: warning: missing terminating ' character
  229 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:237:1: warning: missing terminating ' character
  237 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:244:1: warning: missing terminating ' character
  244 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:259:1: warning: missing terminating ' character
  259 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:280:1: warning: missing terminating ' character
  280 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:297:1: warning: missing terminating ' character
  297 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:309:1: warning: missing terminating ' character
  309 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:315:1: warning: missing terminating ' character
  315 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:321:1: warning: missing terminating ' character
  321 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:328:1: warning: missing terminating ' character
  328 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:337:1: warning: missing terminating ' character
  337 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:345:1: warning: missing terminating ' character
  345 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:352:1: warning: missing terminating ' character
  352 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:358:1: warning: missing terminating ' character
  358 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:365:1: warning: missing terminating ' character
  365 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:371:1: warning: missing terminating ' character
  371 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:378:1: warning: missing terminating ' character
  378 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:386:1: warning: missing terminating ' character
  386 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:395:1: warning: missing terminating ' character
  395 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:397:22: warning: missing terminating ' character
  397 | define(make_reg, `%$1')dnl
      |                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:422:1: warning: missing terminating ' character
  422 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:446:1: warning: missing terminating ' character
  446 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:452:1: warning: missing terminating ' character
  452 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:458:1: warning: missing terminating ' character
  458 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:465:1: warning: missing terminating ' character
  465 | ')dnl
      | ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:469:20: warning: missing terminating ' character
  469 |  `define( `init_val', $1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:470:21: warning: missing terminating ' character
  470 |   define( `data_size', mpeval($3))
      |                     ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:471:19: warning: missing terminating ' character
  471 |   define( `blk_len', mpeval($2))
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:472:20: warning: missing terminating ' character
  472 |   define( `it_count', 1)
      |                    ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:473:19: warning: missing terminating ' character
  473 |   define( `sec_val', $5)
      |                   ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:474:16: warning: missing terminating ' character
  474 |   define( `opr1', $4)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:475:16: warning: missing terminating ' character
  475 |   define( `opr2', $6)
      |                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:476:17: warning: missing terminating ' character
  476 |   define( `opnd3', $7)
      |                 ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:477:32: warning: missing terminating ' character
  477 |   ifelse(data_size,8,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:478:32: warning: missing terminating ' character
  478 |          data_size,4,`gen_value',
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:479:39: warning: missing terminating ' character
  479 |                 data_size,2,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:480:39: warning: missing terminating ' character
  480 |                 data_size,1,`gen_value',
      |                                       ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:484:32: warning: missing terminating ' character
  484 |  `ifelse(data_size,8,.xword `0x'mpeval(init_val opr1 sec_val,16,16),
      |                                ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:485:24: warning: missing terminating ' character
  485 |   data_size,4,.word `0x'mpeval(init_val opr1 sec_val,16,8),
      |                        ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:486:38: warning: missing terminating ' character
  486 |                 data_size,2,.half `0x'mpeval(init_val opr1 sec_val,16,4),
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:487:38: warning: missing terminating ' character
  487 |                 data_size,1,.byte `0x'mpeval(init_val opr1 sec_val,16,2)) dnl
      |                                      ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:488:94: warning: missing terminating ' character
  488 |          ifelse(mpeval(len(opr1)>0),1,`define(`sec_val',`0x'mpeval(sec_val opr2 opnd3,16,16))') dnl
      |                                                                                              ^
/home/u/prjs/OpenSPARCT1/verif/diag/assembly/include/macros.m4:489:26: warning: missing terminating ' character
  489 |          define(`it_count', incr(it_count))
      |                          ^
midas: rm -f mem.image diag.ev symbol.tbl diag*.exe
midas: ###########################################################
midas: ##  SECTION PARSING PHASE
midas: ###########################################################
midas: goldfinger -v -splitsec diag.m4 -midasfile diag.midas -prefix 'midas: '
midas: goldfinger: Writing midas directives to diag.midas
midas: goldfinger: Writing section RED_SEC to sec0.red_sec.s
midas: goldfinger: Writing section RED_EXT_SEC to sec1.red_ext_sec.s
midas: goldfinger: Writing section HPRIV_RESET to sec2.hpriv_reset.s
midas: goldfinger: Writing section HTRAPS to sec3.htraps.s
midas: goldfinger: Writing section TRAPS to sec4.traps.s
midas: goldfinger: Writing section KERNEL to sec5.kernel.s
midas: goldfinger: Writing section USER_HEAP to sec6.user_heap.s
midas: goldfinger: Writing section MAIN to sec7.main.s
midas: goldfinger: Writing section MAIN_0 to sec8.main_0.s
midas: goldfinger: Writing section MAIN_1 to sec9.main_1.s
midas: goldfinger: Writing section MAIN_2 to sec10.main_2.s
midas: goldfinger: Writing section MAIN_3 to sec11.main_3.s
midas: Finding sections in diag.midas
midas: Processing directives in diag.midas
midas: Performing sanity check on arguments.
midas: ###########################################################
midas: ##  ASSEMBLY PHASE
midas: ###########################################################
midas: Building 12 sections using 3 build threads.
midas: g_as -xarch=v9b sec1.red_ext_sec.s -o sec1.red_ext_sec.o
midas: g_as -xarch=v9b sec0.red_sec.s -o sec0.red_sec.o
midas: g_as -xarch=v9b sec2.hpriv_reset.s -o sec2.hpriv_reset.o
midas: g_as -xarch=v9b sec5.kernel.s -o sec5.kernel.o
midas: g_as -xarch=v9b sec4.traps.s -o sec4.traps.o
midas: g_as -xarch=v9b sec3.htraps.s -o sec3.htraps.o
midas: g_as -xarch=v9b sec8.main_0.s -o sec8.main_0.o
midas: g_as -xarch=v9b sec6.user_heap.s -o sec6.user_heap.o
midas: g_as -xarch=v9b sec7.main.s -o sec7.main.o
midas: g_as -xarch=v9b sec11.main_3.s -o sec11.main_3.o
midas: g_as -xarch=v9b sec9.main_1.s -o sec9.main_1.o
midas: g_as -xarch=v9b sec10.main_2.s -o sec10.main_2.o
midas: ###########################################################
midas: ##  LINK PHASE
midas: ###########################################################
midas: Writing linker script diag.ld_scr.
midas: g_ld -b elf64-sparc -no-warn-mismatch --no-check-sections -T diag.ld_scr -o diag.exe
midas: diag.exe successfully created.
midas: ###########################################################
midas: ##  POSTPROCESSING PHASE
midas: ###########################################################
midas: Generating diag.goldfinger...
midas: goldfinger -v -in diag.goldfinger -gentsbs -genimage -imagefile mem.image -gensymtab -symtabfile symbol.tbl -prefix 'midas: '
midas: goldfinger: Opening file 'diag.goldfinger' for input.
midas: symbol.tbl successfully created.
midas: mem.image successfully created.
midas: Generating diag.ev...
midas: diag.ev successfully created.
midas: ###########################################################
midas: ##  COPY PHASE
midas: ###########################################################
midas: rm -f ../diag.s ../mem.image ../diag.ev ../symbol.tbl ../diag.exe ../diag.pl
midas: Hard linking diag.s to '..'.
midas: Hard linking mem.image to '..'.
midas: Hard linking diag.ev to '..'.
midas: Hard linking symbol.tbl to '..'.
midas: Hard linking diag.exe to '..'.
midas: cd ..
midas: ###########################################################
midas: ##  CLEANUP PHASE
midas: ###########################################################
midas: rm -rf build
sims: locating diag default.dat
sims: Looking for diag under $DV_ROOT/verif/diag
sims: Found diag under /home/u/prjs/OpenSPARCT1/verif/diag/efuse/default.dat
sims: Caught a SIGDIE. sim_run_cmd not defined at /home/u/prjs/OpenSPARCT1/tools/src/sims/sims,1.262 line 3284.

/bin/rmdir: failed to remove '/var/tmp/u:mtblkldst_loop:model_core1:core1_mini:0:312450': No such file or directory
sims: stop_time Mon 11 Apr 2022 01:14:17 PM EDT

`````

vsim参数给的不对，后面生成的参数看上去是给VCS的。

`````shell
u@unamed:~/prjs/OpenSPARCT1_model$ sims -sim_type=vlog -sim_build_cmd=vlog -sim_build_args="-work ~/prjs/OpenSPARCT1_model/work" -sim_run_cmd=vsim -sim_run_args="-c work.sparc" -group=core1_mini -novera_build -novera_run
`````

`````shell
vsim +BW_BFM7 +BW_BFM6 +BW_BFM5 +BW_BFM4 +BW_BFM3 +BW_BFM2 +BW_BFM1 +SYSTEM_DV_MATCH=2 +RANK_DIMM +STACK_DIMM +hypervisor=1 +vera_exit_on_error +cpu_num=0 +dowarningfinish +doerrorfinish "-c work.sparc" +vcs+dumpvarsoff +finish_mask=3 +TIMEOUT=50000 +wait_cycle_to_kill=10 +max_cycle=200000 +tg_seed=1432548440 +good_trap=0000082000:1000122000 +bad_trap=0000082020:1000122020 +efuse_data_file=efuse.img +asm_diag_name=mt_wrrdcwp_loop.s +efuse_image_name=default.dat +dv_root=/home/u/prjs/OpenSPARCT1
`````

modelsim启动图形界面的时候总有问题，发现自己以前在Arch Linux上就遇到过这个问题；

https://whensungoes.blogspot.com/2020/04/install-modelsim-on-arch-linux.html

后面又找不到libbz2.so.1.0，装个32位的就行了。
`````shell
$ sudo apt install libbz2-dev:i386
`````

这时候modelsim图形界面是启动起来，但给的参数包括sims生成的参数应该都还不对。

测试用例有一部分能成功编译，然后调用vsim，但大部分还编译不过。

不过现在可以用modelsim图形界面加载整个sparc，但run 100ns，也没见出什么波形，这就得后面慢慢调试了。
