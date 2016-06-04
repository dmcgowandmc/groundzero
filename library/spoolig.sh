#!/bin/bash

#Create the Internet Gateway and attach to the newly create VPC. A VPC ID must be provided. AWS Console must be installed

#Return the Internet Gateway ID which is required for future operations.

#Better checking should be implemented. At the moment, If file has multiple lines, last line will be read. If multiple parameters are provided, only first will be read. Others will be ignored
if [[ -s $1 ]]; then
	while IFS='' read -r line || [[ -n "$line" ]]; do
		IFS=' ' read -r -a LINEARRAY <<< $line
		IFS='=' read -r KEY VALUE <<< ${LINEARRAY[0]}
	done < $1
else
	echo "{\"failed\":\"True\",\"msg\":\"Must Provide a VpcID\"}"
fi

VPCTAGS="[{\"Key\":\"Name\",\"Value\":\"coffeemate.network.ig\"}]"
IGID=$(aws ec2 create-internet-gateway | jshon -e InternetGateway -e InternetGatewayId | sed 's/\"//g')
aws ec2 create-tags --resources $IGID --tags $VPCTAGS
ERRMSG=$(aws ec2 attach-internet-gateway --internet-gateway-id $IGID --vpc-id $VALUE 2>&1 | tr -d "\n")

if [[ ! -z $ERRMSG ]]; then
	aws ec2 delete-internet-gateway --internet-gateway-id $IGID
	echo "{\"failed\":\"true\",\"msg\":\"$ERRMSG\"}"
else
	echo "{\"changed\":\"True\",\"ansible_facts\":{\"InternetGatewayId\": \"$IGID\"}}"
fi
