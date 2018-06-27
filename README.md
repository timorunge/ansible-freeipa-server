freeipa-server
==============

This role is building and installing an FreeIPA Server according to your needs.

Tested platforms are:

* Ubuntu
  * 16.04
  * 17.10
  * 18.04

Never the less this playbook should work fine on RedHat based distributions.

This playbook is not taking care of the initialisation of the Kerberos admin
user. You can find some examples in the
[FreeIPA Quick Start Guide](https://www.freeipa.org/page/Quick_Start_Guide#Administrative_users_in_FreeIPA)
and the [RHEL Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html/configuring_identity_management/logging-in#logging-in-kinit).

But basically you just have to run

```sh
kinit admin
```

once the Playbook is finished.

Requirements
------------

This role requires Ansible 2.4.0 or higher. It's fully tested with the latest
stable release (2.5.5).

You can simply use pip to install (and define) the latest stable version:

```sh
pip install ansible==2.5.5
```

All platform requirements are listed in the metadata file.

Install
-------

```sh
ansible-galaxy install timorunge.freeipa-server
```

Role Variables
--------------

It is required to set the following variables in order to get this role up and
running (without customisation). Those variables don't have any default values:

```yaml
freeipa_server_admin_password: Passw0rd
freeipa_server_domain: example.com
freeipa_server_ds_password: Passw0rd
freeipa_server_fqdn: ipa.example.com
freeipa_server_ip: 172.20.0.2
freeipa_server_realm: EXAMPLE.COM
```

The variables that can be passed to this role and a brief description about
them are as follows. (For all variables, take a look at [defaults/main.yml](defaults/main.yml))

```yaml
# Automatically setting an entry in /etc/hosts
freeipa_server_manage_host: true

# The base command for the FreeIPA installation
freeipa_server_install_base_command: ipa-server-install --unattended

# The default FreeIPA installation options
freeipa_server_install_options:
  - "--realm={{ freeipa_server_realm }}"
  - "--domain={{ freeipa_server_domain }}"
  - '--setup-dns'
  - "--ds-password {{ freeipa_server_ds_password }}"
  - "--admin-password {{ freeipa_server_admin_password }}"
  - '--mkhomedir'
  - "--hostname={{ freeipa_server_fqdn | default(ansible_fqdn) }}"
  - "--ip-address={{ freeipa_server_ip }}"
  - '--no-host-dns'
  - '--no-ntp'
  - '--idstart=5000'
  - '--ssh-trust-dns'
  - '--forwarder=8.8.8.8'
  - '--auto-forwarders'
```

Examples
--------

To keep the document lean the install options are stripped.
You can find the install options either in [this
document](#freeipa-install-options) or in the online
[man page for ipa-server-install](https://linux.die.net/man/1/ipa-server-install).

## 1) Install the FreeIPA server with default settings

```yaml
- hosts: freeipa-server
  vars:
    freeipa_server_admin_password: Passw0rd
    freeipa_server_domain: example.com
    freeipa_server_ds_password: Passw0rd
    freeipa_server_fqdn: ipa.example.com
    freeipa_server_ip: 172.20.0.2
    freeipa_server_realm: EXAMPLE.COM
  roles:
    - timorunge.freeipa-server
```

## 2) Install the FreeIPA server with custom install options:

```yaml
- hosts: freeipa-server
  vars:
    freeipa_server_admin_password: Passw0rd
    freeipa_server_domain: example.com
    freeipa_server_ds_password: Passw0rd
    freeipa_server_fqdn: ipa.example.com
    freeipa_server_ip: 172.20.0.2
    freeipa_server_realm: EXAMPLE.COM
    freeipa_server_install_options:
      - "--realm={{ freeipa_server_realm }}"
      - "--domain={{ freeipa_server_domain }}"
      - '--setup-dns'
      - "--ds-password {{ freeipa_server_ds_password }}"
      - "--admin-password {{ freeipa_server_admin_password }}"
      - '--mkhomedir'
      - "--hostname={{ freeipa_server_fqdn | default(ansible_fqdn) }}"
      - "--ip-address={{ freeipa_server_ip }}"
      - '--ip-address=10.0.0.2'
      - '--ip-address=192.168.20.2'
      - '--no-host-dns'
      - '--no-ntp'
      - '--idstart=5000'
      - '--ssh-trust-dns'
      - '--forwarder=8.8.8.8'
      - '--auto-forwarders'
      - '--no-ui-redirect'
      - '--no-ssh'
      - '--no-sshd'
  roles:
    - timorunge.freeipa-server
```

FreeIPA install options
-----------------------

An overview of the install options for ipa-server-install (4.3.1).

```sh
--version             show program's version number and exit
-h, --help            show this help message and exit
-U, --unattended      unattended (un)installation never prompts the user

basic options:
  -r REALM_NAME, --realm=REALM_NAME
                      realm name
  -n DOMAIN_NAME, --domain=DOMAIN_NAME
                      domain name
  --setup-dns         configure bind with our zone
  -p DM_PASSWORD, --ds-password=DM_PASSWORD
                      Directory Manager password
  -a ADMIN_PASSWORD, --admin-password=ADMIN_PASSWORD
                      admin user kerberos password
  --mkhomedir         create home directories for users on their first login
  --hostname=HOST_NAME
                      fully qualified name of this host
  --domain-level=DOMAINLEVEL
                      IPA domain level
  --ip-address=IP_ADDRESS
                      Master Server IP Address. This option can be used
                      multiple times
  --no-host-dns       Do not use DNS for hostname lookup during installation
  -N, --no-ntp        do not configure ntp
  --idstart=IDSTART   The starting value for the IDs range (default random)
  --idmax=IDMAX       The max value for the IDs range (default:
                      idstart+199999)
  --no_hbac_allow     Don't install allow_all HBAC rule
  --ignore-topology-disconnect
                      do not check whether server uninstall disconnects the
                      topology (domain level 1+)
  --no-pkinit         disables pkinit setup steps
  --no-ui-redirect    Do not automatically redirect to the Web UI
  --ssh-trust-dns     configure OpenSSH client to trust DNS SSHFP records
  --no-ssh            do not configure OpenSSH client
  --no-sshd           do not configure OpenSSH server
  --no-dns-sshfp      Do not automatically create DNS SSHFP records
  --dirsrv-config-file=FILE
                      The path to LDIF file that will be used to modify
                      configuration of dse.ldif during installation of the
                      directory server instance

certificate system options:
  --external-ca       Generate a CSR for the IPA CA certificate to be signed
                      by an external CA
  --external-ca-type=EXTERNAL_CA_TYPE
                      Type of the external CA
  --external-cert-file=FILE
                      File containing the IPA CA certificate and the
                      external CA certificate chain
  --dirsrv-cert-file=FILE
                      File containing the Directory Server SSL certificate
                      and private key
  --http-cert-file=FILE
                      File containing the Apache Server SSL certificate and
                      private key
  --pkinit-cert-file=FILE
                      File containing the Kerberos KDC SSL certificate and
                      private key
  --dirsrv-pin=PIN    The password to unlock the Directory Server private
                      key
  --http-pin=PIN      The password to unlock the Apache Server private key
  --pkinit-pin=PIN    The password to unlock the Kerberos KDC private key
  --dirsrv-cert-name=NAME
                      Name of the Directory Server SSL certificate to
                      install
  --http-cert-name=NAME
                      Name of the Apache Server SSL certificate to install
  --pkinit-cert-name=NAME
                      Name of the Kerberos KDC SSL certificate to install
  --ca-cert-file=FILE
                      File containing CA certificates for the service
                      certificate files
  --subject=SUBJECT   The certificate subject base (default O=<realm-name>)
  --ca-signing-algorithm=CA_SIGNING_ALGORITHM
                      Signing algorithm of the IPA CA certificate

DNS options:
  --forwarder=FORWARDERS
                      Add a DNS forwarder. This option can be used multiple
                      times
  --auto-forwarders   Use DNS forwarders configured in /etc/resolv.conf
  --no-forwarders     Do not add any DNS forwarders, use root servers
                      instead
  --allow-zone-overlap
                      Create DNS zone even if it already exists
  --reverse-zone=REVERSE_ZONE
                      The reverse DNS zone to use. This option can be used
                      multiple times
  --no-reverse        Do not create new reverse DNS zone
  --auto-reverse      Create necessary reverse zones
  --no-dnssec-validation
                      Disable DNSSEC validation
  --zonemgr=ZONEMGR   DNS zone manager e-mail address. Defaults to
                      hostmaster@DOMAIN

Logging and output options:
  -v, --verbose       print debugging information
  -d, --debug         alias for --verbose (deprecated)
  -q, --quiet         output only errors
  --log-file=FILE     log to the given file

uninstall options:
  --uninstall         uninstall an existing installation. The uninstall can
                      be run with --unattended option
```

Testing
-------

[![Build Status](https://travis-ci.org/timorunge/ansible-freeipa-server.svg?branch=master)](https://travis-ci.org/timorunge/ansible-freeipa-server)

Testing is done with [Vagrant](https://www.vagrantup.com/)
([Installing Vagrant](https://www.vagrantup.com/docs/installation/))
which is bringing up the following virtual machines:

* Ubuntu 16.04
* Ubuntu 17.10
* Ubuntu 18.04

The latest stable release of Ansible is installed on all virtual machines and is
applying a [test playbook](tests/test.yml) locally.

For further details and additional checks take a look at the
[Vagrant entrypoint](vagrant/vagrant-entrypoint.sh).

```sh
# Testing locally in a vagrant virtual machine
vagrant up
vagrant provision
vagrant ssh ubuntu_18_04
sudo /vagrant/vagrant-entrypoint.sh
```

Security
--------

This playbook is not taking care of securing FreeIPA Server which can be done
with e.g. [firewalld](https://firewalld.org/) or
[iptables](https://linux.die.net/man/8/iptables).

Depending on your setup you have to open the following ports:

TCP ports:
- 80, 443: HTTP/HTTPS
- 389, 636: LDAP/LDAPS
- 88, 464: kerberos
- 53: bind

UDP Ports:
- 88, 464: kerberos
- 53: bind

Backup
------

Be sure to back up the CA certificates stored in /root/cacert.p12. These files
are required to create replicas. The password for these files is the Directory
Manager (`freeipa_server_ds_password`) password.

On FreeIPA you can also find a general
[Backup and Restore](https://www.freeipa.org/page/Backup_and_Restore) page which
is covering the most important topics.

Dependencies
------------

None

License
-------
BSD

Author Information
------------------

- Timo Runge
