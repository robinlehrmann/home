# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "archlinux/archlinux"

  config.ssh.forward_agent = true

  config.vm.network 'private_network', ip: '192.145.23.21'
  config.vm.synced_folder '.', '/srv/share', id: 'vagrant-share', :nfs => true
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.customize ['modifyvm', :id, '--memory', 2048]
  end

  config.vm.provision 'ansible_local' do |ansible|
    ansible.pip_install_cmd   = 'curl https://bootstrap.pypa.io/get-pip.py | sudo python'
    ansible.provisioning_path = '/srv/share/'
    ansible.install_mode      = 'pip'
    ansible.version           = '2.9.6'
    ansible.playbook          = 'playbooks/provision.yml'
    ansible.inventory_path    = 'inventory/devbox'
    ansible.limit             = 'home'
  end
end
