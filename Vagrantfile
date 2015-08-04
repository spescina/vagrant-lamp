# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	
	# Configure The Box
	config.vm.box = "spescina/node_tools"
	
	config.vm.network "private_network", ip: "192.168.10.10"

	# Run The Base Provisioning Script
	config.vm.provision :shell, path: "./privileged.sh"

end