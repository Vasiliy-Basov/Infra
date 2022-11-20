#!/bin/bash

apt update
apt install -fy python-setuptools build-essential python-dev python3-pip
update-alternatives --install /usr/bin/python python /usr/bin/python3 10
pip3 install flask psutil

wget https://gist.githubusercontent.com/Nklya/4f8944d99e43b6c44a9767a93daa1592/raw/149ee890f4201ac5ce53888846f6b3e7601be6ba/app.py -O app.py
FLASK_APP=app.py flask run --host=0.0.0.0 --port=80
