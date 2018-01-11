#!/bin/bash
# reverse-ssh.sh
# # Modified by SoMuchCode/YetAnotherCoder
# https://github.com/SoMuchCode/RPI-Scripts
# Forked from: pry0cc/reverse-ssh.sh https://gist.github.com/pry0cc
# Requires: netcat

# Server Setup (listener)
# This computer can be your server, or a publicly accessable server
# If you ssh into the server and run the "./reverse_ssh.ssh -s ..." command
# you will then be connected to the remote box.
# On my server I will set up the handler with
# ./reverse_ssh.ssh -s <my servers external ip> <port> <remote box user> <server user>
# ./reverse-ssh.sh -s 192.168.1.45 33333 root pi

# Remote Box
# You will want this to run all the time and restart at reboot, maybe use crontab
# The syntax works like this.
# ./reverse_ssh.sh -c <ip of handler> <port> <reconnect time in seconds> <server user>
# ./reverse-ssh.sh -c 192.168.1.45 33333 10 pi

# In my example, the server (listener) is at 192.168.1.45, 
# but it could be any address, like: http://yourserver.com
#
# The server is logged in with the user: pi
# And the remote box is logged into the user: root
#
# Therefore, on the remote box we run:
# ./reverse-ssh.sh -c 192.168.1.45 33333 10 pi
#
# Run this on the server
# (again, you can SSH into the server from a third box and execute this.)
# ./reverse-ssh.sh -s 192.168.1.45 33333 root pi

# If the remote box has no SSH keys, they will be generated and 
# ssh-copy-id pi@192.168.1.45 will be run from the remote box to exchange the key.
# You should probably connect these before you deploy them...


# user name on server / listener
user=pi
# user name on remote box
remoteuser=root

function display_help {
	echo "reverse-ssh.sh, A script to easily setup a reverse-ssh connection. It can function as either a host or a client to facilitate this connection."
	echo "USAGE: reverse-ssh.sh -s <server external ip> <port> <remote box user> <server user>"
	echo "reverse_ssh.sh -c <ip> <port> <reconnect time in seconds> <server user>"
	exit
}

if ! [ $1 ] || ! [ $2 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	display_help
fi

mode=$1
local_ip=$2
local_port=33333

if [ $3 ]; then
	local_port=$3
fi

if [ $mode == "-s" ]; then
	if [ $4 ]; then
		remoteuser=$4
	fi
	if [ $5 ]; then
		user=$5
	fi
else
	if [ $4 ]; then
		reconnect_time=$4
	else
		reconnect_time=10
	fi
	if [ $5 ]; then
		user=$5
	fi
fi

function serv_ins {
        echo "ssh -N -R $local_port:localhost:22 $user@$local_ip" | sudo timeout 2 nc -l -p $local_port
}

if [ $mode == "-s" ]
        then
        while [ $(sudo netstat -tupln | grep :$local_port | grep sshd | wc -l) = 0 ]
                do
                        serv_ins
                done
                echo "[*] Connection established"
                echo "[+] Authenticating to reverse_ssh client"
                ssh -p $local_port $remoteuser@localhost
elif [ $mode == "-c" ]
        then
        if [ ! -f ~/.ssh/id_rsa.pub ]
                then
                echo "No SSH keypair found... Generating one."
                ssh-keygen
                ssh-copy-id $user@$local_ip
        fi
        echo "Checking for Handler interaction every $reconnect_time seconds"
        while true
        do
                echo "Attempting connection..."
                connect=$(nc $local_ip $local_port)
                echo $connect | bash
                sleep $reconnect_time
        done
fi
exit 0
