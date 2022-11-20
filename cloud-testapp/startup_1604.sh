#!/bin/sh
#Setup Ruby
apt update
apt install -y ruby-full ruby-bundler build-essential
# Installing Mongodb
curl -fsSL https://www.mongodb.org/static/pgp/server-3.2.asc | apt-key add -
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
# tee — команда, выводит на экран, или же перенаправляет выходной материал команды и копирует его в файл или в переменную
apt update
apt install -y mongodb-org
systemctl start mongod
systemctl enable mongod
# Since instances run startup scripts as root, and we don't want our web-server to have such privileges,
# we need to use either runuser or su to workaround that.
# For reference:
# https://www.cyberciti.biz/open-source/command-line-hacks/linux-run-command-as-different-user/
runuser -l baggurd -c 'git clone -b monolith https://github.com/express42/reddit.git'
runuser -l baggurd -c 'cd reddit && bundle install'
runuser -l baggurd -c 'cd reddit && puma -d'