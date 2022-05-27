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
    container_config_dir="$VOLUME_MOUNT/$host_config_dir"

    if [ ! -f "$HOST_CONFIG_FILE" ] ; then
        echo "File $HOST_CONFIG_FILE does not exist"
        exit 0
    fi

    LOG=/tmp/$CMD.log
    if [ -f "$LOG" ] ; then
        /usr/bin/rm "$LOG"
    fi
    touch "$LOG"
    CONTAINER_CONFIG_FILE=$(echo $HOST_CONFIG_FILE | sed "s:^$host_config_dir:$container_config_dir:g")
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
create_volumes() {
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
build_image() {
    # Build and name an image from Dockerfile in this directory
    image_exists=$(docker image ls | grep $IMAGE_NAME | wc -l )
    if [ "$image_exists" == "0" ]; then
        docker build . -t $IMAGE_NAME
    else
        echo " - Image $IMAGE_NAME is already built"  | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
#docker run -td --name tutor_container -v data:/volumes/data:ro -v output:/volumes/output tutor bash
start_container() {
    container_count=$(docker ps | grep $CONTAINER_NAME |  wc -l )
    if [ $container_count -ne 1 ]; then
        # Option string for volumes
        # TODO: after debugging, add read-only back to data volume
#        vol_opts="--volume ${RO_VOLUME}:${VOLUME_MOUNT}/${RO_VOLUME}:ro \
        vol_opts="--volume ${RO_VOLUME}:${VOLUME_MOUNT}/${RO_VOLUME} \
                  --volume ${RW_VOLUME}:${VOLUME_MOUNT}/${RW_VOLUME}"
        # Start the container, leaving it up
        echo " - Run container $CONTAINER_NAME from image $IMAGE_NAME" | tee -a "$LOG"
        docker run -td --name ${CONTAINER_NAME}  ${vol_opts}  ${IMAGE_NAME}  bash
    else
        echo " - Container $CONTAINER_NAME is already started" | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
#docker exec -it tutor_container ls -lahtr /volumes/output
execute_process() {
    # Command to execute in container; `test` lists directory contents
    if [ $CMD = "test" ]; then
        command="ls -lahtr $VOLUME_MOUNT/$RO_VOLUME/config"
    else
        command="${CMD} --config_file=${CONTAINER_CONFIG_FILE}"
    fi

    container_count=$(docker ps | grep $CONTAINER_NAME |  wc -l )
    if [ $container_count -eq 1 ]; then
        echo " - Execute '${command}' on container $CONTAINER_NAME" | tee -a "$LOG"
        # Run the command in the container
        docker exec -it ${CONTAINER_NAME} ${command}
    else
        echo " - Container $CONTAINER_NAME not running to execute_process" | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
#docker cp tutor_container:/volumes/output  ./data/
save_outputs() {
    # TODO: determine if bind-mount is more efficient than this named-volume
    # Find running container
    container_count=$(docker ps | grep $CONTAINER_NAME |  wc -l )
    if [ $container_count -eq 1 ]; then
        # Copy entire container output directory to host (no wildcards)
        # If directory exists, does not overwrite, just adds contents
        echo " - Copy outputs from container $CONTAINER_NAME" | tee -a "$LOG"
        docker cp ${CONTAINER_NAME}:${VOLUME_MOUNT}/${RW_VOLUME}  ./${RO_VOLUME}/
    else
        echo " - Container $CONTAINER_NAME not running to save_outputs" | tee -a "$LOG"
    fi
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

echo "Container command: $CMD --config_file=$CONTAINER_CONFIG_FILE" | tee -a "$LOG"

if [[ " ${COMMANDS[*]} " =~  ${CMD}  ]]; then
    if [ "$CMD" == "list_commands" ] ; then
        usage
    else
        create_volumes
        build_image
        start_container
        execute_process
        save_outputs
        remove_container
    fi
fi

time_stamp "# End"


docker run -td --name tutor_container -v data:/volumes/data:ro -v output:/volumes/output tutor bash
docker exec -it tutor_container ls -lahtr /volumes/data/config
docker stop tutor_container
docker container rm tutor_container
