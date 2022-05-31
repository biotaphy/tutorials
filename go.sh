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
}


# -----------------------------------------------------------
set_environment() {
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
create_docker_env() {
    local -n req_env_params=$1
    local -n opt_env_key_params=$2

    echo "Created environment to run:"  | tee -a "$LOG"
    echo "    $CMD "                    | tee -a "$LOG"
    echo "        with"  | tee -a "$LOG"

    # Print any optional keywords and parameters
    len=${#opt_env_key_params[@]}
    if [ "$len" -gt 0 ] ; then
        echo "            $len optional parameters:"  | tee -a "$LOG"
        # List of array keys
        for i in "${!opt_env_key_params[@]}"; do
            # Write to env file
            echo "${i}=${opt_env_key_params[$i]}"  >> "$DOCKER_ENV_FNAME"
            # Log
            echo "                --$i ${opt_env_key_params[$i]}" | tee -a "$LOG"
        done
        echo "        and" | tee -a "$LOG"
    fi

    # Log
    echo "            ${#req_env_params[@]} required parameters (not in order here):" | tee -a "$LOG"
    echo "               " "${req_env_params[@]}" | tee -a "$LOG"
    # Required parameters
    for i in "${!req_env_params[@]}"; do
        # Write to env file
        echo "${i}=${req_env_params[$i]}"  >> "$DOCKER_ENV_FNAME"
    done
}

# -----------------------------------------------------------
create_grid_docker_envfile() {
    echo "Find $CMD parameters in $CONFIG_FILE" | tee -a "$LOG"
    # Associative arrays have strings as indexes instead of integers
    declare -A OPT_PARAMS
    declare -A REQ_PARAMS

    # Required parameters
    SHP_FNAME=$(grep -i ^shapegrid_filename "$CONFIG_FILE" |  awk '{print $2}')
    MIN_X=$(grep -i ^min_x "$CONFIG_FILE" |  awk '{print $2}')
    MIN_Y=$(grep -i ^min_y "$CONFIG_FILE" |  awk '{print $2}')
    MAX_X=$(grep -i ^max_x "$CONFIG_FILE" |  awk '{print $2}')
    MAX_Y=$(grep -i ^max_y "$CONFIG_FILE" |  awk '{print $2}')
    CELL_SIZE=$(grep -i ^cell_size "$CONFIG_FILE" |  awk '{print $2}')
    EPSG=$(grep -i ^epsg "$CONFIG_FILE" |  awk '{print $2}')

    if [ ! "$SHP_FNAME" ] ; then
        echo "Error: Missing value for output shapegrid filename in config." | tee -a "$LOG"
        exit 1
    fi
    if [ ! "$MIN_X" ] ; then
        echo "Error: Missing value for minimum x coordinate in config." | tee -a "$LOG"
        exit 1
    fi
    if [ ! "$MIN_Y" ] ; then
        echo "Error: Missing value for minimum y coordinate in config." | tee -a "$LOG"
        exit 1
    fi
    if [ ! "$MAX_X" ] ; then
        echo "Error: Missing value for maximum x coordinate in config." | tee -a "$LOG"
        exit 1
    fi
    if [ ! "$MAX_Y" ] ; then
        echo "Error: Missing value for maximum y coordinate in config." | tee -a "$LOG"
        exit 1
    fi
    if [ ! "$CELL_SIZE" ] ; then
        echo "Error: Missing value for cell size in config." | tee -a "$LOG"
        exit 1
    fi
    if [ ! "$EPSG" ] ; then
        echo "Error: Missing value for epsg code in config." | tee -a "$LOG"
        exit 1
    fi

    REQ_PARAMS[shapegrid_filename]="$SHP_FNAME"
    REQ_PARAMS[min_x]="$MIN_X"
    REQ_PARAMS[min_y]="$MIN_Y"
    REQ_PARAMS[max_x]="$MAX_X"
    REQ_PARAMS[max_y]="$MAX_Y"
    REQ_PARAMS[cell_size]="$CELL_SIZE"
    REQ_PARAMS[epsg]="$EPSG"

    # pass arrays by reference
    create_docker_env REQ_PARAMS OPT_PARAMS
}

# -----------------------------------------------------------
create_clean_occurrences_envfile() {
    echo "Find $CMD parameters in $CONFIG_FILE" | tee -a "$LOG"
    declare -A OPT_PARAMS
    declare -A REQ_PARAMS

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

    WRANGLER_CONFIG_FNAME=$(grep -i ^wrangler_config_filename "$CONFIG_FILE" |  awk '{print $2}')
    if [ ! "$WRANGLER_CONFIG_FNAME" ] ; then
        echo "Error: Missing value for input occurrence filename in config." | tee -a "$LOG"
        exit 1
    fi

    SPECIES_KEY=$(grep -i ^species_key "$CONFIG_FILE" |  awk '{print $2}')

    Y_KEY=$(grep -i ^y_key "$CONFIG_FILE" |  awk '{print $2}')
    REPORT_FNAME=$(grep -i ^report_filename "$CONFIG_FILE" |  awk '{print $2}')
#    LOG_OUTPUT=$(grep -i ^log_output "$CONFIG_FILE" |  awk '{print $2}')

    if [ ! "$SPECIES_KEY" ] ; then
        echo "Warning: Missing SPECIES_KEY value in $CONFIG_FILE, identifying species name column $IN_FNAME.  Using command default value." | tee -a "$LOG"
    fi
    if [ ! "$X_KEY" ] ; then
        echo "Warning: Missing X_KEY value in $CONFIG_FILE, identifying longitude column $IN_FNAME.  Using command default value." | tee -a "$LOG"
    fi
    if [ ! "$Y_KEY" ] ; then
        echo "Warning: Missing Y_KEY value in $CONFIG_FILE, identifying latitude column $IN_FNAME.  Using command default value." | tee -a "$LOG"
    fi

    REQ_PARAMS[in_filename]="$IN_FNAME"
    REQ_PARAMS[out_filename]="$OUT_FNAME"
    REQ_PARAMS[wrangler_config_filename]="$WRANGLER_CONFIG_FNAME"

    OPT_PARAMS[species_key]="$SPECIES_KEY"
    OPT_PARAMS[x_key]="$X_KEY"
    OPT_PARAMS[y_key]="$Y_KEY"
    OPT_PARAMS[report_filename]="$REPORT_FNAME"

    create_docker_env REQ_PARAMS OPT_PARAMS
}

# -----------------------------------------------------------
create_split_occurrence_data_envfile() {
  echo "split_occurrence_data"
#  ["split_occurrence_data",
#              "--max_open_writers", max_open_writers,
#              "--key_field", $key_field,
#              "--out_field", $out_field,
#              "--dwca", $dwca, $wrangler_filename,
#              "--csv", $csv_fn, $wranglers_fn, $sp_key, $x_key, $y_key]
}

# -----------------------------------------------------------
create_encode_layers_envfile() {
    echo "encode_layers"
    echo "Find $CMD parameters in $CONFIG_FILE" | tee -a "$LOG"
    declare -A OPT_PARAMS
    declare -A REQ_PARAMS

    # Required parameters
    OUT_DIR=$(grep -i ^out_dir "$CONFIG_FILE" |  awk '{print $2}')
    if [ ! "$OUT_DIR" ] ; then
        echo "Error: Missing value for out_dir (output directory) in config." | tee -a "$LOG"
        exit 1
    fi

    ENCODE_METHOD=$(grep -i ^encode_method "$CONFIG_FILE" |  awk '{print $2}')
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
set_environment

echo "Find $CMD parameters in $CONFIG_FILE and write to $DOCKER_ENV_FNAME" | tee -a "$LOG"
if [ "$CMD" == "list_commands" ] ; then
    usage
elif [ "$CMD" == "clean_occurrences" ] ; then
    create_clean_occurrences_envfile
elif [ "$CMD" == "build_shapegrid" ] ; then
    create_grid_envfile
elif [ "$CMD" == "split_occurrence_data" ] ; then
    create_split_occurrence_data_envfile
fi

start_process

time_stamp "# End"
