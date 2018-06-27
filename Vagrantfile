# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :ubuntu_16_04 do |ubuntu_16_04|
    ubuntu_16_04.vm.box = "ubuntu/xenial64"
    ubuntu_16_04.vm.hostname = "ubuntu-16-04.ipa.example.com"
    ubuntu_16_04.vm.network :private_network, ip: "172.20.16.4"
  end
  config.vm.define :ubuntu_17_10 do |ubuntu_17_10|
    ubuntu_17_10.vm.box = "ubuntu/artful64"
    ubuntu_17_10.vm.hostname = "ubuntu-17-10.ipa.example.com"
    ubuntu_17_10.vm.network :private_network, ip: "172.20.17.10"
  end
  config.vm.define :ubuntu_18_04 do |ubuntu_18_04|
    ubuntu_18_04.vm.box = "ubuntu/bionic64"
    ubuntu_18_04.vm.hostname = "ubuntu-18-04.ipa.example.com"
    ubuntu_18_04.vm.network :private_network, ip: "172.20.18.4"
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
