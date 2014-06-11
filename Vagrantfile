# -*- mode: ruby -*-
# vi: set ft=ruby :

raise "\n\nPlease set $GPFDIST_HOME to continue\n \n" if ENV["GPFDIST_HOME"].nil?

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "CentOS-6.4-GP4.2.6.1-2013101500"
  config.vm.box_url = "http://vboxes.ett.local/CentOS-6.4-GP4.2.6.1-2013101500.box"
  config.vm.network :private_network, ip: "192.168.56.43"

  config.vm.provider :virtualbox do |virtual_machine|
    virtual_machine.name = "cranium"
  end

  # This must be the first provisioning step so Greenplum doesn't have time to start before this happens
  config.vm.provision :shell, :inline => "sed -i s/\\.56\\.42/.56.43/ /etc/hosts"

  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder ENV["GPFDIST_HOME"], "/home/gpadmin/smart-insight-data", owner: "gpadmin", group: "gpadmin"

  config.vm.provision :shell, :inline => "chown -R gpadmin.gpadmin /home/gpadmin"
  config.vm.provision :shell, :inline => "sleep 10"
  config.vm.provision :shell, :inline => "sudo su - gpadmin -c 'cat /vagrant/db/setup.sql | psql'"
end
