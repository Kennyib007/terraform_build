#!/bin/bash

ARCH=$(arch)

# Preparing environment by installing Docker
sudo yum update -y
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Add Docker repository for Amazon Linux/RHEL/CentOS
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io

sudo systemctl enable docker
sudo systemctl start docker

# Add current user to docker group
sudo usermod -aG docker $USER

# Refresh user groups in current shell
newgrp docker

# Install kubectl and Minikube based on architecture
if [ "$ARCH" = "x86_64" ]; then
    echo "Executing on $ARCH"

    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl

    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube

elif [ "$ARCH" = "aarch64" ]; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
    sudo install minikube-linux-arm64 /usr/local/bin/minikube

    # Install kubectl via Amazon Linux's snap or alternate method if snap isn't available
    if command -v snap &> /dev/null; then
        sudo snap install kubectl --classic
    else
        curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/arm64/kubectl"
        chmod +x ./kubectl
        sudo mv ./kubectl /usr/local/bin/kubectl
    fi
fi

echo "Docker and Kubernetes tools installed successfully!"
echo "You can now run: minikube start --vm-driver=docker --memory=6G --cni=calico"
```
