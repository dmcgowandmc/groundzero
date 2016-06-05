#!/bin/bash

#Create the new subnets. Two in each availability zone. A VPC ID must be provided. AWS Console must be installed

#Return the Subnet ID's

##IMPROVEMENTS REQUIRED##

#Better checking should be implemented. At the moment, If file has multiple lines, last line will be read. If multiple parameters are provided, only first will be read. Others will be ignored
#Need to add the ability for users to provide there own subnet IP's and tags

ERRFLAG=0

if [[ -s $1 ]]; then
	while IFS='' read -r line || [[ -n "$line" ]]; do
		IFS=' ' read -r -a LINEARRAY <<< $line
		IFS='=' read -r KEY VALUE <<< ${LINEARRAY[0]}
	done < $1
else
	echo "{\"failed\":\"True\",\"msg\":\"Must Provide a VpcID\"}"
fi

#This Section should eventually be a loop and allow you to create multiple subnets as required based on provided input
SUBNETTAG1="[{\"Key\":\"Name\",\"Value\":\"coffeemate.network.subnet.admin.az1\"}]"
SUBNETTAG2="[{\"Key\":\"Name\",\"Value\":\"coffeemate.network.subnet.admin.az2\"}]"

SUBNETID1=$(aws ec2 create-subnet --vpc-id $VALUE --cidr-block 10.0.16.0/20 --availability-zone ap-southeast-2a)

#if [ $? > 0 ]; then
#	
#fi

SUBNETID2=$(aws ec2 create-subnet --vpc-id $VALUE --cidr-block 10.0.32.0/20 --availability-zone ap-southeast-2a | jshon -e Subnet -e SubnetId | sed 's/\"//g')

aws ec2 create-tags --resources $SUBNETID1 --tags $SUBNETTAG1
aws ec2 create-tags --resources $SUBNETID1 --tags $SUBNETTAG1

ERRMSG=$(aws ec2 attach-internet-gateway --internet-gateway-id $IGID --vpc-id $VALUE 2>&1 | tr -d "\n")

if [[ ! -z $ERRMSG ]]; then
	aws ec2 delete-internet-gateway --internet-gateway-id $IGID
	echo "{\"failed\":\"true\",\"msg\":\"$ERRMSG\"}"
else
	echo "{\"changed\":\"True\",\"ansible_facts\":{\"InternetGatewayId\": \"$IGID\"}}"
fi
