#! /bin/bash
sudo apt install -y python-pip
sudo pip install azure
sudo apt-get install jq -y
sudo apt-get update
sudo apt-get install -y libssl-dev libffi-dev python-dev build-essential
sudo apt-get install -y nodejs-legacy
sudo apt-get install -y npm
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
sudo apt-get install apt-transport-https
sudo apt-get update
echo "===========================================Installing Azure CLI 2.0==========================================="
sudo apt-get install azure-cli
sudo apt-get update
sleep 10