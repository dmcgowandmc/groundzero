Groundzero Ansible Scripts are responsible for bootstrap the minimum environment for Coffeemate. Once minimum environment is configured, coffeemates own management server will configure the remaining environment

To run, simply execute the following command:

ansible-playbook -i inventory/groundzero site.yml -vvvv
