#!/bin/bash

# Update the system
sudo apt update
sudo apt upgrade -y

# Install Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce -y

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Install Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo add-apt-repository "deb https://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt update
sudo apt install kubeadm kubelet kubectl -y

# Initialize Kubernetes on master node
sudo kubeadm init

# Set up Kubernetes configuration
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install a network plugin
sudo kubectl apply -f https://docs.projectcalico.org/v3.21/manifests/calico.yaml

# Join worker nodes (use the command from kubeadm init output)
echo "Please run the following command on your worker nodes to join them to the cluster:"
echo "sudo kubeadm join <MASTER_NODE_IP>:<MASTER_NODE_PORT> --token <TOKEN> --discovery-token-ca-cert-hash <CERT_HASH>"

# Print instructions for configuring kubectl
echo "Kubernetes installation completed."
echo "To use kubectl, run the following command on your master node:"
echo "export KUBECONFIG=$HOME/.kube/config"
