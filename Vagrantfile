# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :freeipa_server_centos_7 do |freeipa_server_centos_7|
    freeipa_server_centos_7.vm.box = "geerlingguy/centos7"
    freeipa_server_centos_7.vm.hostname = "centos-7-server.ipa.example.com"
    freeipa_server_centos_7.vm.network :private_network, ip: "172.20.3.7"
  end
  config.vm.define :freeipa_server_fedora_26 do |freeipa_server_fedora_26|
    freeipa_server_fedora_26.vm.box = "generic/fedora26"
    freeipa_server_fedora_26.vm.hostname = "fedora-26-server.ipa.example.com"
    freeipa_server_fedora_26.vm.network :private_network, ip: "172.20.6.26"
  end
  config.vm.define :freeipa_server_fedora_27 do |freeipa_server_fedora_27|
    freeipa_server_fedora_27.vm.box = "generic/fedora27"
    freeipa_server_fedora_27.vm.hostname = "fedora-27-server.ipa.example.com"
    freeipa_server_fedora_27.vm.network :private_network, ip: "172.20.6.27"
    freeipa_server_fedora_27.vm.provision "shell", inline: "sysctl -w net.ipv6.conf.lo.disable_ipv6=0"
  end
  config.vm.define :freeipa_server_ubuntu_16_04 do |freeipa_server_ubuntu_16_04|
    freeipa_server_ubuntu_16_04.vm.box = "ubuntu/xenial64"
    freeipa_server_ubuntu_16_04.vm.hostname = "ubuntu-16-04-server.ipa.example.com"
    freeipa_server_ubuntu_16_04.vm.network :private_network, ip: "172.20.16.4"
  end
  config.vm.define :freeipa_server_ubuntu_17_10 do |freeipa_server_ubuntu_17_10|
    freeipa_server_ubuntu_17_10.vm.box = "ubuntu/artful64"
    freeipa_server_ubuntu_17_10.vm.hostname = "ubuntu-17-10-server.ipa.example.com"
    freeipa_server_ubuntu_17_10.vm.network :private_network, ip: "172.20.17.10"
  end
  config.vm.define :freeipa_server_ubuntu_18_04 do |freeipa_server_ubuntu_18_04|
    freeipa_server_ubuntu_18_04.vm.box = "ubuntu/bionic64"
    freeipa_server_ubuntu_18_04.vm.hostname = "ubuntu-18-04-server.ipa.example.com"
    freeipa_server_ubuntu_18_04.vm.network :private_network, ip: "172.20.18.4"
  end
  config.vm.box_check_update = true
  config.vm.synced_folder ".", "/etc/ansible/roles/timorunge.freeipa-server"
  config.vm.synced_folder "./tests", "/ansible"
  config.vm.synced_folder "./vagrant", "/vagrant"
  config.vm.provider "virtualbox" do |v|
    v.memory = "2048"
  end
  config.vm.provision "shell", path: "./vagrant/provision.sh"
end
