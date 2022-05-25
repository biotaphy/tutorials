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
    exit 0
}

# -----------------------------------------------------------
set_defaults() {
    IMAGE_NAME="tutor"
    CONTAINER_NAME="tutor_container"
    RO_VOLUME="data"
    RW_VOLUME="output"

    # Relative host config directory mapped to container config directory
    VOLUME_MOUNT="/volumes"
    host_config_dir="$RO_VOLUME/config"
    docker_config_dir="$VOLUME_MOUNT/$host_config_dir"

    if [ ! -f "$HOST_CONFIG_FILE" ] ; then
        echo "File $HOST_CONFIG_FILE does not exist"
        exit 0
    fi

    LOG=/tmp/$CMD.log
    if [ -f "$LOG" ] ; then
        /usr/bin/rm "$LOG"
    fi
    touch "$LOG"
    CONTAINER_CONFIG_FILE=$(echo $HOST_CONFIG_FILE | sed "s:^$host_config_dir:$docker_config_dir:g")
}


## -----------------------------------------------------------
#create_docker_envfile() {
#    docker_envfile="./.env"
#    if [ -f "$docker_envfile" ] ; then
#        /usr/bin/rm "$docker_envfile"
#    fi
#    touch "$docker_envfile"
#
#    echo " - Created environment to run:"  | tee -a "$LOG"
#    echo "        with command ${CMD}"  | tee -a "$LOG"
#
#    echo "command=${CMD}"  >> "$docker_envfile"
#    if [ ! "$CONTAINER_CONFIG_FILE" ]  ; then
#        echo "        without a configuration file argument"  | tee -a "$LOG"
#    else
#        echo "config_file=${CONTAINER_CONFIG_FILE}"  >> "$docker_envfile"
#        echo "        and config_file ${CONTAINER_CONFIG_FILE}"  | tee -a "$LOG"
#    fi
#}


## -----------------------------------------------------------
#create_docker_volumes() {
#    # Create a named volume for use by any container
#    volumes=($RO_VOLUME $RW_VOLUME)
#    for i in "${!volumes[@]}"; do
#        vol_name=${volumesS[$i]}
#        vol_exists=$(docker volume ls | grep $vol_name | wc -l )
#        if [ "$vol_exists" == "0" ]; then
#            docker volume create $vol_name
#        else
#            echo " - Volume $vol_name is already created"  | tee -a "$LOG"
#        fi
#    done
#}

# -----------------------------------------------------------
create_docker_volumes() {
    # Create named RO input volume for use by any container
    ro_vol_exists=$(docker volume ls | grep $RO_VOLUME | wc -l )
    if [ "$ro_vol_exists" == "0" ]; then
        docker volume create $RO_VOLUME
    else
        echo " - Volume $RO_VOLUME is already created"  | tee -a "$LOG"
    fi
    # Create named RW output volume for use by any container
    rw_vol_exists=$(docker volume ls | grep $RW_VOLUME | wc -l )
    if [ "$rw_vol_exists" == "0" ]; then
        docker volume create $RW_VOLUME
    else
        echo " - Volume $RW_VOLUME is already created"  | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
build_docker_image() {
    # Build and name an image from Dockerfile in this directory
    image_exists=$(docker image list | grep $IMAGE_NAME | wc -l )
    if [ "$image_exists" == "0" ]; then
        docker build . -t $IMAGE_NAME
    else
        echo " - Image $IMAGE_NAME is already built"  | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
start_container() {
    container_count=$(docker ps | grep $CONTAINER_NAME |  wc -l )
    if [ $container_count -ne 1 ]; then
        # Option string for volumes
        vol_opts="--volume ${RO_VOLUME}:${VOLUME_MOUNT}/${RO_VOLUME}:ro \
                  --volume ${RW_VOLUME}:${VOLUME_MOUNT}/${RW_VOLUME}"
        # Start the container, leaving it up
        echo " - Run container $CONTAINER_NAME from image $IMAGE_NAME" | tee -a "$LOG"
        docker run -td --name ${CONTAINER_NAME}  ${vol_opts}  ${IMAGE_NAME}  bash
    else
        echo " - Container $CONTAINER_NAME is already started" | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
execute_process() {
    # Command to execute in container; `test` lists directory contents
    if [ $CMD = "test" ]; then
        command="ls -lahtr $VOLUME_MOUNT/$RO_VOLUME/config"
    else
        command="${CMD} --config_file=${CONTAINER_CONFIG_FILE}"
    fi

    container_count=$(docker ps | grep $CONTAINER_NAME |  wc -l )
    if [ $container_count -eq 1 ]; then
        echo " - Ready to execute: ${command}" | tee -a "$LOG"
        # Run the command in the container
        docker exec -it ${CONTAINER_NAME} ${command}
    else
        echo " - Container $CONTAINER_NAME is not running to execute_process" | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
save_outputs() {
    # TODO: determine if bind-mount is more efficient than this named-volume
    # Find container id
    container_count=$(docker ps | grep $CONTAINER_NAME |  wc -l )
    if [ $container_count -eq 1 ]; then
        # If host directory does not exist, create it
        if [ ! -d "$RW_VOLUME" ] ; then
            mkdir ${RW_VOLUME}
        else
            echo " - Host directory $RW_VOLUME already exists" | tee -a "$LOG"
        fi
        # Copy command outputs (no wildcards) from container volume to host directory
        echo " - Copy outputs from container $CONTAINER_NAME" | tee -a "$LOG"
        docker cp ${CONTAINER_NAME}:${VOLUME_MOUNT}/${RW_VOLUME}/  ./${RW_VOLUME}/
    else
        echo " - Container $CONTAINER_NAME is not running to save_outputs" | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
stop_container() {
    # Find container id
    container_count=$(docker ps | grep $CONTAINER_NAME |  wc -l )
    if [ $container_count -eq 1 ]; then
        echo " - Stop container $CONTAINER_NAME" | tee -a "$LOG"
        docker stop $CONTAINER_NAME
    else
        echo " - Container $CONTAINER_NAME is not running" | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
time_stamp () {
    echo "$1" $(/bin/date) | tee -a "$LOG"
}


# -----------------------------------------------------------
####### Main #######
COMMANDS=(\
"list_commands"  "build_grid"  "calculate_pam_stats" "encode_layers" "split_occurrence_data"  \
"wrangle_species_list"  "wrangle_occurrences"  "wrangle_tree"  "test")

if [ $# -ne 2 ]; then
    usage
fi
CMD=$1
HOST_CONFIG_FILE=$2

set_defaults
time_stamp "# Start"

echo "Container command is: $CMD --config_file=$CONTAINER_CONFIG_FILE" | tee -a "$LOG"

if [[ " ${COMMANDS[*]} " =~  ${CMD}  ]]; then
    if [ "$CMD" == "list_commands" ] ; then
        usage
    else
        create_docker_volumes
        build_docker_image
        start_container
        execute_process
        save_outputs
        stop_container
    fi
fi

time_stamp "# End"
