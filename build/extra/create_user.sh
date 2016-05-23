#!/bin/bash
# File : user_gen.sh
# Author : Chandrasekaran <chandrasekaran@thebw.in>
# Description : This script creates new linux user account and creates new SSH Key for it.
#
#
# Checks current user is root or not.
#
if [[ `whoami` != 'root' ]];then
  echo "Invalid '`whoami`' to run this script. Please login as root"
  exit 1
fi
#
# Gets values from the command line
#
if [[ ! $# == 2 ]];then
  echo "Usage: $0 <username> <password>"
  exit
else
  username=$1
  password=$2
fi

#
# Checks current working directory is /opt/. Otherwise we will get 
# some permission issue while running this script.
#
if [[ `pwd` != '/opt/' ]];then
  echo "Unable to run this script. Please move script file into /opt directory and try again!."
  exit 1
fi
#
# Checks given user is exists or not.
# If user does not exists in the system,
# then creates new user account with sudo permission
#
if [[ `id -u $username 2> /dev/null` ]]; then
  echo "$username named user already exists in the system."
  exit 1;
 else
  useradd -m -s /bin/bash -G sudo,adm `echo $username`
  #Set password for new user
  # i.e) echo username:paswword | chpasswd
  echo $username:$password | chpasswd
  #Checks ssh key already exists in the system or not. Then it creates new ssh key
  if [[ ! -f '/home/'`echo $username`'/.ssh/id_rsa' ]];then
    su - `echo $username` -c 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa'
  else
    echo "SSH Key already exists."
  fi
fi
#
# Copies SSH public key and Creates DockerBase Image
#
if [[ -f '/home/'`echo $username`'/.ssh/id_rsa.pub' ]];then
  cp /home/`echo $username`/.ssh/id_rsa.pub access_key.pub
else
  echo "Public Key does not exists. Recreate ssh keys by using ssh-keygen command."
  exit 1
fi
#
# Build Docker customized base image
#
echo -n "Enter custom base image name that you want to create:"
read imagename
docker build -t `echo $imagename` .
#
# Removes the copied access_key.pub file
# 
if [[ -f 'access_key.pub' ]];then
  rm -f access_key.pub
  echo "Removed access_key.pub file."
fi
