#!/bin/sh
set -e

IPS=$(hostname -I)
FQDN=$(hostname -f)
HOSTNAME=$(hostname)

printf '127.0.0.1 localhost\n' > /etc/hosts
for IP in ${IPS} ; do printf "${IP} ${FQDN} ${HOSTNAME}\n" >> /etc/hosts ; done
printf '[defaults]\nroles_path=/etc/ansible/roles\n' > /ansible/ansible.cfg

ansible-lint /etc/ansible/roles/timorunge.freeipa-server/tasks/main.yml
ansible-playbook /ansible/test.yml -i /ansible/inventory --syntax-check
ansible-playbook /ansible/test.yml -i /ansible/inventory --connection=local --become -vvvv
ansible-playbook /ansible/test.yml -i /ansible/inventory --connection=local --become | grep -q 'changed=0.*failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)
service ipa status >/dev/null 2>&1 && (echo 'FreeIPA service status test: pass' && exit 0) || (echo 'FreeIPA service status test: fail' && exit 1)
