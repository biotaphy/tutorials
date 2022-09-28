#!/bin/bash
#
# This script calls docker commands to create an image, volumes, start a container from
# the image, execute commands in that container, then copy outputs to the local
# filesystem.
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
    # Commands that are substrings of other commands will match the superstring and
    # possibly print the wrong Usage string.
    config_required=(
    "build_grid"  "calculate_pam_stats" "encode_layers"  "split_occurrence_data"
    "wrangle_species_list"  "wrangle_occurrences"  "wrangle_tree"
    )
    echo ""
    echo "Usage: $0 <cmd> "
    echo "   or:  $0 <cmd>  <parameters_file>"
    echo ""
    echo "This script creates an environment for a biotaphy command to be run with "
    echo "user-configured arguments in a docker container."
    echo "the <cmd> argument can be one of:"
    for i in "${!COMMANDS[@]}"; do
        if [[ " ${config_required[*]} " =~  ${COMMANDS[$i]}  ]] ; then
            echo "      ${COMMANDS[$i]}   <parameters_file>"
        else
            echo "      ${COMMANDS[$i]}"
        fi
    done
    echo "and the <parameters_file> argument must be the full path to a JSON file"
    echo "containing command-specific arguments"
    echo ""
    exit 0
}

# -----------------------------------------------------------
set_defaults() {
    IMAGE_NAME="tutor"
    CONTAINER_NAME="tutor_container"
    VOLUME_MOUNT="/volumes"
    IN_VOLUME="data"
    ENV_VOLUME="env"
    OUT_VOLUME="output"
    VOLUME_SAVE_LABEL="saveme"
    VOLUME_DISCARD_LABEL="discard"

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
build_image_fill_data() {
    # Build and name an image from Dockerfile in this directory
    # This build also populates the data and env volumes
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


# -----------------------------------------------------------
create_volumes() {
    # Create named RO input volumes for use by any container
    # Small input data, part of repository
    input_vol_exists=$(docker volume ls | grep $IN_VOLUME | wc -l )
    if [ "$input_vol_exists" == "0" ]; then
        echo " - Create volume $IN_VOLUME"  | tee -a "$LOG"
        docker volume create --label=$VOLUME_DISCARD_LABEL $IN_VOLUME
    else
        echo " - Volume $IN_VOLUME is already created"  | tee -a "$LOG"
    fi
    # Large environmental data, external to repository
    env_vol_exists=$(docker volume ls | grep $ENV_VOLUME | wc -l )
    if [ "$env_vol_exists" == "0" ]; then
        echo " - Create volume $ENV_VOLUME"  | tee -a "$LOG"
        docker volume create --label=$VOLUME_SAVE_LABEL $ENV_VOLUME
    else
        echo " - Volume $ENV_VOLUME is already created"  | tee -a "$LOG"
    fi
    # Create named RW output volume for use by any container
    rw_vol_exists=$(docker volume ls | grep $OUT_VOLUME | wc -l )
    if [ "$rw_vol_exists" == "0" ]; then
        echo " - Create volume $OUT_VOLUME"  | tee -a "$LOG"
        docker volume create --label=$VOLUME_SAVE_LABEL $OUT_VOLUME
    else
        echo " - Volume $OUT_VOLUME is already created"  | tee -a "$LOG"
    fi
}


# -----------------------------------------------------------
#docker run -td --name tutor_container -v data:/volumes/data:ro -v env:/volumes/env: -v output:/volumes/output tutor bash
start_container() {
    # Find running container
    container_count=$(docker ps | grep $CONTAINER_NAME |  wc -l )
    if [ "$container_count" -ne 1 ]; then
        build_image_fill_data
        # Option string for volumes
        # TODO: after debugging, add read-only back to data volume
        vol_opts="--volume ${IN_VOLUME}:${VOLUME_MOUNT}/${IN_VOLUME} \
                  --volume ${ENV_VOLUME}:${VOLUME_MOUNT}/${ENV_VOLUME} \
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
execute_python_process() {
    command_path=$1
    start_container
    # Command to execute in container
    command="python3 ${command_path}/${CMD}.py --config_file=${CONTAINER_CONFIG_FILE}"
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
list_all_volume_contents() {
    # Find an image, start it with output volume, check contents
    start_container
    echo " - List volume contents $CONTAINER_NAME" | tee -a "$LOG"
    docker exec -it $CONTAINER_NAME ls -lahtr ${VOLUME_MOUNT}
    echo "    - Volume $ENV_VOLUME" | tee -a "$LOG"
    docker exec -it $CONTAINER_NAME ls -lahtr ${VOLUME_MOUNT}/${ENV_VOLUME}
    echo "    - Volume $IN_VOLUME" | tee -a "$LOG"
    docker exec -it $CONTAINER_NAME ls -lahtr ${VOLUME_MOUNT}/${IN_VOLUME}
    echo "    - Volume $OUT_VOLUME" | tee -a "$LOG"
    docker exec -it $CONTAINER_NAME ls -lahtr ${VOLUME_MOUNT}/${OUT_VOLUME}
}

# -----------------------------------------------------------
open_container_shell() {
    # Find an image, start it with output volume, check contents
    start_container
    echo " - Connect to $CONTAINER_NAME" | tee -a "$LOG"
    docker exec -it $CONTAINER_NAME bash
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
COMMANDS=(
"list_commands"  "build_image"  "cleanup"  "do_little"  "list_outputs"  "list_volumes"  "rebuild_data"
"create_sdm" "build_grid"  "calculate_pam_stats" "encode_layers"
"split_occurrence_data" "wrangle_species_list"  "wrangle_occurrences"  "wrangle_tree"
)

CMD=$1
HOST_CONFIG_FILE=$2
arg_count=$#
command_path=/git/lmpy/lmpy/tools

set_defaults
time_stamp "# Start"
echo ""

# Arguments: none
if [ $arg_count -eq 0 ]; then
    usage
# Arguments: command
elif [ $arg_count -eq 1 ]; then
    if [ "$CMD" == "cleanup" ] ; then
        docker system prune -f --all
        docker volume prune --filter "label!=saveme"
    elif [ "$CMD" == "cleanup_most" ] ; then
        docker system prune -f --all
        docker volume rm ${IN_VOLUME}
        docker volume rm ${OUT_VOLUME}
    elif [ "$CMD" == "cleanup_all" ] ; then
        docker system prune -f --all --volumes
    elif [ "$CMD" == "open" ] ; then
        open_container_shell
    elif [ "$CMD" == "list_commands" ] ; then
        usage
    elif [ "$CMD" == "list_outputs" ] ; then
        list_output_volume_contents
        start_container
        remove_container
    elif [ "$CMD" == "list_volumes" ] ; then
        list_all_volume_contents
        start_container
        remove_container
    elif [ "$CMD" == "build_image" ] || [ "$CMD" == "rebuild_data" ] ; then
        docker system prune -f --all
        docker volume rm ${IN_VOLUME}
        docker volume rm ${OUT_VOLUME}
        echo "System build will take approximately 5 minutes ..." | tee -a "$LOG"
        create_volumes
        build_image_fill_data
    elif [ "$CMD" == "test" ]; then
        list_output_volume_contents
        remove_container
        start_console
        remove_container
    else
        usage
    fi
# Arguments: command, config file
else
    if [[ " ${COMMANDS[*]} " =~  ${CMD}  ]]; then
        create_volumes
        build_image_fill_data
        start_container
        if [ "$CMD" == "create_sdm" ] ; then
            echo "Container python command:"  | tee -a "$LOG"
            echo "   $command_path/$CMD.py --config_file=$CONTAINER_CONFIG_FILE" | tee -a "$LOG"
            execute_python_process $command_path
            echo "env vol ${VOLUME_MOUNT}/${ENV_VOLUME}:"
            docker exec -it $CONTAINER_NAME ls -lahtr ${VOLUME_MOUNT}/${ENV_VOLUME}
        else
            echo "Container command: $CMD --config_file=$CONTAINER_CONFIG_FILE" | tee -a "$LOG"
            execute_process
        fi
        save_outputs
#        list_all_volume_contents
#        list_output_host_contents
        remove_container
    else
        echo "Unrecognized command: $CMD"
        usage
    fi
fi

time_stamp "# End"
