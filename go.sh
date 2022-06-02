# Variables
IMAGE_NAME="tutor"
CONTAINER_NAME="tutor_container"
IN_VOLUME="data"
OUT_VOLUME="output"
VOLUME_MOUNT="/volumes"
vol_opts="--volume ${IN_VOLUME}:${VOLUME_MOUNT}/${IN_VOLUME} \
          --volume ${OUT_VOLUME}:${VOLUME_MOUNT}/${OUT_VOLUME} "

# Kill, recreate, connect to command line
docker stop $CONTAINER_NAME
docker container rm $CONTAINER_NAME
docker run -td --name $CONTAINER_NAME  ${vol_opts} ${IMAGE_NAME} bash
docker exec -it $CONTAINER_NAME bash

# -----------------------------------------------------------
# In the container, test a command
# -----------------------------------------------------------
split_occurrence_data --config_file /volumes/data/config/split_occurrence_data.json
# -----------------------------------------------------------
# -----------------------------------------------------------

# Kill
docker stop $CONTAINER_NAME
docker container rm $CONTAINER_NAME
