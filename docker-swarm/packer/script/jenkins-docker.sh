#!/bin/bash

if [[ -z $JENKINS_IMAGE || -z $JENKINS_PORT || -z $JENKINS_USER || -z $JENKINS_PASS ]]; then
  echo "JENKINS_IMAGE, JENKINS_PORT, JENKINS_USER, JENKINS_PASS must be set."
  exit 1;
fi

export JENKINS_IMAGE=${JENKINS_IMAGE}
export JENKINS_PORT=${JENKINS_PORT}

docker build -t $JENKINS_IMAGE ~/jenkins/.

