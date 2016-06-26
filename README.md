Groundzero Ansible Scripts are responsible for bootstrap the minimum environment for Coffeemate. Once minimum environment is configured, coffeemates own management server will configure the remaining environment

At the moment it is very hard coded for my requirements but I eventually intend this to be a generic set of scripts that anyone can use. Throughout the code I have left comments on areas I would like to improve
but will need to leave to a later date

* Prerequisites

At least one host with 

* Run instructions

ansible-playbook -i inventory/groundzero site.yml -vvvv
