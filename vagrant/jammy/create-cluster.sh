#!/bin/bash

sudo kubeadm init --pod-network-cidr "192.168.0.0/16" --apiserver-advertise-address "172.16.0.100" | tee ~vagrant/kube.out
sudo chown vagrant:vagrant ~vagrant/kube.out

mkdir -p ~vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf ~vagrant/.kube/config
sudo chown vagrant:vagrant ~vagrant/.kube/config

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

helm repo add cilium https://helm.cilium.io
helm repo update
helm template cilium cilium/cilium --version 1.14.1 --namespace kube-system > /tmp/cilium.yaml

sudo -i -u vagrant kubectl apply -f /tmp/cilium.yaml

tail -2 ~vagrant/kube.out > /vagrant/join-cluster.sh

sudo -i -u vagrant echo "source <(kubectl completion bash)" >> ~vagrant/.bashrc
#sudo -i -u vagrant kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/tigera-operator.yaml
#sudo -i -u vagrant kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/custom-resources.yaml
