#!/bin/bash
#
# This script calls docker-compose after filling the docker-compose-occurrence.yml file
# with parameters to run a command in a docker container with an input-parameter
# configuration file
#
# Note: this script uses a provided config file to
#   1. create the volumes `data` and `output` (if they do not exist)
#   2. build the image `tutor` (if it does not exist)
#   3. start a container with volumes attached and
#   4. run the chosen command with chosen configuration file
#   5. compute output files in the `output` volume
#   6. copy output files to the host machine

# -----------------------------------------------------------
usage ()
{
    echo ""
    echo "Usage: $0 <cmd>  <config_file>"
    echo "This script creates an environment for a biotaphy command to be run with "
    echo "user-configured arguments in a docker container."
    echo "the <cmd> argument can be one of:"
    for i in "${!COMMANDS[@]}"; do
        echo "      ${COMMANDS[$i]}"
    done
    echo "the <config_file> argument must be the full path to a JSON file"
    echo "containing command-specific arguments"
    echo ""
    exit 0
}

# -----------------------------------------------------------
set_defaults() {
    IMAGE_NAME="tutor"
    CONTAINER_NAME="tutor_container"
    IN_VOLUME="data"
    OUT_VOLUME="output"

    # Relative host config directory mapped to container config directory
    VOLUME_MOUNT="/volumes"

    if [ ! -z "$HOST_CONFIG_FILE" ] ; then
        if [ ! -f "$HOST_CONFIG_FILE" ] ; then
            echo "File $HOST_CONFIG_FILE does not exist"
            exit 0
        else
            host_dir="$IN_VOLUME/config"
            container_dir="$VOLUME_MOUNT/$host_dir"
            CONTAINER_CONFIG_FILE=$(echo $HOST_CONFIG_FILE | sed "s:^$host_dir:$container_dir:g")
            echo "$CONTAINER_CONFIG_FILE"
        fi
    fi

    LOG=/tmp/$CMD.log
    if [ -f "$LOG" ] ; then
        /usr/bin/rm "$LOG"
    fi
    touch "$LOG"
}


# -----------------------------------------------------------
build_image() {
    # Build and name an image from Dockerfile in this directory
    image_count=$(docker image ls | grep $IMAGE_NAME |  wc -l )
    if [ $image_count -eq 0 ]; then
        docker build . -t $IMAGE_NAME
    else
        echo " - Image $IMAGE_NAME is already built"  | tee -a "$LOG"
    fi
}


## -----------------------------------------------------------
#create_envfile() {
#    envfile="./.env"
#    if [ -f "$envfile" ] ; then
#        /usr/bin/rm "$envfile"
#    fi
#    touch "$envfile"
#
#    echo " - Created environment to run:"  | tee -a "$LOG"
#    echo "        with command ${CMD}"  | tee -a "$LOG"
#
#    echo "command=${CMD}"  >> "$envfile"
#    if [ ! "$CONTAINER_CONFIG_FILE" ]  ; then
#        echo "        without a configuration file argument"  | tee -a "$LOG"
#    else
#        echo "config_file=${CONTAINER_CONFIG_FILE}"  >> "$envfile"
#        echo "        and config_file ${CONTAINER_CONFIG_FILE}"  | tee -a "$LOG"
#    fi
#}


