#!/bin/bash
# File :create_image.sh
# Author : Chandrasekaran "<chandrasekaran@thebw.in>"
# Description: Creates Syclops Docker images.
#
SYCLOPS_BASE="syclops/syclops_base"
SYCLOPS_DB="syclops/syclops_db"
SYCLOPS_TRM="syclops/syclops_trm"
SYCLOPS_UI="syclops/syclops_ui"
TERMINAL_SRC="./terminal/src/gateone"
UI_SRC="./ui/src/syclops"
#
# User Validation
#
if [[ $(whoami) != 'root' ]];then
    echo "You are not authorized user to run this script. Please try as a sudo user"
    exit 1
fi
#
# Installs Docker latest version
#
docker_status=$(type -P docker &>/dev/null && echo 1 || echo "")
if [[ -z $docker_status ]]; then
    curl -s https://get.docker.io/ubuntu/ | sudo sh
    echo "$(docker version) installation success."
fi
#
# Checks Docker installation status
#
if [[ $? != 0 ]];then
    echo "Docker installation faild"
    exit 1
fi
#
# Checks  Syclops Terminal source file
#
if [[ ! -d $TERMINAL_SRC ]];then
    echo "Download Terminal source and Syclops terminal plugin and put it in this location ./terminal/src/gateone"
    exit 0
fi
#
# Checks ui source file
#
if [[ ! -d $UI_SRC ]];then
    echo "Download Syclops source and put it in this location ./ui/src/syclops"
    exit 0
fi
#
# Creates Syclops Base image
#
docker build -t $SYCLOPS_BASE .
#
# Creates Syclops Database image
#
if [[ -d ./database ]];then
    docker build -t $SYCLOPS_DB ./database
else
    echo "database folder is not found"
    exit 1
fi
#
# Creates Syclops Terminal image
#
if [[ -d ./terminal ]];then
    if [[ -d $TERMINAL_SRC ]];then
        docker build -t $SYCLOPS_TRM ./terminal
    else
        echo "Terminal source is not found in this location $TERMINAL_SRC"
        echo "Please download terminal source code and then continue"
        exit 1
    fi
 else 
    echo "terminal folder is not found"
    exit 1
fi
#
# Creates Syclops UI image
#
if [[ -d ./ui ]];then
    if [[ -d $UI_SRC ]];then
        docker build -t $SYCLOPS_UI ./ui
    else
        echo "UI source is not found in this location $UI_SRC"
        echo "Please download ui source code and place it in this location ./ui/src/syclops and continue"
        exit 1
    fi
 else 
    echo "ui folder is not found"
    exit 1
fi
