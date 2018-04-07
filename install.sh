#!/bin/bash

# I hope that node and python3 is already intalled

git clone https://github.com/caffeinum/catload
cd catload
npm install
cd ..

git clone https://github.com/caffeinum/bizon-generator
cd bizon-generator
npm install
cd ..

/usr/local/bin/pip3.6 install -U instabot
