#!/bin/bash

AWS_DIR=~/.aws

#Check aws env-vars
if [[ -z $AWS_ACCESS_KEY_ID || -z $AWS_SECRET_ACCESS_KEY || -z $AWS_REGION ]]; then
  echo "AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION must be set." 
  exit 1;
fi

#Install python3, pip3, virtualenv
sudo apt-get update
sudo apt-get install -y python3 python3-pip
pip3 install --upgrade pip
sudo pip3 install virtualenv

#Install aws-cli
virtualenv -p /usr/bin/python3 ${AWS_DIR}
chmod 700 ${AWS_DIR}

pushd $(pwd)
cd ${AWS_DIR} && . bin/activate
pip3 install --upgrade awscli
deactivate
popd

#Set aws config
if ! ls ${AWS_DIR}/config >/dev/null 2>&1; then
cat > ${AWS_DIR}/config << EOF
[default]
region=${AWS_REGION}
output=json
EOF
fi

#Set aws credentials
if ! ls ${AWS_DIR}/credentials >/dev/null 2>&1; then
cat > ${AWS_DIR}/credentials <<EOF
[default]
aws_access_key_id =${AWS_ACCESS_KEY_ID} 
aws_secret_access_key =${AWS_SECRET_ACCESS_KEY}
EOF
fi

chmod 600 ${AWS_DIR}/config
chmod 600 ${AWS_DIR}/credentials
