# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'pathname'
require 'yaml'

ROOT_DIR                    = File.expand_path(File.dirname(__FILE__))
VAGRANT_DIR                 = File.expand_path(".vagrant", ROOT_DIR)
ANSIBLE_DIR                 = File.expand_path("ansible", ROOT_DIR)

Dir.chdir(ROOT_DIR)

Vagrant.configure("2") do |config|
  # Vagrant currently has a bug. enp0s8 won't be up on the CentOS Docker box.
  config.trigger.after [:provision, :up, :reload] do
    begin
      run_remote "ifup enp0s8"
    end
  end

  env_config = { update_buster: true, build_buster: true, version_buster: "master" }

  if File.exists?("configuration.yml")
    env_config = env_config.merge(YAML::load(File.open("configuration.yml")) || {})
  end

  config.vm.box = "bento/centos-7.3"

  config.vm.network :private_network, ip: "192.168.34.172"

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "ansible/host.yml"
    ansible.verbose = true
    ansible.extra_vars = env_config
  end
end
