# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.cpus = 1
    #vb.gui = true
  end
    
  config.vm.boot_timeout = 60
 
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

    zipi.vm.provision "ansible" do |ansible|
      ansible.playbook = "provision-ansible/install.yml"
      
      ansible.verbose = 'vvvv'
      
      ansible.host_key_checking = false
      ansible.sudo = true
        
      ansible.tags = ['base', 'ansible']
      #ansible.skip_tags = ''
      
      ansible.extra_vars = {
          ansible_ssh_user: 'vagrant',
          vagrant_enable: true,
          jenkins_sudo: false
          }
    
      # STATIC INVENTORY
      #ansible.inventory_path = "provision-ansible/hosts/all"
      #ansible.limit = 'vagrant'
        
      # AUTO-GENERATED INVENTORY
      ansible.groups = {
        "group1" => ["zipi"],
        "all_groups:children" => ["group1"],
        #"group1:vars" => { "vagrant_enable" => true }
      }
    end
  end
end