---
title: 硬盘没空间了，/var/log占了很多
published: true
---

syslog占了40多G，不停的清就不停的涨。

不知道什么情况，网上搜到清理的方法，看来这个syslog还不能直接删。

`````shell
sudo sh -c 'cat /dev/null > /var/log/syslog'
`````


journal也占了4G多。

> 检查当前journal使用磁盘量
> journalctl --disk-usage
> 
> 清理方法可以采用按照日期清理，或者按照允许保留的容量清理，只保存2天的日志，最大500M
> journalctl --vacuum-time=2d
> journalctl --vacuum-size=500M
> 
> 如果要手工删除日志文件，则在删除前需要先轮转一次journal日志
> systemctl kill --kill-who=main --signal=SIGUSR2 systemd-journald.service
> 
> 要启用日志限制持久化配置，可以修改 /etc/systemd/journald.conf

> SystemMaxUse=16M
> ForwardToSyslog=no
> 
> 然后重启
> systemctl restart systemd-journald.service
> 
> 检查journal是否运行正常以及日志文件是否完整无损坏
> journalctl --verify


用journalctl看日志，有很多gnome windows messaging。

可能是我太久没重启了，gnome确实有点问题。
