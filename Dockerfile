FROM resin/rpi-raspbian

MAINTAINER Pierre Veelen <pierre@pvln.nl>

# ==========================================
# START OF INSTALLING UTILITIES AND DEFAULTS
# ==========================================

RUN sudo apt-get update && sudo apt-get install -y \
    apt-utils && \
    sudo apt-get clean && \ 
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	 
# =============================
# END OF UTILITIES AND DEFAULTS
# =============================

# ===========================
# START OF INSTALLING APACHE2
# ===========================
#
# Inspiration: https://writing.pupius.co.uk/apache-and-php-on-docker-44faef716150
#

# get variables from commandline and set default values
ARG my_apache2_servername='def-server-name'
ARG my_apache2_sitename='def-site-name'

# Install apache2 and cleanup afterwards
#
RUN sudo apt-get update && sudo apt-get install -y \
     apache2 && \
    sudo apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enable apache mods.
RUN a2enmod rewrite

# Manually set up the apache environment variables
#
# TODO: Find a way to use variables from script
#
ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_LOCK_DIR=/var/lock/apache2 \
    APACHE_PID_FILE=/var/run/apache2.pid 

# Expose apache2 on port 80
#
EXPOSE 80

# Copy this repo into place
#
ADD ./site/default /var/www/$my_apache2_sitename

# set ownership of files
#
RUN chown -Rf $APACHE_RUN_USER:$APACHE_RUN_GROUP /var/www/$my_apache2_sitename

# Update the default apache site with the config we created.
#
ADD ./configs/apache2-config.conf /etc/apache2/sites-enabled/000-default.conf

# Change folder to sitename -> change  var/www/site to var/www/$my_apache2_sitename
# sed -i "s/TextFrom/TextTo/" inWhichFile
# \/ is used to escape the / in the file path
#
RUN sed -i "s/var\/www\/site/var\/www\/$my_apache2_sitename/" /etc/apache2/sites-enabled/000-default.conf

# TODO CHANGE WEBSITE SERVERNAME TO PREVENT WARNING

# =========================
# END OF INSTALLING APACHE2
# =========================

# ========================
# START OF INSTALLING PHP5
# ========================

# Install php5 and cleanup afterwards
#
RUN sudo apt-get update &&  sudo apt-get install -y \
	 libapache2-mod-php5 \
	 php5 \ 
	 php-pear \
	 php5-xcache \
	 php5-mysql \
	 php5-curl \
	 php5-gd && \
    sudo apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Update the PHP.ini file, enable <? ?> tags and quieten logging.
#
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

# Enable apache mods for PHP.
#
RUN a2enmod php5

# ======================
# END OF INSTALLING PHP5
# ======================

# =========================
# START OF INSTALLING MYSQL
# =========================
#
# Inspiration: https://stackoverflow.com/questions/32145650/how-to-set-mysql-username-in-dockerfile/32146887#32146887
#

##ARG my_mysql_server_root_password='def-root'

#DEBUG
#=====
# save info to file
##RUN echo $my_mysql_server_root_password > /root/test.txt

#RUN { \
#        echo mysql-server-5.5 mysql-server/root_password password $my_mysql_server_root_password; \
#        echo mysql-server-5.5 mysql-server/root_password_again password $my_mysql_server_root_password; \
#    } | sudo debconf-set-selections \
#    && sudo apt-get update && sudo apt-get install -y \
#        mysql-server && \
#    sudo apt-get clean && \ 
#    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install mysql-server and cleanup afterwards
#
RUN { \
        echo mysql-server-5.5 mysql-server/root_password password 'root'; \
        echo mysql-server-5.5 mysql-server/root_password_again password 'root'; \
    } | sudo debconf-set-selections \
    && sudo apt-get update && sudo apt-get install -y \
        mysql-server && \
    sudo apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start MYSQL
RUN chown -R mysql /var/lib/mysql
RUN chgrp -R mysql /var/lib/mysql
RUN service mysql start# 

#
# TODO: include mysql_secure_installation in container 
#
#RUN sudo apt-get update && \
#    sudo mysql_secure_installation && \
#    sudo apt-get clean && \ 
#    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
#TEST
#====
# Copy mySQL testscript to home directory
#
ADD ./site/testscripts /root
RUN chmod +x /root/*.sh

# =======================
# END OF INSTALLING MYSQL
# =======================

# ======================================
# START OF INSTALLING JOOMLA! RESTORE FILES
# ======================================

# Copy kickstart files to website
#
ADD ./site/kickstart /var/www/$my_apache2_sitename

# Set ownership of files or kickstart will not work properly
#
RUN chown -Rf $APACHE_RUN_USER:$APACHE_RUN_GROUP /var/www/$my_apache2_sitename

# ======================================
# END OF INSTALLING JOOMLA! RESTORE FILES
# ======================================

#
# ENTRYPOINT & CMD
# ======
# Cancel pre-defined start-up instruction and allow us to use our own.
ENTRYPOINT []

# By default start up apache in the foreground, override with /bin/bash for interative.
#CMD /usr/sbin/apache2ctl -D FOREGROUND

CMD /bin/bash

