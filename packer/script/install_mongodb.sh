#!/bin/bash
# Installing Mongodb
curl -fsSL https://www.mongodb.org/static/pgp/server-3.2.asc | apt-key add -
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
# tee — команда, выводит на экран, или же перенаправляет выходной материал команды и копирует его в файл или в переменную
apt update
apt install -y mongodb-org
systemctl start mongod
systemctl enable mongod