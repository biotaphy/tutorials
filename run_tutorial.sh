#!/bin/bash
#
# This script calls docker-compose with a specific docker-compose-occurrence.yml file and parameters to run a docker container
# with a particular command, inputs, and parameters
#
# Note: this script could use a provided config file to populate both:
#             - a docker .env file to be used by docker-compose
#             - a command configuration json file, such as wrangler_conf_clean_occurrences.json
#

# -----------------------------------------------------------
usage ()
{
    CMD=$1
    if [ $# -eq 0 ] || [ "$CMD" == "list_commands" ] ; then
        echo "Usage: $0 <cmd>  <config_file>"
        echo "   "
        echo "This script creates an environment for a biotaphy command to be run with user-configured arguments "
        echo "in a docker container."
        echo "the <cmd> argument can be one of:"
        echo "      list_commands"
        echo "      clean_occurrences"
        echo "      build_shapegrid"
        echo "the <config_file> argument must be the full path to an INI file containing command-specific arguments"
        echo "   "
    elif [ "$CMD" == "clean_occurrences" ] ; then
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
    elif [ "$CMD" == "build_shapegrid" ] ; then
        echo "This argument creates an environment for the biotaphy command build_shapegrid to be run"
        echo "in a docker container.  The <config_file> must containing the following required parameters:"
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
    CONFIG_FILE=$2

    THISNAME=$(/bin/basename "$0")
    LOG=./data/log/$THISNAME.log
    if [ -f "$LOG" ] ; then
        /usr/bin/rm "$LOG"
    fi
    touch "$LOG"

    if [ ! -f "$CONFIG_FILE" ] ; then
        echo "File $CONFIG_FILE does not exist" | tee -a "$LOG"
    fi

    HOST_DATA_DIR="data"
    DOCKER_DATA_DIR="biotaphy_data/input"

    DOCKER_PATH=./docker
    COMPOSE_FNAME=docker-compose.yml

    CMD_PATH="$DOCKER_PATH"/$CMD
    CMD_COMPOSE_FNAME=$CMD_PATH/$COMPOSE_FNAME

    DOCKER_ENV_FNAME=$CMD_PATH/.env
    if [ -f "$DOCKER_ENV_FNAME" ] ; then
        /usr/bin/rm "$DOCKER_ENV_FNAME"
    fi
    touch "$DOCKER_ENV_FNAME"
}


# -----------------------------------------------------------
create_docker_envfile() {
    echo "Created environment to run:"  | tee -a "$LOG"
    echo "    $CMD "                    | tee -a "$LOG"

    if [ ! "$CONFIG_FILE" ]  ; then
        echo "        without a configuration file argument"  | tee -a "$LOG"
    else
        # Write to env file
        echo "--config_file=${CONFIG_FILE}"  >> "$DOCKER_ENV_FNAME"
        echo "        with --config_file ${CONFIG_FILE}"  | tee -a "$LOG"
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


####### Main #######
COMMANDS=("list_commands"  "clean_occurrences"  "split_occurrence_data"  "build_shapegrid")

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
echo "Write Docker $DOCKER_ENV_FNAME file with $CONFIG_FILE argument, then execute $CMD" | tee -a "$LOG"
if [[ " ${COMMANDS[*]} " =~  ${CMD}  ]]; then
    echo "Command is $CMD"
    if [ "$CMD" == "list_commands" ] ; then
        usage
    else
        create_docker_envfile
    fi
fi
#start_process

time_stamp "# End"




