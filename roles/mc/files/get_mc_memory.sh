#! /bin/bash
Total_MEM=`cat /proc/meminfo |grep 'MemTotal'|awk '{print $2/1000/1024}'`
echo $Total_MEM

Free_MEM=`cat /proc/meminfo  |grep "MemFree" |awk '{print $2}'`
Buf_MEM=`cat /proc/meminfo  |grep "Buffers" |awk '{print $2}'`
Cache_MEM=`cat /proc/meminfo  |grep "^Cached" |awk '{print $2}'`
echo $((Free_MEM+Buf_MEM+Cache_MEM))|awk '{print $1/1000/1024}'

for port in `netstat -lntp4 |grep memcache |awk '{split($4, s, ":"); print s[2]}'`;
do 
	P_MEM=`echo "stats" | nc localhost $port |grep "maxbytes" |awk '{print $3/1024/1024}';`
	A_MEM=$((A_MEM+P_MEM))
done

echo $A_MEM |awk '{print $1/1000}'
