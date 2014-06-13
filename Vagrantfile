# -*- mode: ruby -*-
# vi: set ft=ruby :

FileUtils.mkdir_p("tmp/custdata") unless Dir.exists?("tmp/custdata")

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "greenplum-base"
  config.vm.box_url = "http://vboxes.ett.local/greenplum-base.box"

  config.vm.network :private_network, ip: "192.168.56.43"

  config.vm.provider :virtualbox do |virtual_machine|
    virtual_machine.name = "cranium"
  end

  # This must be the first provisioning step so Greenplum doesn't have time to start before this happens
  config.vm.provision :shell, inline: "sed -i s/\\.2\\.11/.56.43/ /etc/hosts"

  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder "tmp/custdata", "/home/gpadmin/smart-insight-data", owner: "gpadmin", group: "gpadmin"

  config.vm.provision :shell, inline: "su - gpadmin -c wait_for_greenplum.sh"
  config.vm.provision :shell, inline: "su - gpadmin -c 'cat /vagrant/db/setup.sql | psql'"
end
