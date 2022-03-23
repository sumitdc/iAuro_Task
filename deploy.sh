#!/bin/bash
if [ $# -lt 1 ]
then
        echo "Usage : $0 container-name"
        exit
fi

IMAGE_NAME=ECR-IMAGE_NAME
CONTAINER_NAME=$1
DEV_SERVER="3.6.125.972"
DEV_USER="ubuntu"
CURRENT_PEM_FILE="/data/pem_files/iauro.pem"

echo "start"
sudo /usr/bin/docker build . -t "$IMAGE_NAME"
export AWS_REGION=ap-south-1
export AWS_PROFILE=iauro-ecr
        aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ECR-IMAGE_NAME
sudo /usr/bin/docker push $IMAGE_NAME  && echo "Push complete"
ssh -i $CURRENT_PEM_FILE $DEV_USER@$DEV_SERVER "docker container rm -f $CONTAINER_NAME" && echo "Old Container removed"
ssh -i $CURRENT_PEM_FILE $DEV_USER@$DEV_SERVER "docker rmi -f $IMAGE_NAME"
ssh -i $CURRENT_PEM_FILE $DEV_USER@$DEV_SERVER "sh /home/ubuntu/docker/awsecr-login.sh"
ssh -i $CURRENT_PEM_FILE $DEV_USER@$DEV_SERVER "sudo systemctl restart docker-compose.service" && echo "Service is Restarted"
echo "Done"
