# Ubuntu Docker image with nginx wstunnel netcat

Use supervisor manage nginx wstunnel(https://github.com/erebe/wstunnel) and netcat.

root password: root!

Example:

    #server
    wstunnel -L 1111:127.0.0.1:10022 ws://server --upgradePathPrefix wstunnel

    #client
    nc 127.0.0.1 12345
    ls

SSH can not work on heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)
