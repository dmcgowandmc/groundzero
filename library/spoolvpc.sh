#!/bin/bash

#Create the VPC and configure the correct DNS settings. AWS Console must be installed

#Return the VPC ID which is requiredfor future operations.

## IMPROVEMENTS REQUIRED##

#Hard coded IP Address range specifically for the coffeemate app. This would allow for variable inputs

VPCTAGS="[{\"Key\":\"Name\",\"Value\":\"coffeemate.network.vpc\"}]"

VPCID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 | jshon -e Vpc -e VpcId | sed 's/\"//g')
aws ec2 create-tags --resources $VPCID --tags $VPCTAGS
aws ec2 modify-vpc-attribute --vpc-id $VPCID --enable-dns-support
aws ec2 modify-vpc-attribute --vpc-id $VPCID --enable-dns-hostnames

echo "{\"VpcID\":\"$VPCID\"}"
