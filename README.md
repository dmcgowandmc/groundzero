# About the Project

Groundzero Ansible Scripts are responsible for bootstrap the minimum environment for Coffeemate. Once minimum environment is configured, coffeemates own management server will configure the remaining environment.

At minimum, this will create a VPC with two admin subnets across two availability zones and two ec2 instances wrapped in some strong security groups. Two hosts include a bastion host for external users to log in
and a management host which will be used for automated management of the rest of the environment. Was also planning to implement automated backup and failover of the instances to the second availability zone but
due to the complexity I am leaving it out of this package for now. Will be implemented and maintained on the management server.

At the moment it is very hard coded for my requirements but I eventually intend this to be a generic set of scripts that anyone can use. Throughout the code I have left comments on areas I would like to improve
but will need to leave to a later date.

# Prerequisites

* AWS Account
* One host with Ansible 1.7 or higher installed.
* (Optional) A second host to install and configure AWS console. Otherwise just use the Ansible host

# Install and Configuration

* Create group "VPCAdmin" with "AmazonVPCFullAccess" policy
* Create group "ec2Admin" with "AmazonEC2FullAccess" policy
* Create group "s3Admin" with "AmazonS3FullAccess" policy
* Create IAM user "groundzero" and assign previous three groups. Save Keys
* Either on Ansible host or a different host, install and configure AWS console http://docs.aws.amazon.com/cli/latest/userguide/installing.html and use groundzero credentials. Ensure Ansible host can SSH into second host or itself if the host

# Run instructions

* ansible-playbook -i inventory/groundzero site.yml -vvvv
