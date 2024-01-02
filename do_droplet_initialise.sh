#!/bin/bash 

# Initialising user data on digital ocean
containerd config default > /etc/containerd/config.toml
curl -o alias.sh https://raw.githubusercontent.com/YashrajRathi/Shellscripts/main/linux_alias.sh