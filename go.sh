#!/bin/bash
#
# This script calls docker-compose with a specific docker-compose.yml file and parameters to run a docker container
# with a particular command, inputs, and parameters
#
usage ()
{
    echo "Usage: $0 <cmd>  <config_file>"
    echo "   "
    echo "This script requires the docker daemon be running. "
    echo "   "
}

set_defaults() {
    CMD=$1
    CONFIG_FILE=$2

    THISNAME=`/bin/basename $0`
    LOG=./data/log/$THISNAME.log
    touch $LOG

    if [ -f $CONFIG_FILE ] ; then
        echo "Find PUBLIC_USER in site config file" >> $LOG
        PUBLIC_USER=`grep -i ^PUBLIC_USER $SITE_CONFIG_FILE |  awk '{print $2}'`
    else:
        echo "File $CONFIG_FILE does not exist" | tee -a $LOG
    fi
}

time_stamp () {
    echo $1 `/bin/date` >> $LOG
}


####### Main #######
if [ $# -ne 2 ]; then
    usage
    exit 0
fi

set_defaults $1 $2
time_stamp "# Start"

TimeStamp "# End"

