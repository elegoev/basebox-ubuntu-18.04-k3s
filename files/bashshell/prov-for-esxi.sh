#!/bin/bash

# Usage:
#
# prov-for-esxi.sh <hostname> <ip address> <netmask> <ip gateway> <ip dnsserver> <dns domain> <dns search>
#

# Ubuntu provisioning file

# ESXi configuration
HOSTNAME=$1     # define hostname
IPADDRESS=$2    # define ip address
NETMASK=$3      # define netmask
GATEWAY=$4      # define gateway address
NAMESERVERS=$5  # define dns nameserver
DOMAIN=$6       # define dns domain
SEARCH=$7       # define dns search

# get ubuntu info
LINUXDISTRIBUTOR=$(lsb_release -i | awk '{print $3}')
LINUXRELEASE=$(lsb_release -r | awk '{print $2}')
echo "Distributor = $LINUXDISTRIBUTOR"
echo "Release     = $LINUXRELEASE"
if [ "$LINUXDISTRIBUTOR" != "Ubuntu" ]
then
	echo "Disribution $LINUXDISTRIBUTOR for provisioning not supported"
	exit
fi


# script configuration
ITFTMPFILE=/tmp/interfaces.tmp
NCFGTMPFILE=/tmp/01-netcfg.yaml.tmp
HOSTSTMPFILE=/tmp/hosts.tmp
HOSTNAMETMPFILE=/tmp/hostname.tmp

# start provisioning
echo "ESXi provisioning started"

# update Ubuntu
sudo apt-get -y update

# install curl and open vmware tools
sudo apt-get -y install curl
sudo apt-get -y install open-vm-tools

# get virtualbox guest additions version
VBOXVERSION=`lsmod | grep -io vboxguest | xargs modinfo | grep -iw version | awk '{print $2}'`
echo "virtualbox guest addition $VBOXVERSION found"
VBOXISONAME=VBoxGuestAdditions_$VBOXVERSION.iso
VBOXISOURL=http://download.virtualbox.org/virtualbox/$VBOXVERSION/$VBOXISONAME
VBOXISOFILE=/tmp/$VBOXISONAME

# check if VBoxGuestAdditions.iso exists
if [ -f "$VBOXISOFILE" ]
then
	echo "$VBOXISOFILE found"
else
	echo "$VBOXISOFILE not found."
  curl $VBOXISOURL --output $VBOXISOFILE
fi

# uninstall virtualbox guest additions
sudo mkdir /media/GuestAdditionsISO
sudo mount -o loop $VBOXISOFILE /media/GuestAdditionsISO
cd /media/GuestAdditionsISO
sudo ./VBoxLinuxAdditions.run uninstall
cd ~
sudo umount /media/GuestAdditionsISO -l
rm -r $VBOXISOFILE


# create interfaces file templates for Ubuntu 16.04
cat > $ITFTMPFILE <<EOT
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet static
    address ##IPADDRESS##
    netmask ##NETMASK##
    gateway ##GATEWAY##
    dns-nameservers ##NAMESERVERS##
    dns-domain ##DOMAIN##
    dns-search ##SEARCH##
EOT

# create interfaces file templates for Ubuntu 16.04
cat > $NCFGTMPFILE <<EOT
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      dhcp6: no
      addresses: [##IPADDRESS##/##NETMASK##]
      gateway4: ##GATEWAY##
      nameservers:
        addresses: [##NAMESERVERS##,8.8.4.4]
EOT

if [ "$LINUXRELEASE" == "16.04" ]
then
	echo "This is Ubuntu 16.04"
	# configure network
	echo "Change network configuration"
	CMD=s/##IPADDRESS##/$IPADDRESS/g
	sed -i $CMD $ITFTMPFILE
	CMD=s/##NETMASK##/$NETMASK/g
	sed -i $CMD $ITFTMPFILE
	CMD=s/##GATEWAY##/$GATEWAY/g
	sed -i $CMD $ITFTMPFILE
	CMD=s/##NAMESERVERS##/$NAMESERVERS/g
	sed -i $CMD $ITFTMPFILE
	CMD=s/##DOMAIN##/$DOMAIN/g
	sed -i $CMD $ITFTMPFILE
	CMD=s/##SEARCH##/$SEARCH/g
	sed -i $CMD $ITFTMPFILE
	sudo cp $ITFTMPFILE /etc/network/interfaces
	rm -r $ITFTMPFILE
	echo "Network configuration changed"
elif [ "$LINUXRELEASE" == "18.04" ]
then
	echo "This is Ubuntu 18.04"
	# configure network
  echo "Change network configuration"
	CMD=s/##IPADDRESS##/$IPADDRESS/g
  sed -i $CMD $NCFGTMPFILE
	CMD=s/##NETMASK##/$NETMASK/g
	sed -i $CMD $NCFGTMPFILE
  CMD=s/##GATEWAY##/$GATEWAY/g
  sed -i $CMD $NCFGTMPFILE
  CMD=s/##NAMESERVERS##/$NAMESERVERS/g
  sed -i $CMD $NCFGTMPFILE
	sudo cp $NCFGTMPFILE /etc/netplan/01-netcfg.yaml
	rm -r $NCFGTMPFILE
else
	echo "Ubuntu $LINUXRELEASE for network provisioning not supported"
fi

# create /etc/hosts template
cat > $HOSTSTMPFILE <<EOT
127.0.0.1 localhost
127.0.0.1 ##HOSTNAME##
##IPADDRESS## ##HOSTNAME##
EOT

# configure hosts file
echo "Change hosts configuration"
CMD=s/##IPADDRESS##/$IPADDRESS/g
sed -i $CMD $HOSTSTMPFILE
CMD=s/##HOSTNAME##/$HOSTNAME/g
sed -i $CMD $HOSTSTMPFILE
sudo cp $HOSTSTMPFILE /etc/hosts
rm -r $HOSTSTMPFILE
echo "Hosts configuration changed"

# create /etc/hostname template
cat > $HOSTNAMETMPFILE <<EOT
##HOSTNAME##
EOT

# configure hosts file
echo "Change hostname configuration"
CMD=s/##HOSTNAME##/$HOSTNAME/g
sed -i $CMD $HOSTNAMETMPFILE
sudo cp $HOSTNAMETMPFILE /etc/hostname
rm -r $HOSTNAMETMPFILE
echo "Hostname configuration changed"

# provisioning finished
echo "ESXi provisioning finished"
