# reverse-ssh.sh
Script to easily setup a reverse-ssh connection.

#Server Setup (listener)
This computer can be your server, or a publicly accessable server
If you ssh into the server and run the "./reverse_ssh.ssh -s ..." command
you will then be connected to the remote box.
On my server I will set up the handler with
	./reverse_ssh.ssh -s <my servers external ip> <the port I want to use> <remote box user>
	./reverse-ssh.sh -s 192.168.1.9 33333 root

#Remote Box
You will want this to run all the time and restart at reboot, maybe use crontab
The syntax works like this.
	./reverse_ssh.sh -c <ip of handler> <port of handler> <reconnect time in seconds> <server user>
	./reverse-ssh.sh -c 192.168.1.9 33333 10 pi

The default server user name is: pi
The default remote box user name is: root

In my example, the server (listener) is at 192.168.1.9, 
but it could be any address, like: http://yourserver.com

The server is logged in with the user: pi
And the remote box is logged into the user: root

Therefore, on the remote box we run:
	./reverse-ssh.sh -c 192.168.1.9 33332 10 pi
	./reverse-ssh.sh -c 192.168.1.9 33332 10 (will actually work)

And later, at your leisure, run this on the server
(again, you can SSH into the server from a third box
and execute this.)
	./reverse-ssh.sh -s 192.168.1.9 33332 root
	./reverse-ssh.sh -s 192.168.1.9 33332 (will actually work)

The first time we connect, ssh-copy-id pi@192.168.1.9
is run from the remote box to exchange the key.

If we want to autologin we can do the opposite from the server
once we are connected, copy the server's public key to 
~/.ssh/authorized_keys on the remote box.
	nano ~/.ssh/authorized_keys
and paste your server's public key.

Forked from: pry0cc/reverse-ssh.sh https://gist.github.com/pry0cc