## -----------------------------------------------------------
#create_volumes() {
#    # Create a named volume for use by any container
#    volumes=($IN_VOLUME $OUT_VOLUME)
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
create_volumes() {
    # Create named RO input volume for use by any container
    ro_vol_exists=$(docker volume ls | grep $IN_VOLUME | wc -l )
    if [ "$ro_vol_exists" == "0" ]; then
        docker volume create $IN_VOLUME
    else
        echo " - Volume $IN_VOLUME is already created"  | tee -a "$LOG"
    fi
    # Create named RW output volume for use by any container
    rw_vol_exists=$(docker volume ls | grep $OUT_VOLUME | wc -l )
    if [ "$rw_vol_exists" == "0" ]; then
        docker volume create $OUT_VOLUME
    else
        echo " - Volume $OUT_VOLUME is already created"  | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
#docker run -td --name tutor_container -v data:/volumes/data:ro -v output:/volumes/output tutor bash
start_container() {
    # Find running container
    container_count=$(docker ps | grep $CONTAINER_NAME |  wc -l )
    if [ "$container_count" -ne 1 ]; then
        build_image
        # Option string for volumes
        # TODO: after debugging, add read-only back to data volume
        vol_opts="--volume ${IN_VOLUME}:${VOLUME_MOUNT}/${IN_VOLUME} \
                  --volume ${OUT_VOLUME}:${VOLUME_MOUNT}/${OUT_VOLUME}"
        # Start the container, leaving it up
        echo " - Start container $CONTAINER_NAME from $IMAGE_NAME" | tee -a "$LOG"
        docker run -td --name ${CONTAINER_NAME}  ${vol_opts}  ${IMAGE_NAME}  bash
    else
        echo " - Container $CONTAINER_NAME is running" | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
execute_process() {
    start_container
    # Command to execute in container
    command="${CMD} --config_file=${CONTAINER_CONFIG_FILE}"
    echo " - Execute '${command}' on container $CONTAINER_NAME" | tee -a "$LOG"
    # Run the command in the container
    docker exec -it ${CONTAINER_NAME} ${command}
}


# -----------------------------------------------------------
save_outputs() {
    # TODO: determine if bind-mount is more efficient than this named-volume
    start_container
    # Copy container output directory to host (no wildcards)
    # If directory does not exist, create, then add contents
    echo " - Copy outputs from $OUT_VOLUME to $IN_VOLUME" | tee -a "$LOG"
    docker cp ${CONTAINER_NAME}:${VOLUME_MOUNT}/${OUT_VOLUME}  ./${IN_VOLUME}/
}


# -----------------------------------------------------------
remove_container() {
    # Find container, running or stopped
    container_count=$(docker ps -a | grep $CONTAINER_NAME |  wc -l )
    if [ $container_count -eq 1 ]; then
        echo " - Stop container $CONTAINER_NAME" | tee -a "$LOG"
        docker stop $CONTAINER_NAME
        echo " - Remove container $CONTAINER_NAME" | tee -a "$LOG"
        docker container rm $CONTAINER_NAME
    else
        echo " - Container $CONTAINER_NAME is not running" | tee -a "$LOG"
    fi
}

# -----------------------------------------------------------
list_output_volume_contents() {
    # Find an image, start it with output volume, check contents
    start_container
    echo " - List output volume contents $CONTAINER_NAME" | tee -a "$LOG"
    docker exec -it $CONTAINER_NAME ls -lahtr ${VOLUME_MOUNT}/${OUT_VOLUME}
}

# -----------------------------------------------------------
list_output_host_contents() {
    # Find an image, start it with output volume, check contents
    echo " - List host output directory contents " | tee -a "$LOG"
    ls -lahtr ${IN_VOLUME}/${OUT_VOLUME}
}

# -----------------------------------------------------------
start_console() {
    # Create, connect to command line
    start_container
    echo " - Execute shell on $CONTAINER_NAME" | tee -a "$LOG"
    docker exec -it $CONTAINER_NAME bash
}

# -----------------------------------------------------------
time_stamp () {
    echo "$1" $(/bin/date) | tee -a "$LOG"
}


# -----------------------------------------------------------
####### Main #######
COMMANDS=(\
"list_commands"  "build_grid"  "calculate_pam_stats" "encode_layers"   \
"split_occurrence_data"  "wrangle_species_list"  "wrangle_occurrences"  "wrangle_tree" \
"cleanup"  "list_outputs")

CMD=$1
HOST_CONFIG_FILE=$2
arg_count=$#

set_defaults
time_stamp "# Start"
echo ""

# Arguments: none
if [ $arg_count -eq 0 ]; then
    usage
# Arguments: command
elif [ $arg_count -eq 1 ]; then
    if [ "$CMD" == "list_commands" ] ; then
        usage
    elif [ "$CMD" == "list_outputs" ] ; then
        list_output_volume_contents
        remove_container
    elif [ "$CMD" == "test" ]; then
        list_output_volume_contents
        remove_container
        start_console
        remove_container
    elif [ "$CMD" == "cleanup" ]; then
        docker system prune -f --all --volumes
    else
        usage
    fi
# Arguments: command, config file
else
    if [[ " ${COMMANDS[*]} " =~  ${CMD}  ]]; then
        echo "Container command: $CMD --config_file=$CONTAINER_CONFIG_FILE" | tee -a "$LOG"
        create_volumes
        start_container
        execute_process
        save_outputs
        list_output_host_contents
        remove_container
    else
        echo "Unrecognized command: $CMD"
        usage
    fi
fi

time_stamp "# End"
