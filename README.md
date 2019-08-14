## ubuntu-18.04-k3s
Vagrant Box with Ubuntu 18.04 & k3s

### Base image
Used base image [elegoev/ubuntu-18.04](https://app.vagrantup.com/elegoev/boxes/ubuntu-18.04)

### Automatic provisioning
The base image is provisioned with bash script [ubuntu-18.04-k3s.sh](https://github.com/elegoev/vagrant-ubuntu/blob/master/vagrant-ubuntu1804-k3s/provisioning/ubuntu-18.04-k3s.sh)

### References
- [k3s.io](https://k3s.io/)
- [k3s github](https://github.com/rancher/k3s)

###  Create Vagrant Box Environment
#### Provider "virtualbox"
1. Create directory `mkdir "name of directory"`
1. Goto directory `cd "name of directory"`
1. Create Vagrantfile `vagrant init "elegoev/ubuntu-18.04-k3s"`
1. Start vagrant box `vagrant up`

#### Provider "vmware_esxi"
1. Create directory `mkdir "name of directory"`
1. Goto directory `cd "name of directory"`
1. Download basebox `vagrant box add "elegoev/ubuntu-18.04-k3s" --provider vmware_esxi`
1. Create Vagrantfile `vagrant init "elegoev/ubuntu-18.04-k3s"`
1. Create file `metadata.json`
```json
{
    "provider": "vmware_esxi"
}
```
1. Create `box.json` with `vagrant up --provider vmware_esxi`
1. Edit `box.json`
```json
{
  "esxi_hostname": "esxi hostname",
  "esxi_username": "username to access esxi host",
  "esxi_password": "password",
  "esxi_guest_name": "name of guest vm",
  "esxi_disk_storage": "name of datastore",
  "esxi_guest_mem_size": "mem size",
  "esxi_guest_numvcpus": "number of vcpus"
}
```
1. Start vagrant box `vagrant up --provider vmware_esxi`


### Versioning
Repository follows sematic versioning  [![](https://img.shields.io/badge/semver-2.0.0-green.svg)](http://semver.org)

### Changelog
For all notable changes see [CHANGELOG](https://github.com/elegoev/basebox-ubuntu-18.04-k3s/blob/master/CHANGELOG.md)

### License
Licensed under The MIT License (MIT) - for the full copyright and license information, please view the [LICENSE](https://github.com/elegoev/basebox-ubuntu-18.04-k3s/blob/master/LICENSE) file.

### Issue Reporting
Any and all feedback is welcome.  Please let me know of any issues you may find in the bug tracker on github. You can find it [here. ](https://github.com/elegoev/basebox-ubuntu-18.04-k3s/issues)
