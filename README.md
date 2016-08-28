# About the Project

Groundzero Ansible Scripts are responsible for bootstrap the minimum environment for Coffeemate. Once minimum environment is configured, coffeemates own management server will configure the remaining environment.

At minimum, this will create a VPC with two admin subnets across two availability zones and two ec2 instances wrapped in some strong security groups. Two hosts include a bastion host for external users to log in
and a management host which will be used for automated management of the rest of the environment. Was also planning to implement automated backup and failover of the instances to the second availability zone but
due to the complexity I am leaving it out of this package for now. Will be implemented and maintained on the management server.

At the moment it is very hard coded for my requirements but I eventually intend this to be a generic set of scripts that anyone can use. Throughout the code I have left comments on areas I would like to improve
but will need to leave to a later date.

# Prerequisites

* AWS Account
* One Debian host with Ansible 1.7 or higher installed.
* OR
* Create a Debian host in AWS with Ansible following steps below

# Install and Configuration for Existing host

* Create group "GroundzeroAdmin"
* Add to "GroundzeroAdmin" the "AmazonVPCFullAccess", "AmazonEC2FullAccess" and "AmazonS3FullAccess" policy
* Create IAM user "groundzero" and assign "GroundzeroAdmin" group
* On existing host, install and configure AWS console http://docs.aws.amazon.com/cli/latest/userguide/installing.html and use "groundzero" credentials.

# Install and Configuration for New AWS Host (this method is more secure)

* Create Amazon EC2 role "GroundzeroAuth"
* Add to "GroundzeroAuth" the "AmazonVPCFullAccess", "AmazonEC2FullAccess" and "AmazonS3FullAccess" policy
* Create new EC2 instance and request to use the "GroundzeroAuth" during creation
* Once new host is set up, install and configure AWS console http://docs.aws.amazon.com/cli/latest/userguide/installing.html and ignore setting up credentials
* Ensure this repository is cloned to the new host and run from there

# Run instructions

* ansible-playbook -i inventory/groundzero site.yml -vvvv (the -vvvv is optional)
