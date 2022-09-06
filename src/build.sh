#!/bin/sh

set -e
apk update
apk add alpine-sdk python3 python3-dev glib-dev glib-static
python3 -m ensurepip
pip3 install wheel

git clone https://github.com/IanHarvey/bluepy
cd bluepy/
git checkout v/1.3.0
sed -i 's/$(CC)/$(CC) -static/' bluepy/Makefile
python3.10 setup.py bdist_wheel
cd ..
mv bluepy/dist/*.whl .