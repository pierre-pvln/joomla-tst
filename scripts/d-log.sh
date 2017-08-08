#!/bin/bash

# show logging from from container
source set_run.sh

echo "=============="
echo "Containername: " $my_container_name
echo "=============="

docker logs $my_container_name 
