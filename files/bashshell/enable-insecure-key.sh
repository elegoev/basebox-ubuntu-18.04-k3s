#!/bin/bash

# copy insecure ssh key
sudo chown -R vagrant /home/vagrant/.ssh
sudo chgrp -R vagrant /home/vagrant/.ssh
sudo cp /vagrant/files/keys/vagrant_insecure_private_key /home/vagrant/.ssh/id_rsa
sudo chmod 600 /home/vagrant/.ssh/id_rsa
