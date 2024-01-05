#!/bin/bash

PRIVATE_IP=$(curl -w "\n" http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)
IFS='.' read -r -a array <<< "$PRIVATE_IP"
kubeadm init --apiserver-advertise-address $PRIVATE_IP --pod-network-cidr=${array[0]}.${array[1]}.0.0/16