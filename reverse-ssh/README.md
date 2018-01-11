# reverse-ssh.sh
Script to easily setup a reverse-ssh connection.

## Remote Box
You will want this to run all the time and restart at reboot, maybe use crontab to ensure this happens.

Syntax:  
`./reverse_ssh.sh -c <ip of handler> <port> <reconnect time in seconds> <server user>`
	
## Server Setup (listener)
This computer can be your server, or a publicly accessable server. If you SSH into the server and run the "./reverse-ssh.sh -s ..." command, you will then be connected to the remote box.

Syntax:  
`./reverse-ssh.sh -s <my servers external ip> <port> <remote box user> <server user>`

## Notes
Since the remote box will be able to login to your server via SSH with no password, be sure and create a user with no privileges (rbash) on the server for this task.

## Usage Example
In my example, the server (listener) is at 192.168.1.9, but it could be any valid address.

The server is logged in with the user: pi  
The remote box is logged into the user: root

Therefore, on the remote box we run:  
`./reverse-ssh.sh -c 192.168.1.9 33332 10 pi`

And on the server: (again, you can SSH into the server from a third box and execute this.)  
`./reverse-ssh.sh -s 192.168.1.9 33332 root pi`

If the remote box has no SSH keys, they will be generated and `ssh-copy-id pi@192.168.1.9` will be run from the remote box to exchange the key.  
You could also run, `scp ~/.ssh/id_rsa.pub testuser@192.168.111.9:.ssh/authorized_keys2` from the remote box to add the key (I chose `authorized_keys2` because scp will overwrite the `authorized_keys` file if it exists.) 

## Enable Autologin
If we want to autologin we can do the opposite from the server; once we are connected, copy the server's public key from `~/.ssh/id_rsa.pub`, to `~/.ssh/authorized_keys` on the remote box.  

## Create A Restricted User on Server

On the server, create a restricted user.  
This account will _only_ be used for Reverse-SSH connections

    sudo ln -s /bin/bash /bin/rbash
    sudo mkdir /home/restricted_folder
    sudo useradd -s /bin/rbash -d /home/restricted_folder testuser
    sudo passwd testuser
    sudo chown testuser:testuser /home/restricted_folder
    cd /home/restricted_folder
    su testuser
    mkdir .ssh
    ssh-keygen -t rsa -b 4096
    exit

Now, on the exfiltration box...
    `scp ~/.ssh/id_rsa.pub testuser@192.168.111.9:.ssh/authorized_keys2`

On the server, where I am actually logged in as the user "Pi", run:
    `./reverse-ssh.sh -s 192.168.111.9 33330 root testuser`

on the remote box, run:
    `./reverse-ssh.sh -c 192.168.111.9 33330 10 testuser`


***
Forked from: pry0cc/reverse-ssh.sh https://gist.github.com/pry0cc
