#!/bin/bash
Total_MEM=`cat /proc/meminfo |grep 'MemTotal'|awk '{print $2/1000/1024}'`
echo $Total_MEM

Free_MEM=`cat /proc/meminfo  |grep "MemFree" |awk '{print $2}'`
Buf_MEM=`cat /proc/meminfo  |grep "Buffers" |awk '{print $2}'`
Cache_MEM=`cat /proc/meminfo  |grep "^Cached" |awk '{print $2}'`
echo $((Free_MEM+Buf_MEM+Cache_MEM))|awk '{print $1/1000/1024}'

for port in `netstat -lntp |grep redis |grep -v 'tcp6' |awk '{split($4,s,":"); print s[2];}' |grep  -E "^[0-9]{4}$"`;
do
    P_MEM=`(echo -e "config get maxmemory\r\n"; sleep 0;)|nc localhost $port|tail -1`
    sleep 1
	echo $P_MEM
    A_MEM=$((A_MEM+P_MEM))
done

echo $A_MEM |awk '{print $1/1000/1000}'
