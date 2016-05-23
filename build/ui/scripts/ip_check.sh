#!/bin/bash 
#get ip address of the container
#pattern=$(ip addr show | awk '{print $2}' | tail -n 1)
#ip=$(echo $pattern | sed -r 's/\/[0-9]+/''/ig')
pattern=$(ifconfig | awk '{print $2}' | head -n 2 | tail -n 1)
ip=$(echo $pattern | sed -r 's/[a-z:]+/''/ig')
#validates the ip address is valid or not
if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
        #checks shared folder is exists or not
        if [[ -d "/share" ]];then
	  		if [[ ! -f "/share/webserver" ]];then
		 		echo $ip > /share/webserver
				old_ip="0"
			else
				old_ip=$(eval echo -e `</share/webserver`)
				echo $ip > /share/webserver
			fi

			if [[ $ip != $old_ip ]];then
				echo "Ip changed: $old_ip to $ip" 
			fi
        else
                echo "Shared folder not found."
        fi
fi
/ip_change.sh
exit 0

