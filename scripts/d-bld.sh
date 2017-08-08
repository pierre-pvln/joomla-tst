#!/bin/bash

# reads and executes commands from filename in the current shell environment
source set_bld.sh
source set_apache2.sh

# use environment variables during build
docker build -t \
       --build-arg \
       my_apache_servername=$servername \
	   my_apache2_sitename=$websitename \
       $my_build_name ../Dockerfile
