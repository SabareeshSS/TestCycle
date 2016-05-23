#!/bin/bash
if [[ ! -f /var/lib/mysql/ibdata1 ]]; then
    mysql_install_db
    chown -R mysql.mysql /var/lib/mysql
fi
