#!/bin/bash

sudo yum install -y nfs-utils nfs-utils-lib

sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl enable nfs-lock
sudo systemctl enable nfs-idmap

sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo systemctl start nfs-lock
sudo systemctl start nfs-idmap

# /data/shared     192.168.1.0/24(rw,sync,no_root_squash,no_all_squash)
sudo vim /etc/exports

sudo systemctl restart nfs-server
