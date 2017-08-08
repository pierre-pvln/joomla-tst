#!/bin/bash

# reads and executes commands from filename in the current shell environment
source set_bld.sh
source set_run.sh

echo "==============="
echo "Info:           Connect to 192.168.2.8 in browser" 
echo "==============="

# inspiration: https://stackoverflow.com/questions/38576337/execute-bash-command-if-docker-container-does-not-exist
#
if [ ! "$(docker ps -q -f name=$my_container_name)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=$my_container_name)" ]; then
        # cleanup container first
        docker rm $my_container_name
    fi
    # run your container
    docker run --name $my_container_name -it -p 80:80 $my_build_name
fi
