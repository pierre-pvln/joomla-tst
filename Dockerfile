FROM resin/rpi-raspbian

MAINTAINER Pierre Veelen <pierre@pvln.nl>

# ==========================================
# START OF INSTALLING UTILITIES AND DEFAULTS
# ==========================================

#RUN sudo apt-get update && sudo apt-get install -y \
#     apt-utils && \
#	 sudo apt-get clean && \ 
#	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	 
RUN sudo apt-get update && sudo apt-get install -y \
     apt-utils \
	 curl \
     wget \
     git && \
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

# Install apache2 and cleanup afterwards
#
RUN sudo apt-get update && sudo apt-get install -y \
     apache2 && \
    sudo apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enable apache mods.
#RUN a2enmod rewrite

# Manually set up the apache environment variables
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
#ADD ./site/default /var/www/site
ADD ./site/default /var/www/$my_apache2_sitename

# set ownership of files
#
#RUN chown -Rf $APACHE_RUN_USER:$APACHE_RUN_GROUP /var/www/site
RUN chown -Rf $APACHE_RUN_USER:$APACHE_RUN_GROUP /var/www/$my_apache2_sitename

# Update the default apache site with the config we created.
ADD ./configs/apache2-config.conf /etc/apache2/sites-enabled/000-default.conf

# =========================
# END OF INSTALLING APACHE2
# =========================

# ========================
# START OF INSTALLING PHP5
# ========================

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
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

# Enable apache mods for PHP.
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

RUN { \
        echo mysql-server-5.5 mysql-server/root_password password 'root'; \
        echo mysql-server-5.5 mysql-server/root_password_again password 'root'; \
    } | sudo debconf-set-selections \
    && sudo apt-get update && sudo apt-get install -y \
        mysql-server && \
    sudo apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#
# TODO: include mysql_secure_installation in container 
#
#RUN sudo apt-get update && \
#    sudo mysql_secure_installation && \
#    sudo apt-get clean && \ 
#    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
# =======================
# END OF INSTALLING MYSQL
# =======================

# ======================================
# START OF INSTALLING JOOMLA! RESTORE FILES
# ======================================

# Copy kickstart files to website
ADD ./site/kickstart /var/www/site

# ./site/backup should be empty
ADD ./site/backup /var/www/site

# set ownership of files
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
