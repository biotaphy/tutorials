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
        for i in "${!COMMANDS[@]}"; do
            echo "      ${COMMANDS[$i]}"
        done
        echo "the <config_file> argument must be the full path to a JSON file"
        echo "containing command-specific arguments"
        echo "   "
    fi
    exit 0
}

# -----------------------------------------------------------
set_defaults() {
    CMD=$1
    HOST_CONFIG_FILE=$2

    LOG=./data/log/$CMD.log
    if [ -f "$LOG" ] ; then
        /usr/bin/rm "$LOG"
    fi
    touch "$LOG"

    IMAGE_NAME="tutor"

    RO_VOLUME="data"
    RW_VOLUME="output"
    VOLUME_BASE_MOUNT="/volumes"

    # Relative host data directory mapped to container data directory (mounted at root)
    HOST_DATA_DIR="data/param_config"
    DOCKER_DATA_DIR="/volumes/data/param_config"
    if [ ! -f "$HOST_CONFIG_FILE" ] ; then
        echo "File $HOST_CONFIG_FILE does not exist" | tee -a "$LOG"
    fi
    CONTAINER_CONFIG_FILE=$(echo $HOST_CONFIG_FILE | sed "s:^$HOST_DATA_DIR:$DOCKER_DATA_DIR:g")

#    COMPOSE_FNAME=docker-compose.yml
#    DOCKER_ENV_FNAME=./.env

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
create_docker_volumes() {
    # Create a named volume for use by any container
    volumes=($RO_VOLUME $RW_VOLUME)
    for i in "${!volumes[@]}"; do
        vol_name=${volumesS[$i]}
        vol_exists=$(docker volume ls | grep $vol_name | wc -l )
        if [ "$vol_exists" == "0" ]; then
            docker volume create $vol_name
        else
            echo "Volume $vol_name exists"  | tee -a "$LOG"
        fi
    done
}


# -----------------------------------------------------------
build_docker_image() {
    # Build and name an image from Dockerfile in this directory
    image_exists=$(docker image list | grep $IMAGE_NAME | wc -l )
    if [ "$image_exists" == "0" ]; then
        docker build . -t $IMAGE_NAME
    else
        echo "Image $IMAGE_NAME exists"  | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
start_process() {
    # Option string for volumes
    ro_vol_opt="--volume ${RO_VOLUME}:${VOLUME_MOUNT}/${RO_VOLUME}:ro"
    rw_vol_opt="--volume ${RW_VOLUME}:${VOLUME_MOUNT}/${RW_VOLUME}"
    # Command to execute in container
    command="${CMD} --config_file=${CONTAINER_CONFIG_FILE}"

    # Start a container from image built in build_docker_image, and
    # mounting volume created in create_docker_volume
    echo "Ready to execute:" | tee -a "$LOG"
    echo "    ${command}" | tee -a "$LOG"
    docker run -it  ${ro_vol_opt}  ${rw_vol_opt}  ${IMAGE_NAME}  ${command}
}


# -----------------------------------------------------------
time_stamp () {
    echo "$1" $(/bin/date) | tee -a "$LOG"
}


# -----------------------------------------------------------
####### Main #######
COMMANDS=(\
"list_commands"  "build_grid"  "encode_layers" "split_occurrence_data"  \
"wrangle_species_list"  "wrangle_occurrences"  "wrangle_tree")

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
        create_docker_volumes
        build_docker_image
        start_process
    fi
fi

time_stamp "# End"
