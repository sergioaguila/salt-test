#!/bin/bash

PREFIX=sergioaguila
APP="flask"
ENV="test"
NUM_SERVERS=1 
INSTANCE_TYPE="t1.micro"
FLASK_PORT=80
SSH_PORT=22
SG_NAME=${PREFIX}-group-name
SG_DESCRIPTION=${PREFIX}-salt-flask-test
KEY_NAME=${PREFIX}-key
USER_DATA="install-salt-client"
AMI_ID="ami-a73264ce"
SECURITY_GROUP_ID="sg-cedb1db2"

# 1 Load user data to install salt
# 2 Create security group and open the needed port
# 3 Create key pair
# 4 Add userdata to install salt
# 5 Launch the instance
# 6 Get remote IP

#echo "Create SECURITY GROUP and get a SG_ID"

#SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name "${SG_NAME}"  --description "${SG_DESCRIPTION}" --query 'GroupId' --output text)

#echo "Add ingress rules to the sec group"
#aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol tcp --port ${SSH_PORT} --cidr 0.0.0.0/0
#aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol tcp --port ${FLASK_PORT} --cidr 0.0.0.0/0

#echo "Create a key/pair"
#aws ec2 create-key-pair --key-name "${KEY_NAME}" --query 'KeyMaterial' --output text > "${KEY_NAME}".pem
#chmod 400 "${KEY_NAME}".pem

echo "Launch instance and pass the user-data to install salt minion"
INSTANCE_ID=$(aws ec2 run-instances --key "${KEY_NAME}" --instance-type "${INSTANCE_TYPE}" --security-group-ids ${SECURITY_GROUP_ID} --user-data file://${USER_DATA} --associate-public-ip-address --image-id "${AMI_ID}" --output text --query 'Instances[*].InstanceId')
echo "Instance ID: ${INSTANCE_ID}"

echo "Wait for the instance to be up"
while state=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --output text --query 'Reservations[*].Instances[*].State.Name'); test "$state" = "pending"; do
  sleep 1; echo -n '.'
done; echo " $state"

echo "Get remote IP"
REMOTE_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --output text --query 'Reservations[*].Instances[*].PublicIpAddress')

echo "Public IP: ${REMOTE_IP}"