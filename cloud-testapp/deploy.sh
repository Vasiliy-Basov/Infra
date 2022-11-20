#!/bin/bash
# Since instances run startup scripts as root, and we don't want our web-server to have such privileges,
# we need to use either runuser or su to workaround that.
# For reference:
# https://www.cyberciti.biz/open-source/command-line-hacks/linux-run-command-as-different-user/
runuser -l baggurd -c 'git clone -b monolith https://github.com/express42/reddit.git'
runuser -l baggurd -c 'cd reddit && bundle install'
runuser -l baggurd -c 'cd reddit && puma -d'
