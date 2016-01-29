#!/bin/sh

# 
# This file is part of PiSleepTalk.
# Learn more at: https://github.com/blaues0cke/PiSleepTalk
# 
# Author:  Thomas Kekeisen <pisleeptalk@tk.ca.kekeisen.it>
# License: This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
#          To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
#

# kFreeBSD do not accept scripts as interpreters, using #!/bin/sh and sourcing.
if [ true != "$INIT_D_SCRIPT_SOURCED" ] ; then
    set "$0" "$@"; INIT_D_SCRIPT_SOURCED=true . /lib/init/init-d-script
fi
### BEGIN INIT INFO
# Provides:          pi-sleeptalk-nodejs
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: The nodejs server behind PiSleepTalk
# Description:       The nodejs server behind PiSleepTalk.
#                    Starts the server using nodemon.
### END INIT INFO

# Author: Thomas Kekeisen <thomas.kekeisen@toolbox-bodensee.de>
#
# This file can be found in /etc/init.d/pi-sleeptalk-nodejs

DESC="PiSleepTalk nodejs service"
DAEMON=/usr/sbin/pi-sleeptalk-nodejs

case "$1" in
    start)
        su - root -c "sh /usr/sleeptalk/bash/start-server.sh"
        ;;
    stop)
        su - root -c "sh /usr/sleeptalk/bash/stop-server.sh"
        ;;
    restart)
        # RESTART
        ;;
esac
 
exit 0