# -*- mode: ruby -*-
# vi: set ft=ruby :
# _meta parameters for VMs:
#  - vagrant_image - defaults to ubuntu/trusty64
#  - vagrant_ram - defaults 256

require 'json'
require 'pp'

# get configured vagrant boxes
filelist = Dir.glob("./provisioning/*.json")
filelist.each do |filepath|
  filename = File.basename("#{filepath}", ".json")
end

#--- get json from "bin/inventory --list"
hosts = Hash.new

filelist.each do |filepath|

  host = File.basename("#{filepath}", ".json")

  # get vagrant parameters
  if File.exist?("./provisioning/%s.json" % host)
    config_file = File.read("./provisioning/%s.json" % host)
    config_data = JSON.parse(config_file)
  else
    puts "Konfiguration ./provisioning/#{host}.json for #{host} not found"
    exit
  end

  # get image namespace
  $imagedata = config_data["hostvars"]["vagrant_image"].split('/')
  $namespace = $imagedata[0]

  if ($namespace == "vagrant-epr-dev")
    $boxname = $imagedata[1]
  elsif ($namespace == "conextade-vagrant-dev-local")
    $boxname = $imagedata[1]
  elsif ($namespace == "local")
    $boxname = config_data["hostvars"]["vagrant_image"]
    $boxdirname = $imagedata[1]
  else
    $boxname = (config_data["hostvars"]["vagrant_image"] != nil && config_data["hostvars"]["vagrant_image"] != "")?config_data["hostvars"]["vagrant_image"]:"ubuntu/trusty64"
  end

  # set parameter
  hosts[host] = { "vagrant_image"           => config_data["hostvars"]["vagrant_image"],
                  "vagrant_image_version"   => config_data["hostvars"]["vagrant_image_version"],
                  "vagrant_boxname"         => $boxname,
                  "vagrant_namespace"       => $namespace,
                  "vagrant_ram"             => config_data["hostvars"]["vagrant_ram"],
                  "vagrant_cpu"             => config_data["hostvars"]["vagrant_cpu"],
                  "vagrant_net"             => config_data["hostvars"]["vagrant_net"],
                  "vb_hostname"             => config_data["hostvars"]["vb_hostname"],
                  "vb_guest_os"             => config_data["hostvars"]["vb_guest_os"],
                  "vb_group"                => config_data["hostvars"]["vb_group"],
                  "vb_gateway"              => config_data["hostvars"]["vb_gateway"],
                  "vb_dnshostresolve"       => config_data["hostvars"]["vb_dnshostresolve"],
                  "vb_network"              => config_data["hostvars"]["vb_network"],
                  "vb_port_forwarding"      => config_data["hostvars"]["vb_port_forwarding"],
                  "vb_share"                => config_data["hostvars"]["vb_share"],
                  "vb_shell_provisioner"    => config_data["hostvars"]["vb_shell_provisioner"],
                  "vb_ansible_provisioner"  => config_data["hostvars"]["vb_ansible_provisioner"],
                  "vb_rdp_port"             => config_data["hostvars"]["vb_rdp_port"],
                }

end

