#!/bin/bash
# reads and executes commands from filename in the current shell environment
source set_run.sh


echo "=============="
echo "Containername: " $my_container_name
echo "=============="
echo "Acces running container in CLI"
echo "=============="

docker exec -it $my_container_name /bin/bash


