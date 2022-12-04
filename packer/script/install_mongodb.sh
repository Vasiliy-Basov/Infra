#!/bin/bash
# Installing Mongodb
curl -fsSL https://www.mongodb.org/static/pgp/server-3.2.asc | apt-key add -
# curl без опций curl выполняет HTTP-запрос get и отображает статическое содержимое страницы
# -f --fail не выдавать вывод в случае ошибки
# -s --silent тихий режим
# -S когда используется вместе с -s показывет ошибки если fails
# -L -- location Если Http сервер сообщает что страница перемещена в новую локацию curl переделает запрос на новую локацию (redirection)
# apt-key add добавляет доверенный ключ в репозиторий.
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
# tee — команда, выводит на экран, или же перенаправляет выходной материал команды и копирует его в файл или в переменную
apt update
apt install -y mongodb-org
systemctl start mongod
systemctl enable mongod
