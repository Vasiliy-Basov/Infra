#!/bin/sh
runuser -l baggurd -c 'git clone -b monolith https://github.com/express42/reddit.git'
runuser -l baggurd -c 'cd reddit && bundle install'
systemctl enable puma
systemctl start puma