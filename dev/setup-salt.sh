#!/bin/sh
sudo add-apt-repository ppa:saltstack/salt -y
sudo apt-get update -y
sudo apt-get install salt-minion -y
sudo service salt-minion stop
sudo sed -i 's/#file_client: remote/file_client: local/g' /etc/salt/minion
# setup top files to test the formula
sudo mkdir -p /srv/pillar
sudo ln -s /srv/salt/pillar.example /srv/pillar/btc-node.sls
sudo ln -s /srv/salt/dev/pillar_top.sls /srv/pillar/top.sls
# this file will be copied to make a running config. it should not be checked in.
sudo cp /srv/salt/dev/state_top.sls /srv/salt/top.sls