#--- use the host variable to set up the VMs
Vagrant.configure("2") do |config|
  hosts.each do |name, hostInfo|
    config.vm.define name do |machine|
      machine.vm.box = hostInfo["vagrant_boxname"]
      if (hostInfo["vagrant_namespace"] == "vagrant-epr-dev")
        # set vagrant-epr-dev environment
        ENV['ATLAS_TOKEN'] = ENV['VAGRANT_ARTIFACTORY_ATLASTOKEN_CONEXTRADE']
        $repobaseurl = ENV['VAGRANT_REPO_URL_CONEXTRADE']
        $repourl     = "#{$repobaseurl}/artifactory/api/vagrant"
        ENV['VAGRANT_SERVER_URL'] = "#{$repourl}"
        # set box url
        machine.vm.box_url = "#{$repourl}/vagrant-epr-dev/#{hostInfo["vagrant_boxname"]}"
      elsif (hostInfo["vagrant_namespace"] == "conextade-vagrant-dev-local")
        # set vagrant-epr-dev environment
        ENV['ATLAS_TOKEN'] = ENV['VAGRANT_ARTIFACTORY_ATLASTOKEN_SWISSCOM']
        $repobaseurl = ENV['VAGRANT_REPO_URL_SWISSCOM']
        $repourl     = "#{$repobaseurl}/api/vagrant"
        ENV['VAGRANT_SERVER_URL'] = "#{$repourl}"
        # set box url
        machine.vm.box_url = "#{$repourl}/conextade-vagrant-dev-local/#{hostInfo["vagrant_boxname"]}"
      elsif (hostInfo["vagrant_namespace"] == "local")
        $repohome = ENV['VAGRANT_REPO_LOCAL']
        if (hostInfo["vagrant_image_version"] != nil && hostInfo["vagrant_image_version"] != "")
          machine.vm.box_url = "#{$repohome}/#{$boxdirname}/#{$boxdirname}-#{hostInfo["vagrant_image_version"]}.json"
        else
          machine.vm.box_url = "#{$repohome}/#{$boxdirname}/#{$boxdirname}.json"
        end
      end
      if (hostInfo["vagrant_image_version"] != nil && hostInfo["vagrant_image_version"] != "")
        machine.vm.box_version = hostInfo["vagrant_image_version"]
      end
      if (hostInfo["vb_hostname"] != nil)
        machine.vm.hostname = "%s" % hostInfo["vb_hostname"]
      else
        machine.vm.hostname = "%s" % name
      end

      if (hostInfo["vb_guest_os"] == "win")
        machine.vm.communicator = "winrm"
        machine.vbguest.auto_update = false
     end

      # define description
      $version = (hostInfo["vagrant_image_version"] != nil && hostInfo["vagrant_image_version"] != "")?hostInfo["vagrant_image_version"]:"latest"
      $description = "Baseimage: " + hostInfo["vagrant_image"] + " (" + $version + ")"

      # create network cards
      if (hostInfo["vb_network"] != nil)
        hostInfo["vb_network"].each do |network|
          if (network["nettype"] == nil || network["nettype"] == "internal")
             if (network["netname"] == nil)
                $netname = "internal-net"
             else
                $netname = network["netname"]
             end
             machine.vm.network :private_network, ip: network["ip"],  netmask: network["netmask"], virtualbox__intnet: $netname, nic_type: network["nictype"], :mac => network["mac"]
          elsif (network["nettype"] == "hostonly")
             if (network["netname"] == nil)
                $adaptername = "VirtualBox Host-Only Ethernet Adapter"
             else
                $adaptername = network["adapter"]
             end
             machine.vm.network "private_network", ip: network["ip"],  netmask: network["netmask"], nic_type: network["nictype"], :name => $adaptername, :mac => network["mac"]
          else
             puts "Unknown net type #{network["nettype"]}"
          end
        end
      end

      # create port forwarding
      if (hostInfo["vb_port_forwarding"] != nil && hostInfo["vb_port_forwarding"] != "")
        hostInfo["vb_port_forwarding"].each do |forwarding|
          forwarding["host_ip"] == nil       ? ($fwhostip = "127.0.0.1")  : ($fwhostip = forwarding["host_ip"])
          machine.vm.network "forwarded_port", id: forwarding["id"], auto_correct: forwarding["auto_correct"], protocol: forwarding["protocol"], guest: forwarding["guest"], host: forwarding["host"], host_ip: $fwhostip, guest_ip: forwarding["guest_ip"]
        end
      end

      # create rdp forwarding
      if (hostInfo["vb_rdp_port"] != nil && hostInfo["vb_rdp_port"] != "" )
         machine.vm.network "forwarded_port", guest: 3389, host: hostInfo["vb_rdp_port"], host_ip: "127.0.0.1"
      end

      machine.vm.provider "virtualbox" do |v|
          v.name = name
          v.cpus = (hostInfo["vagrant_cpu"] != nil && hostInfo["vagrant_cpu"] != "")?hostInfo["vagrant_cpu"]:2
          ram = (hostInfo["vagrant_ram"] != nil && hostInfo["vagrant_ram"] != "")?hostInfo["vagrant_ram"]:512
          v.customize ["modifyvm", :id, "--description", "#{$description}"]
          v.customize ["modifyvm", :id, "--memory", ram ]
          if (hostInfo["vb_dnshostresolve"] == true)
		        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
          end
          v.customize ["modifyvm", :id, "--groups", "/%s" % hostInfo["vb_group"] ]
      end

      # Define ssh configuration
      machine.ssh.insert_key = false

      # Autoconfigure hosts. This will copy the private network addresses from
      # each VM and update hosts entries on all other machines. No further
      # configuration is needed.
      machine.vm.provision :hosts, :sync_hosts => true, :run => 'always'

      # create standard kitchen shared_files share
      machine.vm.synced_folder ".", "/vagrant", owner: "vagrant", group: "vagrant", mount_options: ["dmode=775,fmode=774"]
      $shareddirname = "%s/shared_files" % ENV['VAGRANT_KITCHEN_ROOT']
      if File.directory?($shareddirname)
        machine.vm.synced_folder $shareddirname, "/shared_files", SharedFoldersEnableSymlinksCreate: true
      else
        puts "shared_files directory doesn't exists"
      end

      # create share
      if (hostInfo["vb_share"] != nil && hostInfo["vb_share"] != "")
        hostInfo["vb_share"].each do |share|
          machine.vm.synced_folder "#{share["srcdir"]}", "#{share["desdir"]}", SharedFoldersEnableSymlinksCreate: true
        end
      end

      # search for provisioning file (without ps1 extension)
      if (hostInfo["vb_shell_provisioner"] != nil && hostInfo["vb_shell_provisioner"] != "")
        hostInfo["vb_shell_provisioner"].each do |provisioner|
          if File.exist?("./provisioning/%s" % provisioner["script"])
            machine.vm.provision "shell" do |cmd|
                cmd.path = "./provisioning/%s" % provisioner["script"]
            end
          else
            puts "Provisioning file #{provisioner["script"]} doesn't exists"
          end
        end
      end

      # configure default gateway for unix based system
      if (hostInfo["vb_gateway"] != nil && hostInfo["vb_gateway"] != "")
        if (hostInfo["vb_guest_os"] == "ubuntu")
          $gateway = hostInfo["vb_gateway"]
          machine.vm.provision "shell" do |cmd|
            cmd.path = "./files/bashshell/ubuntu-set-gateway.sh"
            cmd.args = [hostInfo["vb_gateway"]]
          end
        elsif (hostInfo["vb_guest_os"] == "centos")
          $gateway = hostInfo["vb_gateway"]
          machine.vm.provision "shell" do |cmd|
            cmd.path = "./files/bashshell/centos-set-gateway.sh"
            cmd.args = [hostInfo["vb_gateway"]]
          end
        elsif (hostInfo["vb_guest_os"] == "win")
          hostInfo["vb_network"].each do |network|
            machine.vm.provision "shell" do |cmd|
              cmd.path = "./files/powershell/win-set-gateway.ps1"
              cmd.args = [ network["ip"],
                           hostInfo["vb_gateway"]
                         ]
            end
          end
        else
          $osname = hostInfo["vb_guest_os"]
          puts "OS #{$osname} not supported"
        end
      end

      if (hostInfo["vb_ansible_provisioner"] != nil && hostInfo["vb_ansible_provisioner"] != "")
        hostInfo["vb_ansible_provisioner"].each do |provisioner|
          # ansible provisioning
          machine.vm.provision :ansible_local do |ansible|
            ansible.playbook          = provisioner["playbook"]
            ansible.provisioning_path = provisioner["provisioning_path"]
            ansible.verbose           = provisioner["verbose"]
            ansible.install           = provisioner["install"]
            ansible.limit             = provisioner["limit"]
            ansible.inventory_path    = provisioner["inventory_path"]
          end
        end
      end

    end
  end
end
