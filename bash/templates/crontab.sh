# 
# This file is part of PiSleepTalk.
# Learn more at: https://github.com/blaues0cke/PiSleepTalk
# 
# Author:  Thomas Kekeisen <pisleeptalk@tk.ca.kekeisen.it>
# License: This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
#          To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
#

#
# Init the gpio interface
#
@reboot     root           sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/init-gpio.sh

#
# Will check the free disk space and the service persistance every 60s
#
*   *  * * * root            sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/health-check.sh

#
# Will add the timestamp to the filename every 15 seconds
#
*   *  * * * root            sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/add-timestamp-to-filename.sh
*   *  * * * root sleep 15;  sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/add-timestamp-to-filename.sh
*   *  * * * root sleep 30;  sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/add-timestamp-to-filename.sh
*   *  * * * root sleep 45;  sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/add-timestamp-to-filename.sh

#
# Will add the amplitude to the filename every 15 seconds
#
*   *  * * * root sleep 10;  sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/add-amplitude-to-filename.sh
*   *  * * * root sleep 25;  sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/add-amplitude-to-filename.sh
*   *  * * * root sleep 40;  sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/add-amplitude-to-filename.sh
*   *  * * * root sleep 55;  sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/add-amplitude-to-filename.sh

#
# Will decrease and increase the volumne of audio files every 15 seconds
#
*   *  * * * root sleep 12;  sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/process-volumne.sh
*   *  * * * root sleep 27;  sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/process-volumne.sh
*   *  * * * root sleep 42;  sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/process-volumne.sh
*   *  * * * root sleep 57;  sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/process-volumne.sh

#
# Will process the records every minute
#
*   *  * * * root sleep 5;   sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/process-records.sh

#
# Will concat full movies
#
*   14 * * * root            sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/render-video.sh 

#
# Will create images for every frame every 5 minutes
#
*/5 *  * * * root            sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/create-frame-images.sh

#
# Will render videos every 5 minutes
#
*/5 *  * * * root sleep 300; sh /usr/sleeptalk/bash/run-singleton.sh /usr/sleeptalk/bash/generate-video.sh



