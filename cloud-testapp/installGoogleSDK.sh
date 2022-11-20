#! /bin/sh
#https://cloud.google.com/sdk/docs/#deb
#Install the latest Cloud SDK version

#Create a variable for the correct distribution:
CLOUD_SDK_REPO="cloud-sdk-$(grep VERSION_CODENAME /etc/os-release | cut -d '=' -f 2)"

#Add the Cloud SDK distribution URI as a package source:
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

#Import the Google Cloud public key:
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

#Update and install the Cloud SDK
sudo apt-get update && sudo apt-get install google-cloud-sdk

#Optionally, install any of these additional components:
#google-cloud-sdk-app-engine-python
#google-cloud-sdk-app-engine-python-extras
#google-cloud-sdk-app-engine-java
#google-cloud-sdk-app-engine-go
#google-cloud-sdk-datalab
#google-cloud-sdk-datastore-emulator
#google-cloud-sdk-pubsub-emulator
#google-cloud-sdk-cbt
#google-cloud-sdk-cloud-build-local
#google-cloud-sdk-bigtable-emulator
#kubectl
sudo apt-get install google-cloud-sdk-app-engine-java
sudo apt-get install google-cloud-sdk-app-engine-python

#Run gcloud init to get started:
gcloud init

#Install the latest Google Cloud Client Libraries
#https://cloud.google.com/apis/docs/cloud-client-libraries