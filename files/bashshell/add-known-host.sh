#!/bin/bash

# add known host
sudo ssh-keyscan -H $1 >> /home/vagrant/.ssh/known_hosts
sudo chown -R vagrant /home/vagrant/.ssh
sudo chgrp -R vagrant /home/vagrant/.ssh
