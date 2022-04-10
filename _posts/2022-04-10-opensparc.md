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

`````
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
...
````

这之后，就按README里说的，`source OpenSPARCT1.bash`

然后
`````
$ cd ..
$ cd OpenSPARCT1_model
$ sims -sim_type=vcs -group=core1_mini
`````

我没有vcs，先试下，因为后面马上出错了。

`````
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

`````
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
