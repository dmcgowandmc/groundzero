#Test Bash Script. May look at porting to ansible

#Create and Configure VPC
VPCTAGS="[{\"Key\":\"Name\",\"Value\":\"coffeemate.network.vpc\"}]"
VPCID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 | jshon -e Vpc -e VpcId | sed 's/\"//g')
aws ec2 create-tags --resources $VPCID --tags $VPCTAGS
aws ec2 modify-vpc-attribute --vpc-id $VPCID --enable-dns-support
aws ec2 modify-vpc-attribute --vpc-id $VPCID --enable-dns-hostnames
