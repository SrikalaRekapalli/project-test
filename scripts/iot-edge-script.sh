IoThubName=$1
DeviceName=$2
DeviceConfig=$3

#Install Azure-CLI
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
sudo apt-get update
sudo apt-get install apt-transport-https -y 
sudo apt-get update && sudo apt-get install azure-cli -y

##Add Azure-CLI IoT Extensionn
az extension add --name azure-cli-iot-ext --output json
## create an identity for the IoT device
az iot hub device-identity create --hub-name $IoThubName --device-id $DeviceName --edge-enabled
## assign the device's configuration
az iot hub apply-configuration --hub-name $IoThubName --device-id $DeviceName --content $DeviceConfig
## get the connection string for the device
az iot hub device-identity show-connection-string --hub-name $IoThubName --device-id $DeviceName
