# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	
	# Configure The Box
	config.vm.box = "spescina/node_tools"
	
	# Don't Replace The Default Key https://github.com/mitchellh/vagrant/pull/4707
	config.ssh.insert_key = false
	
	# Run The Base Provisioning Script
	config.vm.provision :shell, path: "./privileged.sh"	

end