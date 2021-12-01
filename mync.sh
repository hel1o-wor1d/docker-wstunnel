#!/usr/bin/env sh

rm -f /tmp/fmync
mkfifo /tmp/fmync
cat /tmp/fmync | /bin/sh 2>&1 | nc -l 127.0.0.1 10022 >> /tmp/fmync