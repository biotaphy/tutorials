#!/bin/bash
#
# This script calls docker-compose after filling the docker-compose-occurrence.yml file
# with parameters to run a command in a docker container with an input-parameter
# configuration file
#
# Note: this script uses a provided param_config file to
#       1) populate docker .env file with a command and configuration filename
#       2) call docker-compose up with the supplemental docker-compose file
#          using

# -----------------------------------------------------------
usage ()
{
    CMD=$1
    if [ $# -eq 0 ] || [ "$CMD" == "list_commands" ] ; then
        echo "Usage: $0 <cmd>  <config_file>"
        echo "   "
        echo "This script creates an environment for a biotaphy command to be run with "
        echo "user-configured arguments in a docker container."
        echo "the <cmd> argument can be one of:"
        echo "      list_commands"
        echo "      clean_occurrences"
        echo "      build_shapegrid"
        echo "the <config_file> argument must be the full path to an INI file"
        echo "containing command-specific arguments"
        echo "   "
    elif [ "$CMD" == "clean_occurrences" ] ; then
        echo "This argument creates an environment for the biotaphy command "
        echo "clean_occurrences to be run in a docker container.  The <config_file>"
        echo "must containing the following required parameters:"
        echo "      IN_FNAME: full or relative path to the input occurrences file"
        echo "      OUT_FNAME: full or relative path to the output cleaned occurrences"
        echo "          file"
        echo "      PROCESS_CONFIG_FNAME: full or relative path to the command-specific"
        echo "          parameters JSON file."
        echo "and may contain the following optional parameters:"
        echo "      SPECIES_KEY: the fieldname in the first row of the input file for"
        echo "          the species name"
        echo "      X_KEY: the fieldname in the first row of the input file for the"
        echo "           longitude"
        echo "      Y_KEY: the fieldname in the first row of the input file for the"
        echo "           latitude"
        echo "      REPORT_FNAME: full or relative path to the output report file."
        echo "      LOG_OUTPUT: True or False flag indicating whether to enable logging"
    elif [ "$CMD" == "build_shapegrid" ] ; then
        echo "This argument creates an environment for the biotaphy command"
        echo "build_shapegrid to be run in a docker container.  "
        echo "The <config_file> must containing the following required parameters:"
        echo "      shapegrid_file_name: The location to store the resulting shapegrid."
        echo "      min_x: The minimum value for X (longitude) of the shapegrid."
        echo "      min_y: The minimum value for Y (latitude) of the shapegrid."
        echo "      max_x: The maximum value for X (longitude) of the shapegrid."
        echo "      max_y: The maximum value for Y (latitude) of the shapegrid."
        echo "      cell_size: The size of each cell (in map units indicated by EPSG)."
        echo "      epsg: The numeric EPSG code for the new shapegrid."
    fi
    exit 0
}

# -----------------------------------------------------------
set_defaults() {
    CMD=$1
    HOST_CONFIG_FILE=$2

    THISNAME=$(/bin/basename "$0")
    LOG=./data/log/$THISNAME.log
    if [ -f "$LOG" ] ; then
        /usr/bin/rm "$LOG"
    fi
    touch "$LOG"

    # Relative host data directory mapped to container data directory (mounted at root)
    HOST_DATA_DIR="data/"
    DOCKER_DATA_DIR="/biotaphy_data/"
    if [ ! -f "$HOST_CONFIG_FILE" ] ; then
        echo "File $HOST_CONFIG_FILE does not exist" | tee -a "$LOG"
    fi
    CONTAINER_CONFIG_FILE=$(echo $HOST_CONFIG_FILE | sed "s:^$HOST_DATA_DIR:$DOCKER_DATA_DIR:g")

    DOCKER_PATH=./docker
    COMPOSE_FNAME=docker-compose.yml
    CMD_COMPOSE_FNAME="$DOCKER_PATH"/docker-compose.command.yml

#    DOCKER_ENV_FNAME=$CMD_PATH/.env
    DOCKER_ENV_FNAME="$DOCKER_PATH"/"$CMD".env
    if [ -f "$DOCKER_ENV_FNAME" ] ; then
        /usr/bin/rm "$DOCKER_ENV_FNAME"
    fi
    touch "$DOCKER_ENV_FNAME"
}


# -----------------------------------------------------------
create_docker_envfile() {
    echo "Created environment to run:"  | tee -a "$LOG"
    echo "    $CMD "                    | tee -a "$LOG"

    echo "command=${CMD}"  >> "$DOCKER_ENV_FNAME"
    echo "        with command ${CMD}"  | tee -a "$LOG"
    if [ ! "$CONTAINER_CONFIG_FILE" ]  ; then
        echo "        without a configuration file argument"  | tee -a "$LOG"
    else
        echo "config_file=${CONTAINER_CONFIG_FILE}"  >> "$DOCKER_ENV_FNAME"
        echo "        and config_file ${CONTAINER_CONFIG_FILE}"  | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
start_process() {
    # clean_occurrences -r /data/output/cleaning_report.json /data/input/heuchera.csv /data/output/clean_data.csv /data/input/wrangler_conf_clean_occurrences.json
    echo "Ready to execute $CMD with:" | tee -a "$LOG"
    echo "      docker compose  --file ${COMPOSE_FNAME} --file ${CMD_COMPOSE_FNAME}  --env-file $DOCKER_ENV_FNAME  up" | tee -a "$LOG"
    docker compose --file "${COMPOSE_FNAME}" --file "${CMD_COMPOSE_FNAME}"  --env-file "${DOCKER_ENV_FNAME}"  up
}


# -----------------------------------------------------------
time_stamp () {
    echo "$1" $(/bin/date) | tee -a "$LOG"
}


# -----------------------------------------------------------
####### Main #######
COMMANDS=("list_commands"  "clean_occurrences" "encode_layers" "split_occurrence_data"  "build_shapegrid")

if [ $# -eq 0 ]; then
    usage
elif [ $# -eq 1 ]; then
    if [ "$1" == "list_commands" ] ; then
        usage
    else
        usage "$1"
    fi
fi

set_defaults "$1" "$2"
time_stamp "# Start"

echo "Command is $CMD"
echo "Write Docker $DOCKER_ENV_FNAME file with $CONFIG_FILE argument, then execute $CMD" | tee -a "$LOG"

if [[ " ${COMMANDS[*]} " =~  ${CMD}  ]]; then
    if [ "$CMD" == "list_commands" ] ; then
        usage
    else
        create_docker_envfile
        start_process
    fi
fi

time_stamp "# End"




