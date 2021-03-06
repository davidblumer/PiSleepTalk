#!/bin/bash

# 
# This file is part of PiSleepTalk.
# Learn more at: https://github.com/blaues0cke/PiSleepTalk
# 
# Author:  Thomas Kekeisen <pisleeptalk@tk.ca.kekeisen.it>
# License: This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
#          To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
#

. /usr/sleeptalk/config/config.cfg

start_allowed=true

echo "Running health check"

if [ "$start_allowed" = true ]; then
	usedSpaceInPercent=$(df -k | head -2 | tail -1 | awk '{print $5}' | sed "s/\(\%\)//")

	echo "... used space in percent: ${usedSpaceInPercent}%"

	if [ $usedSpaceInPercent -gt 90 ]; then
		echo "... too much space is in use, stopping recording audio" 

		start_allowed=false   
	else
		echo "... enough free disk space available, validating recording service"
	fi
fi

if [ "$start_allowed" = true ]; then
	if [ "$recording_hours_check_enabled" = true ]; then
		# Thanks to
		# * http://www.cyberciti.biz/faq/unix-linux-bash-get-time/
		current_hour=$(date +"%H")
		time_check_result=$(echo "${recording_hours}" | grep -F -q -w "${current_hour}" && echo "1" || echo "0")

		echo "... allowed hours: ${recording_hours}, current hour: ${current_hour}"

		# Thanks to
		# * http://stackoverflow.com/questions/8063228/how-do-i-check-if-a-variable-exists-in-a-list-in-bash
		if [ "${time_check_result}" -gt "0" ]; then
			echo "... time inside the allowed hours, start still allowed"
		else
			echo "... time outside the allowed hours, start forbidden"

			start_allowed=false
		fi
	else
		echo "... recording hours check disabled, skipping check"
	fi
fi

if [ "$start_allowed" = true ]; then
	if [ "$button_enabled" = true ]; then
		echo "... gpio button support enabled, checking button"

		button_state=$(gpio read 0)

		echo "... button state: ${button_state}"

		if [ "${button_state}" -eq "1" ]; then
			echo "... button on, start still allowed"
		else
			echo "... button off, start forbidden"

			start_allowed=false
		fi
	else
		echo "... gpio button support disabled, skipping check"
	fi
fi

if [ "$start_allowed" = true ]; then
	if [ "$last_fm_enabled" = true ]; then
		echo "... last.fm support enabled, checking last track date"

		last_last_fm_time=$(curl -s 'http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user='"${last_fm_username}"'&api_key='"${last_fm_api_key}"'&format=json' | python /usr/sleeptalk/bash/parse-lastfm.py)
		current_time=$(date +%s)
		difference=$(($current_time - $last_last_fm_time))

		echo "... last fm time: ${last_last_fm_time}"
		echo "... current time: ${current_time}"
		echo "... difference: ${difference}"

		if [ "${difference}" -ge "${last_fm_timeout_in_seconds}" ]; then
			echo "... last listened song is more that ${difference}s ago, start still allowed"
		else
			echo "... last listened song is less that ${difference}s ago, start forbidden"

			start_allowed=false
		fi
	else
		echo "... last.fm support disabled, skipping check"
	fi
fi

if [ "$start_allowed" = true ]; then
	if [ "$swarm_enabled" = true ]; then
		echo "... swarm support enabled, checking last check in"

		request_url="https://api.foursquare.com/v2/users/self/checkins?oauth_token=${swarm_oauth_token}&v=20160207"
		last_venue_id=$(curl -s ''"${request_url}"'' | python /usr/sleeptalk/bash/parse-swarm.py)

		echo "... last venue id: ${last_venue_id}"
		echo "... home venue id: ${swarm_home_venue_id}"

		if [ "${last_venue_id}" = "${swarm_home_venue_id}" ]; then
			echo "... last check in was at home, start still allowed"
		else
			echo "... last check in was not at home, start forbidden"

			start_allowed=false
		fi
	else
		echo "... swarm support disabled, skipping check"
	fi
fi

if [ "$force_button_enabled" = true ]; then
	echo "... gpio force button support enabled, checking button"

	button_state=$(gpio read 1)

	echo "... button state: ${button_state}"

	if [ "${button_state}" -eq "1" ]; then
		echo "... button on, forcing start"

		start_allowed=true
	fi
else
	echo "... gpio force button support disabled, skipping check"
fi

if [ "$start_allowed" = true ]; then
	if [ "$led_enabled" = true ]; then
		gpio write 2 1
	else
		gpio write 2 0
	fi

	runningProcesses=`ps aux | grep "arecord -D" | wc -l`

	echo "... found services matching our request: ${runningProcesses}"

	if [ ${runningProcesses} -lt 2 ]; then
		echo "... starting new recording service"

	    sh /usr/sleeptalk/bash/start.sh
	fi
else
	sh /usr/sleeptalk/bash/stop.sh

	gpio write 2 0
fi

echo "Done"