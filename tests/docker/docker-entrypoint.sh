#!/bin/sh
set -e

printf "[defaults]\nroles_path=/etc/ansible/roles" > ansible.cfg
ansible-lint /etc/ansible/roles/${ansible_role}/tasks/main.yml

ansible-playbook /ansible/test.yml \
  -i /ansible/inventory \
  --syntax-check
