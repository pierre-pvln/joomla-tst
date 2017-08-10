#!/bin/bash

# reads and executes commands from filename in the current shell environment
source set_bld.sh
source set_apache2.sh
source set_mysql.sh

# use environment variables during build
docker build --tag $my_build_name \ 
             --build-arg my_apache2_servername=$servername \ 
             --build-arg my_apache2_sitename=$websitename \
			 --build-arg my_mysql-server_root_password=$mysql_root_pw \
			 ../
