#!/bin/sh
set -e

IPS=$(hostname -I)
FQDN=$(hostname -f)

printf '127.0.0.1 localhost\n' > /etc/hosts
for IP in ${IPS} ; do printf "${IP} ${FQDN}\n" >> /etc/hosts ; done
printf '[defaults]\nroles_path=/etc/ansible/roles\n' > /ansible/ansible.cfg

ansible-lint /etc/ansible/roles/timorunge.freeipa_server/tasks/main.yml
ansible-playbook /ansible/test.yml -i /ansible/inventory --syntax-check
ansible-playbook /ansible/test.yml -i /ansible/inventory --connection=local --become -vvvv
service systemd-resolved restart
ansible-playbook /ansible/test.yml -i /ansible/inventory --connection=local --become | grep -q 'changed=0.*failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)
service ipa status >/dev/null 2>&1 && (echo 'FreeIPA service status test: pass' && exit 0) || (echo 'FreeIPA service status test: fail' && exit 1)
echo 'Passw0rd' | kinit admin >/dev/null 2>&1 && (echo 'FreeIPA kinit test: pass' && exit 0) || (echo 'FreeIPA kinit test: fail' && exit 1)
ipa user-add john.doe --first=John --last=Doe >/dev/null 2>&1 && (echo 'FreeIPA user-add test: pass' && exit 0) || (echo 'FreeIPA user-add test: fail' && exit 1)
ipa user-show admin >/dev/null 2>&1 && (echo 'FreeIPA user-show test: pass' && exit 0) || (echo 'FreeIPA user-show test: fail' && exit 1)
curl -Ikso /dev/null https://${FQDN}/ipa/ui/ && (echo 'FreeIPA httpd response test: pass' && exit 0) || (echo 'FreeIPA httpd response test: fail' && exit 1)
