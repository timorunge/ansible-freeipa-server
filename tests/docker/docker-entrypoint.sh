#!/bin/sh
set -e

printf "[defaults]\nroles_path=/etc/ansible/roles\n" > ansible.cfg

ansible-lint /ansible/test.yml
ansible-lint /etc/ansible/roles/${ansible_role}/tasks/main.yml

ansible-playbook /ansible/test.yml \
  -i /ansible/inventory \
  --syntax-check
