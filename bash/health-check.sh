#!/bin/bash

# 
# This file is part of PiSleepTalk.
# Learn more at: https://github.com/blaues0cke/PiSleepTalk
# 
# Author:  Thomas Kekeisen <pisleeptalk@tk.ca.kekeisen.it>
# License: This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
#          To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
#

echo "Running health check"

usedSpaceInPercent=$(df -k | head -2 | tail -1 | awk '{print $5}' | sed "s/\(\%\)//")

echo "... used space in percent: ${usedSpaceInPercent}%"

if [ $usedSpaceInPercent -gt 90 ]; then
	echo "... too much space is in use, stopping recording audio"

    sh /usr/sleeptalk/bash/stop.sh
else

	echo "... enough free disk space available, validating recording service"

	runningProcesses=`ps aux | grep "arecord -D" | wc -l`

	echo "... found services matching our request: ${runningProcesses}"

	if [ ${runningProcesses} -lt 2 ]; then
		echo "... starting new recording service"

	    sh /usr/sleeptalk/bash/start.sh
	fi
fi

echo "Done"