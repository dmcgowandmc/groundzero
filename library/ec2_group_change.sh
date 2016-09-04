#!/bin/bash

#Custom Module to assign security groups as desired. Takes in as minimum a region, instance id, and and one or more security groups. Could have saved myself a lot of trouble if I just built the dam thing in python, but anyway bash
#it is.

#WARNING: This is dependent on the AWS console

#WARNING: The aws command assigns exactly what you provide, so if you only provide one security group, that will be assigned and the rest will be removed

#FUTURE ENHANCEMENTS: Eventually want this to detect current group assignment and if request matches whats already there, return a changed=false

REGION=""
INSTANCE=""
GROUP_ID=""
GROUP_ID_MOD

if [[ -s $1 ]]; then
	while IFS='' read -r line || [[ -n "$line" ]]; do
		IFS=' ' read -r -a LINEARRAY <<< $line
	done < $1

	for ELEMENT in ${LINEARRAY[@]}
	do
		IFS='=' read -r KEY VALUE <<< ${ELEMENT}

		if [ "$KEY" == "region" ]; then
			REGION=$VALUE
		elif [ "$KEY" == "instance" ]; then
			INSTANCE=$VALUE
		elif [ "$KEY" == "group_id" ]; then
			GROUP_ID=$VALUE
			GROUP_ID_MOD=$(echo $VALUE | sed 's/,/\ /g')
		fi
	done

	ERRMSG=$(aws --region $REGION ec2 modify-instance-attribute --instance-id $INSTANCE --groups $GROUP_ID_MOD 2>&1 | tr -d "\n")

	if [[ $(echo $ERRMSG | jshon -e return | sed 's/\"//g') == "true" ]]; then
		echo "{\"changed\":\"True\"}"
	else
		echo "{\"failed\":\"true\",\"msg\":\"$ERRMSG\"}"
	fi
else
	echo "{\"failed\":\"True\",\"msg\":\"Must Provide a Region, Instance ID and one or more security groups\"}"
fi
