# freeipa_server

This role is installing and configuring the FreeIPA Server according to
your needs.

This playbook is taking care of the initialisation of the Kerberos admin
user (username: `admin`, password is the one which you're setting in
`freeipa_server_admin_password`).

In combination with
[`freeipa`](https://galaxy.ansible.com/timorunge/freeipa)
([Github](https://github.com/timorunge/ansible-freeipa)) it's
possible (and tested) to use `freeipa_server` with the latest version of
FreeIPA itself on Ubuntu >= 18.04 (take a look at the
[example section](https://github.com/timorunge/ansible-freeipa#6-install-freeipa-with-timorungesssd-and-timorungefreeipa_server)).

## Requirements

This role requires
[Ansible 2.5.0](https://docs.ansible.com/ansible/devel/roadmap/ROADMAP_2_5.html)
or higher.

You can simply use pip to install (and define) a stable version:

```sh
pip install ansible==2.7.7
```

All platform requirements are listed in the metadata file.

## Install

```sh
ansible-galaxy install timorunge.freeipa_server
```

## Role Variables

It is required to set the following variables in order to get this role up and
running (without customisation). Those variables don't have any default values:

```yaml
# Admin user kerberos password - at least 8 characters
# Type: Str
freeipa_server_admin_password: Passw0rd
# Primary DNS domain of the IPA deployment
# Type: Str
freeipa_server_domain: example.com
# Directory Manager password - at least 8 characters
# Type: Str
freeipa_server_ds_password: Passw0rd
# The hostname of this machine (FQDN)
# Type: Str
freeipa_server_fqdn: ipa.example.com
# Master Server IP Address
# Type: Str
freeipa_server_ip: 172.20.0.2
# Kerberos realm name of the IPA deployment
# Type: Str
freeipa_server_realm: EXAMPLE.COM
```

The variables that can be passed to this role and a brief description about
them are as follows. (For all variables, take a look at [defaults/main.yml](defaults/main.yml))

```yaml
# Enable/Disable manage RedHat epel repository
# Type: Bool
freeipa_server_enable_epel_repo: true

# Automatically setting an entry in /etc/hosts
# Type: Bool
freeipa_server_manage_host: true

# Choice FreeIPA server installation type (master/replica)
# Type: Str
freeipa_server_type: master

# FQDN of the master FreeIPA server
# Type: Str
freeipa_server_master_fqdn: ''

# The base command for the FreeIPA installation
# Type: Str
freeipa_server_install_base_command: ipa-{{ 'server' if freeipa_server_type == 'master' else 'replica' }}-install --unattended {{ '--server=' + freeipa_server_master_fqdn if freeipa_server_type == 'replica' }}

# The default FreeIPA installation options
# Type: List
freeipa_server_install_options:
  - "--realm={{ freeipa_server_realm }}"
  - "--domain={{ freeipa_server_domain }}"
  - "--setup-dns"
  - "--ds-password={{ freeipa_server_ds_password }}"
  - "--admin-password={{ freeipa_server_admin_password }}"
  - "--mkhomedir"
  - "--hostname={{ freeipa_server_fqdn | default(ansible_fqdn) }}"
  - "--ip-address={{ freeipa_server_ip }}"
  - "--no-host-dns"
  - "--no-ntp"
  - "--idstart=5000"
  - "--ssh-trust-dns"
  - "--forwarder=8.8.8.8"
  - "--auto-forwarders"
```

## Examples

To keep the document lean the install options are stripped. You can
find the install options either in
[this document](#freeipa-server-install-options) or in the
[online man pages for ipa-server-install](https://linux.die.net/man/1/ipa-server-install).

### 1) Install the FreeIPA server as master with default settings

```yaml
- hosts: freeipa-server
  vars:
    freeipa_server_admin_password: Passw0rd
    freeipa_server_domain: example.com
    freeipa_server_ds_password: Passw0rd
    freeipa_server_fqdn: ipa-master.example.com
    freeipa_server_ip: 172.20.0.2
    freeipa_server_realm: EXAMPLE.COM
  roles:
    - timorunge.freeipa_server
```

### 2) Install the FreeIPA server as replica with default settings

```yaml
- hosts: freeipa-server
  vars:
    freeipa_server_type: replica
    freeipa_server_master_fqdn: ipa-master.example.com
    freeipa_server_admin_password: Passw0rd
    freeipa_server_domain: example.com
    freeipa_server_ds_password: Passw0rd
    freeipa_server_fqdn: ipa-replica.example.com
    freeipa_server_ip: 172.20.0.3
    freeipa_server_realm: EXAMPLE.COM
  roles:
    - timorunge.freeipa_server
```

### 3) Install the FreeIPA server and enable it automatically on all (IPv4) network interfaces

You should still set `freeipa_server_ip` if you want to use `freeipa_server_manage_host`.

```yaml
- hosts: freeipa-server
  vars:
    freeipa_server_admin_password: Passw0rd
    freeipa_server_domain: example.com
    freeipa_server_ds_password: Passw0rd
    freeipa_server_fqdn: ipa.example.com
    freeipa_server_ip: 172.20.0.3
    freeipa_server_realm: EXAMPLE.COM
    freeipa_server_install_options:
      - "--ip-address={{ ansible_all_ipv4_addresses | join(' --ip-address=') }}"
  roles:
    - timorunge.freeipa_server
```

### 4) Install the FreeIPA server with custom install options

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
      - "--setup-dns"
      - "--ds-password {{ freeipa_server_ds_password }}"
      - "--admin-password {{ freeipa_server_admin_password }}"
      - "--mkhomedir"
      - "--hostname={{ freeipa_server_fqdn | default(ansible_fqdn) }}"
      - "--ip-address={{ freeipa_server_ip }}"
      - "--ip-address=10.0.0.2"
      - "--ip-address=192.168.20.2"
      - "--no-host-dns"
      - "--no-ntp"
      - "--idstart=5000"
      - "--ssh-trust-dns"
      - "--forwarder=8.8.8.8"
      - "--auto-forwarders"
      - "--no-ui-redirect"
      - "--no-ssh"
      - "--no-sshd"
  roles:
    - timorunge.freeipa_server
```

## FreeIPA server install options

An overview of the install options for ipa-server-install (4.6.4).

```sh
Usage: ipa-server-install [options]

Options:
  --version             show program's version number and exit
  -h, --help            show this help message and exit
  -U, --unattended      unattended (un)installation never prompts the user
  --uninstall           uninstall an existing installation. The uninstall can
                        be run with --unattended option

  Basic options:
    -p DM_PASSWORD, --ds-password=DM_PASSWORD
                        Directory Manager password
    -a ADMIN_PASSWORD, --admin-password=ADMIN_PASSWORD
                        admin user kerberos password
    --ip-address=IP_ADDRESS
                        Master Server IP Address. This option can be used
                        multiple times
    -n DOMAIN_NAME, --domain=DOMAIN_NAME
                        primary DNS domain of the IPA deployment (not
                        necessarily related to the current hostname)
    -r REALM_NAME, --realm=REALM_NAME
                        Kerberos realm name of the IPA deployment (typically
                        an upper-cased name of the primary DNS domain)
    --hostname=HOST_NAME
                        fully qualified name of this host
    --ca-cert-file=FILE
                        File containing CA certificates for the service
                        certificate files
    --no-host-dns       Do not use DNS for hostname lookup during installation

  Server options:
    --setup-adtrust     configure AD trust capability
    --setup-kra         configure a dogtag KRA
    --setup-dns         configure bind with our zone
    --idstart=IDSTART   The starting value for the IDs range (default random)
    --idmax=IDMAX       The max value for the IDs range (default:
                        idstart+199999)
    --no-hbac-allow     Don't install allow_all HBAC rule
    --no-pkinit         disables pkinit setup steps
    --no-ui-redirect    Do not automatically redirect to the Web UI
    --dirsrv-config-file=FILE
                        The path to LDIF file that will be used to modify
                        configuration of dse.ldif during installation of the
                        directory server instance

  SSL certificate options:
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

  Client options:
    --mkhomedir         create home directories for users on their first login
    -N, --no-ntp        do not configure ntp
    --ssh-trust-dns     configure OpenSSH client to trust DNS SSHFP records
    --no-ssh            do not configure OpenSSH client
    --no-sshd           do not configure OpenSSH server
    --no-dns-sshfp      do not automatically create DNS SSHFP records

  Certificate system options:
    --external-ca       Generate a CSR for the IPA CA certificate to be signed
                        by an external CA
    --external-ca-type={generic,ms-cs}
                        Type of the external CA
    --external-ca-profile=EXTERNAL_CA_PROFILE
                        Specify the certificate profile/template to use at the
                        external CA
    --external-cert-file=FILE
                        File containing the IPA CA certificate and the
                        external CA certificate chain
    --subject-base=SUBJECT_BASE
                        The certificate subject base (default O=<realm-name>).
                        RDNs are in LDAP order (most specific RDN first).
    --ca-subject=CA_SUBJECT
                        The CA certificate subject DN (default CN=Certificate
                        Authority,O=<realm-name>). RDNs are in LDAP order
                        (most specific RDN first).
    --ca-signing-algorithm={SHA1withRSA,SHA256withRSA,SHA512withRSA}
                        Signing algorithm of the IPA CA certificate

  DNS options:
    --allow-zone-overlap
                        Create DNS zone even if it already exists
    --reverse-zone=REVERSE_ZONE
                        The reverse DNS zone to use. This option can be used
                        multiple times
    --no-reverse        Do not create new reverse DNS zone
    --auto-reverse      Create necessary reverse zones
    --zonemgr=ZONEMGR   DNS zone manager e-mail address. Defaults to
                        hostmaster@DOMAIN
    --forwarder=FORWARDERS
                        Add a DNS forwarder. This option can be used multiple
                        times
    --no-forwarders     Do not add any DNS forwarders, use root servers
                        instead
    --auto-forwarders   Use DNS forwarders configured in /etc/resolv.conf
    --forward-policy={first,only}
                        DNS forwarding policy for global forwarders
    --no-dnssec-validation
                        Disable DNSSEC validation

  AD trust options:
    --enable-compat     Enable support for trusted domains for old clients
    --netbios-name=NETBIOS_NAME
                        NetBIOS name of the IPA domain
    --rid-base=RID_BASE
                        Start value for mapping UIDs and GIDs to RIDs
    --secondary-rid-base=SECONDARY_RID_BASE
                        Start value of the secondary range for mapping UIDs
                        and GIDs to RIDs

  Uninstall options:
    --ignore-topology-disconnect
                        do not check whether server uninstall disconnects the
                        topology (domain level 1+)
    --ignore-last-of-role
                        do not check whether server uninstall removes last
                        CA/DNS server or DNSSec master (domain level 1+)

  Logging and output options:
    -v, --verbose       print debugging information
    -d, --debug         alias for --verbose (deprecated)
    -q, --quiet         output only errors
    --log-file=FILE     log to the given file
```

## Testing

[![Build Status](https://travis-ci.org/timorunge/ansible-freeipa-server.svg?branch=master)](https://travis-ci.org/timorunge/ansible-freeipa-server)

Testing is done with [Vagrant](https://www.vagrantup.com/)
([installing Vagrant](https://www.vagrantup.com/docs/installation/))
which brings up the following virtual machines:

- EL
  - 7
- Fedora
  - 26
  - 27
- Ubuntu
  - 16.04 LTS (Xenial Xerus)
  - 17.10 (Artful Aardvark)
  - 18.04 LTS (Bionic Beaver)

The latest stable release of Ansible is installed on all virtual machines and is
applying a [test playbook](tests/test.yml) locally.

For further details and additional checks take a look at the
[Vagrant entrypoint](tests/vagrant/vagrant-entrypoint.sh).

```sh
# Testing in all available vagrant machines:
# This will take some time. Grab a coffee. Or two. Or forty two.
cd tests
vagrant up --parallel && vagrant halt
for h in $(vagrant global-status --prune | grep freeipa_server | awk '{print $2}') ; do echo ${h} ; vagrant up --provision ${h} ; vagrant ssh ${h} -c "sudo /vagrant/vagrant-entrypoint.sh" && (echo "$(date): ${h}: pass" >> tests/results.log) || (echo "$(date): ${h}: fail" >> tests/results.log) ; vagrant halt ${h} ; done
vagrant destroy -f
```

If Vagrant is failing to mount the directories you should ensure that you've
installed the
[VirtualBox Guest Additions](https://www.virtualbox.org/manual/ch04.html#idm2099).

Travis tests are done with [Docker](https://www.docker.com) and
[docker_test_runner](https://github.com/timorunge/docker-test-runner). Tests
on Travis are performing linting and syntax checks.

For further details and additional checks take a look at the
[docker_test_runner configuration](tests/docker_test_runner.yml) and the
[Docker entrypoint](tests/docker/docker-entrypoint.sh).

```sh
# Testing locally:
curl https://raw.githubusercontent.com/timorunge/docker-test-runner/master/install.sh | sh
./docker_test_runner.py -f tests/docker_test_runner.yml
```

## Security

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

## Backup

Be sure to back up the CA certificates stored in /root/cacert.p12. These files
are required to create replicas. The password for these files is the Directory
Manager (`freeipa_server_ds_password`) password.

On FreeIPA you can also find a general
[Backup and Restore](https://www.freeipa.org/page/Backup_and_Restore) page which
is covering the most important topics.

There is an Ansible role out there which is doing some basic backups:
[FreeIPA Server Backup](https://galaxy.ansible.com/timorunge/freeipa_server_backup)
([Github Repo](https://github.com/timorunge/ansible-freeipa-server-backup)).

## Dependencies

None

## License

[BSD 3-Clause "New" or "Revised" License](LICENSE)

## Author Information

- Timo Runge
