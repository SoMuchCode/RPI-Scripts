# reverse-ssh.sh
Script to easily setup a reverse-ssh connection.

## Remote Box
You will want this to run all the time and restart at reboot, maybe use crontab to ensure this happens.

Syntax:

`./reverse_ssh.sh -c <ip of handler> <port> <reconnect time in seconds> <server user>`
	
## Server Setup (listener)
This computer can be your server, or a publicly accessable server. If you ssh into the server and run the "./reverse-ssh.sh -s ..." command, you will then be connected to the remote box.
On my server I will set up the handler with:

`./reverse-ssh.sh -s <my servers external ip> <port> <remote box user> <server user>`

## Notes
The default server user name is: pi

The default remote box user name is: root

Since the remote box will be able to login to your server via ssh with no password, be sure and create a user with no privileges on the server for this task.

## Example
In my example, the server (listener) is at 192.168.1.9, 
but it could be any address; for example: http://yourserver.com.

The server is logged in with the user: pi

The remote box is logged into the user: root

Therefore, on the remote box we run:
`./reverse-ssh.sh -c 192.168.1.9 33332 10 pi`

And on the server:
(again, you can SSH into the server from a third box
and execute this.)
`./reverse-ssh.sh -s 192.168.1.9 33332 root pi`

If the remote box has no SSH keys, they will be generated and `ssh-copy-id pi@192.168.1.9` will be run from the remote box to exchange the key.
You can also run 

# Enable Autologin
If we want to autologin we can do the opposite from the server; once we are connected, copy the server's public key from `~/.ssh/id_rsa.pub`, to `~/.ssh/authorized_keys` on the remote box.
`nano ~/.ssh/authorized_keys`
and paste your server's public key.

***
Forked from: pry0cc/reverse-ssh.sh https://gist.github.com/pry0cc
