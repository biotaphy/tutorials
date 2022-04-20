#!/bin/bash
#
# This script calls docker-compose with a specific docker-compose-occurrence.yml file and parameters to run a docker container
# with a particular command, inputs, and parameters
#
# Note: this script could use a provided config file to populate both:
#             - a docker .env file to be used by docker-compose
#             - a command configuration json file, such as wranger_conf.json
#

# -----------------------------------------------------------
usage ()
{
    echo "Usage: $0 <cmd>  <config_file>"
    echo "   "
    echo "This script requires the docker daemon be running. "
    echo "   "
}

# -----------------------------------------------------------
set_defaults() {
    CMD=$1
    CONFIG_FILE=$2

    THISNAME=`/bin/basename $0`
    LOG=./data/log/$THISNAME.log
    touch "$LOG"

    DOCKER_OCC_PATH=./docker/occurrence
    COMPOSE_FNAME=docker-compose.yml

    if [ -f "$CONFIG_FILE" ] ; then
        echo "Ready to execute $CMD with $CONFIG_FILE parameters." | tee -a "$LOG"
    else
        echo "File $CONFIG_FILE does not exist" | tee -a "$LOG"
    fi

}

# -----------------------------------------------------------
create_occurrence_docker_envfile() {
    echo "Find $CMD parameters in config file" >> "$LOG"
    SPECIES_KEY=$(grep -i ^species_key "$CONFIG_FILE" |  awk '{print $2}')
    X_KEY=$(grep -i ^x_key "$CONFIG_FILE" |  awk '{print $2}')
    Y_KEY=$(grep -i ^y_key "$CONFIG_FILE" |  awk '{print $2}')
    REPORT_FNAME=$(grep -i ^report_filename "$CONFIG_FILE" |  awk '{print $2}')
    DO_LOG=$(grep -i ^log_output "$CONFIG_FILE" |  awk '{print $2}')
    IN_FNAME=$(grep -i ^in_filename "$CONFIG_FILE" |  awk '{print $2}')
    OUT_FNAME=$(grep -i ^out_filename "$CONFIG_FILE" |  awk '{print $2}')
    PROCESS_CONFIG_FNAME=$(grep -i ^config_filename "$CONFIG_FILE" |  awk '{print $2}')

    # Required parameters
    if [ ! "$IN_FNAME" ] ; then
        echo "Error: Missing value for input occurrence filename in config." | tee -a "$LOG"
        exit 1
    fi
    if [ ! "$OUT_FNAME" ] ; then
        echo "Error: Missing value for output occurrence filename in config." | tee -a "$LOG"
        exit 1
    fi
    if [ ! "$PROCESS_CONFIG_FNAME" ] ; then
        echo "Error: Missing value for input occurrence filename in config." | tee -a "$LOG"
        exit 1
    fi

    if [ ! "$SPECIES_KEY" ] ; then
        echo "Warning: Missing SPECIES_KEY value in $CONFIG_FILE, identifying species name column $IN_FNAME.  Using command default value." | tee -a "$LOG"
    fi
    if [ ! "$X_KEY" ] ; then
        echo "Warning: Missing X_KEY value in $CONFIG_FILE, identifying longitude column $IN_FNAME.  Using command default value." | tee -a "$LOG"
    fi
    if [ ! "$Y_KEY" ] ; then
        echo "Warning: Missing Y_KEY value in $CONFIG_FILE, identifying latitude column $IN_FNAME.  Using command default value." | tee -a "$LOG"
    fi

    COMPOSE_ENV_FNAME=$DOCKER_OCC_PATH/.env
    touch $COMPOSE_ENV_FNAME

    echo "SPECIES_KEY=$SPECIES_KEY"  >> "$COMPOSE_ENV_FNAME"
    echo "X_KEY=$X_KEY"  >> "$COMPOSE_ENV_FNAME"
    echo "Y_KEY=$Y_KEY"  >> "$COMPOSE_ENV_FNAME"
    echo "REPORT_FNAME=$REPORT_FNAME"  >> "$COMPOSE_ENV_FNAME"
    echo "LOG_OUTPUT=$DO_LOG"  >> "$COMPOSE_ENV_FNAME"
    echo "IN_FNAME=$IN_FNAME"  >> "$COMPOSE_ENV_FNAME"
    echo "OUT_FNAME=$OUT_FNAME"  >> "$COMPOSE_ENV_FNAME"
    echo "PROCESS_CONFIG_FNAME=$PROCESS_CONFIG_FNAME"  >> "$COMPOSE_ENV_FNAME"
}

# -----------------------------------------------------------
start_occurrence_process() {
    # clean_occurrences -r /demo/cleaning_report.json /demo/heuchera.csv /demo/clean_data.csv /demo/wrangler_conf.json
    create_occurrence_docker_envfile
    docker compose -f "$DOCKER_OCC_PATH"/"$COMPOSE_FNAME" up

}

# -----------------------------------------------------------
time_stamp () {
    echo "$1" "/bin/date" >> "$LOG"
}


####### Main #######
if [ $# -ne 2 ]; then
    usage
    exit 0
fi

set_defaults $1 $2
time_stamp "# Start"

if [ $CMD == "clean_occurrences" ] ; then
    start_occurrence_process
fi


time_stamp "# End"

