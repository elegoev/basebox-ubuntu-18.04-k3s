# ubuntu-18.04-k3s

Vagrant Box with Ubuntu 18.04 and k3s

## Base image

Used base image [elegoev/ubuntu-18.04-docker](https://app.vagrantup.com/elegoev/boxes/ubuntu-18.04-docker)

## Directory Description

| directory | description                                          |
|-----------|------------------------------------------------------|
| inspec    | inspec test profiles with controls                   |
| packer    | packer build, provisioner and post-processor scripts |
| test      | test environment for provision & inspec development  |

## Vagrant

### Vagrant Cloud

- [elegoev/ubuntu-18.04-k3s](https://app.vagrantup.com/elegoev/boxes/ubuntu-18.04-k3s)

### Vagrant Plugins

- [vagrant-disksize](https://github.com/sprotheroe/vagrant-disksize)
- [vagrant-hosts](https://github.com/oscar-stack/vagrant-hosts)
- [vagrant-secret](https://github.com/tcnksm/vagrant-secret)
- [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
- [vagrant-serverspec](https://github.com/vvchik/vagrant-serverspec)
- [vagrant-vmware-esxi](https://github.com/josenk/vagrant-vmware-esxi)

### Vagrantfile

    Vagrant.configure("2") do |config|

      ENV['VAGRANT_EXPERIMENTAL'] = "disks"

      $basebox_name="ubuntu-18.04-k3s-test"
      $basebox_hostname="ubuntu-1804-k3s-test"
      $src_image_name="elegoev/ubuntu-18.04-k3s"
      $vb_group_name="basebox-k3s-test"

      config.vm.define "#{$basebox_name}" do |machine|
        machine.vm.box = "#{$src_image_name}"
    
        # define guest hostname
        machine.vm.hostname = "#{$basebox_hostname}"

        machine.vm.provider "virtualbox" do |vb|
          vb.name = $basebox_name
          vb.cpus = 1
          vb.customize ["modifyvm", :id, "--memory", "1024" ]
          vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
          vb.customize [
            "modifyvm", :id, "--uartmode1", "file",
            File.join(Dir.pwd, "ubuntu-bionic-18.04-cloudimg-console.log")
          ]
          vb.customize ["modifyvm", :id, "--groups", "/#{$vb_group_name}" ]
          vb.customize ["modifyvm", :id, "--vram", 256 ]
        end

        machine.vm.disk :disk, size: "40GB", primary: true

      end   

    end

## K3S

### Help

    k3s --help

## Referenzen

- [k3s.io](https://k3s.io/)
- [k3s github](https://github.com/rancher/k3s)
- [Youtube - Client-side load balancing in K3s Kubernetes clusters - Darren Shepherd](https://www.youtube.com/watch?v=1Fet0qZdQrM&feature=push-fr&attr_tag=CHXdTQwrjrGmVaZI%3A6)
- [Youtube - K3s Under the Hood: Building a Product-grade Lightweight Kubernetes Distro - Darren Shepherd](https://www.youtube.com/watch?v=-HchRyqNtkU)
- [Running K3s, Lightweight Kubernetes, in Production for the Edge & Beyond - Darren Shepherd, Rancher](https://www.youtube.com/watch?v=aR12Oij4CYw)
- [k3s - Lightweight Kubernetes](https://k3s.io/)
- [k3s Internals: The Crazy Things We Do To Make k8s Simple](https://www.youtube.com/watch?utm_campaign=Kubernetes+Master+Class+Training+Series&utm_medium=email&_hsmi=106166717&_hsenc=p2ANqtz-9nojjUWpAqIUUAjneyQ_T2n9iUg9bp8v1SUbHJSCAHPxxNm6jjVSqUfSST8SdPH3WzNtaDdQoRM13e4QCsEJ5Y1eAOaA&utm_content=106166717&utm_source=hs_email&v=k58WnbKmjdA&feature=youtu.be)
- [Create a Self-Contained and Portable Kubernetes Cluster With K3S and Packer](https://medium.com/better-programming/create-a-self-contained-and-portable-kubernetes-cluster-with-k3s-and-packer-16aa43899e2f)

## Versioning

Repository follows sematic versioning  [![semantic versioning](https://img.shields.io/badge/semver-2.0.0-green.svg)](http://semver.org)

## Changelog

For all notable changes see [CHANGELOG](https://github.com/elegoev/basebox-ubuntu-18.04-k3s/blob/master/CHANGELOG.md)

## License

Licensed under The MIT License (MIT) - for the full copyright and license information, please view the [LICENSE](https://github.com/elegoev/basebox-ubuntu-18.04-k3s/blob/master/LICENSE) file.

## Issue Reporting

Any and all feedback is welcome.  Please let me know of any issues you may find in the bug tracker on github. You can find it [here.](https://github.com/elegoev/basebox-ubuntu-18.04-k3s/issues)
