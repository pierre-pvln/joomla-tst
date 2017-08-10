#!/bin/bash

# set excecute mode for shell scripts 
chmod +x *.sh

# reads and executes commands from filename in the current shell environment
source set_bld.sh
source set_apache2.sh
source set_mysql.sh

env

# use environment variables during build
echo docker build --tag $my_build_name --build-arg my_apache2_servername=$servername --build-arg my_apache2_sitename=$websitename --build-arg my_mysql-server_root_password=$mysql_root_pw ../
docker build --tag $my_build_name --build-arg my_apache2_servername=$servername --build-arg my_apache2_sitename=$websitename --build-arg my_mysql-server_root_password=$mysql_root_pw ../
