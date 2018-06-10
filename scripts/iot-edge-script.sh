#! /bin/bash
sudo apt install -y python-pip
sudo pip install azure
sudo apt-get install jq -y
sudo apt-get update
sudo apt-get install -y libssl-dev libffi-dev python-dev build-essential
sudo apt-get install -y nodejs-legacy
sudo apt-get install -y npm
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get install apt-transport-https
sudo apt-get update && sudo apt-get install azure-cli
