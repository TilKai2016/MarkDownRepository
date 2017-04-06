#!/bin/sh
#========================
#wangjun
#wangjun@tsingyun.com.cn
#========================
while :
do
	cd /home/jieneng/Docker/hpvm-collect-server/collect-server/build/libs
	echo $(date) "wdog is running..."
	stillRunning=$(ps -ef | grep "collect-server" | grep -v "grep")
	if [ "$stillRunning" ] ; then
		echo $(date) "collect-server is running..."
	else
		echo $(date) "collect-server is stopped. restarting collect-server..." >> ./logs/wdog.log 2>&1
		java -jar collect-server-1.0.0-RC1.jar &
		echo $(date) "collect-server started." >> ./logs/wdog.log 2>&1
	fi
	sleep 60
done
