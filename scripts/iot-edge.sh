#!/bin/bash
UserName=$1
IoThubName=$2
DeviceName=$3
DeviceConfig=$4
DeviceConfigName=$5
TenantID=$6
ApplicationID=$7
Certificate=$8
SubscriptionID=$9
sudo apt install -y python-pip
sudo apt install -y docker.io
#Install Azure-CLI
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install apt-transport-https -y
sudo apt-get update && sudo apt-get install azure-cli -y
az extension add --name azure-cli-iot-ext
az login --service-principal -u $ApplicationID -p $Certificate --tenant $TenantID
az account set --subscription $SubscriptionID
cd /home/$UserName/
wget https://packages.microsoft.com/repos/azure-cli/pool/main/a/azure-cli/azure-cli_2.0.32-1~wheezy_all.deb
sudo dpkg -i azure-cli_2.0.32-1~wheezy_all.deb
# Create IoT hub Edge Device
az iot hub device-identity create -n $IoThubName -d $DeviceName -ee
wget $DeviceConfig
az iot hub apply-configuration -$IoThubName -d $DeviceName -k $DeviceConfigName
connstr=`az iot hub device-identity show-connection-string -n $IoThubName -d $DeviceName | grep '"cs":'| cut -d ":" -f2 | tr -d "\"," |tr -d " "`
export HOME=/root
sudo pip install -U azure-iot-edge-runtime-ctl
iotedgectl setup --connection-string "${connstr}" --auto-cert-gen-force-no-passwords
