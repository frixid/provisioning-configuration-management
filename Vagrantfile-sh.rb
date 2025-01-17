# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 60

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.cpus = 1
    #vb.gui = true
  end
     
  config.vm.define "zipi" do |zipi|
    
    zipi.vm.host_name = "zipi"
    zipi.vm.box = "ubuntu/trusty64"
      
    zipi.vm.synced_folder ".", "/vagrant",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=775,fmode=664"]
    
    zipi.vm.network "private_network",
      ip: "192.168.32.10",
      virtualbox__intnet: true,
      auto_config: true
    
    # host:port >> guest:port
    zipi.vm.network "forwarded_port", host: 8080, guest: 80, auto_correct: true
    zipi.vm.network "forwarded_port",  host: 8081, guest: 8080, auto_correct: true

    zipi.vm.provision :shell,
      :path => "provision-sh/vagrant-bootstrap-opennms.sh"
  end

#  config.vm.define "zape" do |zape|
#    zape.vm.host_name = "zape"
#    zape.vm.box = "ubuntu/trusty64"
#      
#    zape.vm.network "private_network",
#      ip: "192.168.32.11",
#      virtualbox__intnet: true,
#      auto_config: true
#      
#    # host:port >> guest:port
#    zape.vm.network "forwarded_port", host: 8082, guest: 80, auto_correct: true
#    zape.vm.network "forwarded_port",  host: 8083, guest: 8080, auto_correct: true
#
#    zape.vm.provision :shell,
#      :path => "provision-sh/vagrant-bootstrap-jenkins-node.sh"
#  end    
end
