# -*- mode: ruby -*-
# vi: set ft=ruby :

FileUtils.mkdir_p("tmp/custdata") unless Dir.exists?("tmp/custdata")

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "si-build.v1"
  config.vm.box_url = "http://vboxes.ett.local/si-build.v1.box"

  config.vm.hostname = 'cranium-build'
  config.vm.network :private_network, ip: "192.168.56.43"

  config.vm.provider :virtualbox do |virtual_machine|
    virtual_machine.name = "cranium"
  end

  config.vm.synced_folder "tmp/custdata", "/home/gpadmin/gpfdist-data", owner: "gpadmin", group: "gpadmin"

  config.vm.provision :shell, inline: "su - gpadmin -c 'cat /vagrant/db/setup.sql | psql'"
end
