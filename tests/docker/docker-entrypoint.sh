#!/bin/sh
set -e

printf "[defaults]\nroles_path=/etc/ansible/roles\n" > /ansible/ansible.cfg

ansible-lint -c /etc/ansible/roles/${ansible_role}/.ansible-lint \
  /etc/ansible/roles/${ansible_role}
ansible-lint -c /etc/ansible/roles/${ansible_role}/.ansible-lint \
  /ansible/test.yml

ansible-playbook /ansible/test.yml \
  -i /ansible/inventory \
  --syntax-check
