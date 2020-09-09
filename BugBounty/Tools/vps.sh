#!/bin/sh
sudo apt-get update;
sudo apt-get upgrade;
sudo apt-get  install screen;
sudo apt-get install python2;
sudo apt-get install wget;
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py;
sudo python2 get-pip.py
rm -r get-pip.py;
sudo apt-get install python3;
sudo apt install python3-pip;
sudo apt install npm;
sudo apt  install golang-go;
sudo apt  install nmap;
sudo apt install python3-virtualenv;
pip install  requests;
sudo snap install jq;
sudo npm install broken-link-checker -g;
