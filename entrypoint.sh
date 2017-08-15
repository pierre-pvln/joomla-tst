# Start MYSQL
# inspiration https://stackoverflow.com/questions/9083408/fatal-error-cant-open-and-lock-privilege-tables-table-mysql-host-doesnt-ex
#
chown -R mysql /var/lib/mysql
chgrp -R mysql /var/lib/mysql
service mysql start

# Create Joomla! entry in database


# Start apache2
#
/usr/sbin/apache2ctl -D FOREGROUND

