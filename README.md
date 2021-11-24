# Ubuntu Docker image with nginx wstunnel sshd

Use supervisor manage nginx wstunnel(https://github.com/erebe/wstunnel) and sshd.

root password: root!

Example:

    #server
    wstunnel -L 1111:127.0.0.1:10022 ws://server --upgradePathPrefix wstunnel

    #client
    ssh -p 1111 root@localhost

SSH can not work on heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)
