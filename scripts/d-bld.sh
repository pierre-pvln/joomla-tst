#!/bin/bash

# reads and executes commands from filename in the current shell environment
source set_bld.sh
source set_apache2.sh

echo "==========="
echo "Buildname: " $my_build_name
echo "==========="

docker build -t  $my_build_name ../
