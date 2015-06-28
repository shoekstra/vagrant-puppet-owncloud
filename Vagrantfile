# -*- mode: ruby -*-
# vi: set ft=ruby :

%x(vagrant plugin install vagrant-cachier) unless Vagrant.has_plugin?('vagrant-cachier')
%x(vagrant plugin install vagrant-librarian-puppet) unless Vagrant.has_plugin?('vagrant-librarian-puppet')
%x(vagrant plugin install vagrant-puppet-install) unless Vagrant.has_plugin?('vagrant-puppet-install')

puppet_nodes = [
  {:name => 'centos6', :box => 'puppetlabs/centos-6.6-64-nocm'},
  {:name => 'centos7', :box => 'puppetlabs/centos-7.0-64-nocm'},
  {:name => 'debian6', :box => 'puppetlabs/debian-6.0.10-64-nocm'},
  {:name => 'debian7', :box => 'puppetlabs/debian-7.8-64-nocm'},
  {:name => 'debian8', :box => 'debian/jessie64'},
  {:name => 'ubuntu12', :box => 'puppetlabs/ubuntu-12.04-64-nocm'},
  {:name => 'ubuntu14', :box => 'puppetlabs/ubuntu-14.04-64-nocm'},
]

Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    config.cache.synced_folder_opts = {
      type: :nfs,
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
    # For more information see https://docs.vagrantup.com/v2/synced-folders/nfs.html
  end

  if Vagrant.has_plugin?("vagrant-librarian-puppet")
    # Managed puppet/modules directory for us.
    # More info on https://github.com/mhahn/vagrant-librarian-puppet
    config.librarian_puppet.puppetfile_dir = "puppet"
    # config.librarian_puppet.destruct = false
  end

  if Vagrant.has_plugin?("vagrant-puppet-install")
    # Installs Puppet for us because we're lazy.
    # More info on https://github.com/petems/vagrant-puppet-install
    config.puppet_install.puppet_version = '3.7.5'
  end

  # Puppet shared folder
  # config.vm.share_folder "puppet_mount", "/puppet", "puppet"
  config.vm.synced_folder 'puppet/modules/', '/etc/puppet/modules/'

  # VM network config
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 443, host: 8443
  config.vm.network :private_network, ip: "192.168.72.10"

  puppet_nodes.each do |node|
    config.vm.define node[:name], autostart: false do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.hostname = node[:name] + '.example.com'
    end
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "site.pp"
    puppet.module_path    = "puppet/modules"
    puppet.options        = "--verbose --show_diff"
  end
end
