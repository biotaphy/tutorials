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
    CMD=$1
    if [ $# -eq 0 ] || [ $CMD == "list_commands" ] ; then
        echo "Usage: $0 <cmd>  <config_file>"
        echo "   "
        echo "This script creates an environment for a biotaphy command to be run with user-configured arguments "
        echo "in a docker container."
        echo "the <cmd> argument can be one of:"
        echo "      list_commands"
        echo "      clean_occurrences"
        echo "the <config_file> argument must be the full path to an INI file containing command-specific arguments"
        echo "   "
    elif [ $CMD == "clean_occurrences" ] ; then
        echo "This argument creates an environment for the biotaphy command clean_occurrences to be run"
        echo "in a docker container.  The <config_file> must containing the following required parameters:"
        echo "      IN_FNAME: full or relative path to the input occurrences file"
        echo "      OUT_FNAME: full or relative path to the output cleaned occurrences file"
        echo "      PROCESS_CONFIG_FNAME: full or relative path to the command-specific parameters JSON file."
        echo "and may contain the following optional parameters:"
        echo "      SPECIES_KEY: the fieldname in the first row of the input file for the species name"
        echo "      X_KEY: the fieldname in the first row of the input file for the longitude"
        echo "      Y_KEY: the fieldname in the first row of the input file for the latitude"
        echo "      REPORT_FNAME: full or relative path to the output report file."
        echo "      LOG_OUTPUT: True or False, flag indicating whether to enable logging"
    fi
    exit 0
}

# -----------------------------------------------------------
set_defaults() {
    CMD=$1
    CONFIG_FILE=$2

    THISNAME=`/bin/basename $0`
    LOG=./data/log/$THISNAME.log
    touch "$LOG"

    DOCKER_PATH=./docker
#    DOCKER_OCC_PATH=./docker/occurrence
    COMPOSE_FNAME=docker-compose.yml

    if [ ! -f "$CONFIG_FILE" ] ; then
        echo "File $CONFIG_FILE does not exist" | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
set_environment() {
    CMD_PATH="$DOCKER_PATH"/$1
    CMD_COMPOSE_FNAME=$CMD_PATH/$COMPOSE_FNAME
    CMD_ENV_FNAME=$CMD_PATH/.env

    if [ -f "$CMD_ENV_FNAME" ] ; then
        /usr/bin/rm "$CMD_ENV_FNAME"
    fi

    touch $CMD_ENV_FNAME
}

# -----------------------------------------------------------
create_occurrence_docker_envfile() {
    echo "Find $CMD parameters in config file" >> "$LOG"

    # Required parameters
    IN_FNAME=$(grep -i ^in_filename "$CONFIG_FILE" |  awk '{print $2}')
    if [ ! "$IN_FNAME" ] ; then
        echo "Error: Missing value for input occurrence filename in config." | tee -a "$LOG"
        exit 1
    fi

    OUT_FNAME=$(grep -i ^out_filename "$CONFIG_FILE" |  awk '{print $2}')
    if [ ! "$OUT_FNAME" ] ; then
        echo "Error: Missing value for output occurrence filename in config." | tee -a "$LOG"
        exit 1
    fi

    PROCESS_CONFIG_FNAME=$(grep -i ^config_filename "$CONFIG_FILE" |  awk '{print $2}')
    if [ ! "$PROCESS_CONFIG_FNAME" ] ; then
        echo "Error: Missing value for input occurrence filename in config." | tee -a "$LOG"
        exit 1
    fi

    SPECIES_KEY=$(grep -i ^species_key "$CONFIG_FILE" |  awk '{print $2}')
    X_KEY=$(grep -i ^x_key "$CONFIG_FILE" |  awk '{print $2}')
    Y_KEY=$(grep -i ^y_key "$CONFIG_FILE" |  awk '{print $2}')
    REPORT_FNAME=$(grep -i ^report_filename "$CONFIG_FILE" |  awk '{print $2}')
    LOG_OUTPUT=$(grep -i ^log_output "$CONFIG_FILE" |  awk '{print $2}')
    if [ ! "$SPECIES_KEY" ] ; then
        echo "Warning: Missing SPECIES_KEY value in $CONFIG_FILE, identifying species name column $IN_FNAME.  Using command default value." | tee -a "$LOG"
    fi
    if [ ! "$X_KEY" ] ; then
        echo "Warning: Missing X_KEY value in $CONFIG_FILE, identifying longitude column $IN_FNAME.  Using command default value." | tee -a "$LOG"
    fi
    if [ ! "$Y_KEY" ] ; then
        echo "Warning: Missing Y_KEY value in $CONFIG_FILE, identifying latitude column $IN_FNAME.  Using command default value." | tee -a "$LOG"
    fi

    set_environment "occurrence"
    echo "SPECIES_KEY=$SPECIES_KEY"  >> "$CMD_ENV_FNAME"
    echo "X_KEY=$X_KEY"  >> "$CMD_ENV_FNAME"
    echo "Y_KEY=$Y_KEY"  >> "$CMD_ENV_FNAME"
    echo "REPORT_FNAME=$REPORT_FNAME"  >> "$CMD_ENV_FNAME"
    echo "LOG_OUTPUT=$LOG_OUTPUT"  >> "$CMD_ENV_FNAME"
    echo "IN_FNAME=$IN_FNAME"  >> "$CMD_ENV_FNAME"
    echo "OUT_FNAME=$OUT_FNAME"  >> "$CMD_ENV_FNAME"
    echo "PROCESS_CONFIG_FNAME=$PROCESS_CONFIG_FNAME"  >> "$CMD_ENV_FNAME"

}

# -----------------------------------------------------------
start_occurrence_process() {
    # clean_occurrences -r /demo/cleaning_report.json /demo/heuchera.csv /demo/clean_data.csv /demo/wrangler_conf.json
    create_occurrence_docker_envfile
    echo "Troublesome var is ${DOCKER_OCC_PATH}/.env"
    docker compose -f ${COMPOSE_FNAME}  -f ${CMD_COMPOSE_FNAME}  --env-file ${CMD_ENV_FNAME}  up
#    echo "Ready to execute $CMD with:" | tee -a "$LOG"
#    echo "      docker compose -f $COMPOSE_FNAME -f $DOCKER_OCC_PATH/$COMPOSE_FNAME  --env-file $DOCKER_OCC_PATH/.env  up" | tee -a "$LOG"
}

# -----------------------------------------------------------
time_stamp () {
    echo "$1" "/bin/date" >> "$LOG"
}


####### Main #######
if [ $# -eq 0 ]; then
    usage
elif [ $# -eq 1 ]; then
    if [ "$1" == "list_commands" ] ; then
        usage
    else
        usage $1
    fi
fi

set_defaults $1 $2
time_stamp "# Start"

if [ $CMD == "list_commands" ] ; then
    usage
elif [ $CMD == "clean_occurrences" ] ; then
    start_occurrence_process
fi


time_stamp "# End"

