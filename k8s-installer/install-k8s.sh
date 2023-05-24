#!/bin/bash
sudo kubeadm init --pod-network-cidr "192.168.0.0/16" --cri-socket "unix://run/containerd/containerd.sock" | tee kube.out

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/custom-resources.yaml