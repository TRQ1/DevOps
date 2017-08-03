#!/bin/bash

#Check gclod env-vars
if [[ -z $GCP_KEY_FILE || -z $GCP_PROJECT_ID ]]; then
  echo "GCLOUD_KEY_FILE, GCLOUD_PROJECT_ID must be set." 
  exit 1;
fi

#Install gcloud
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install -y google-cloud-sdk
sudo apt-get install -y google-cloud-sdk-app-engine-java

#Set gcloud init
gcloud auth activate-service-account --key-file=${GCP_KEY_FILE}
gcloud config set project ${GCP_PROJECT_ID}
