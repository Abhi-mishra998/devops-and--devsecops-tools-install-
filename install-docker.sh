  GNU nano 8.3                                                                                    install-docker.sh                                                                                     Modified
#!/bin/bash
# ====================================================
# Script: install-docker.sh
# Description: Install Docker & Docker Compose on Ubuntu
# Author: Abhishek Mishra
# ====================================================

set -e

echo " ~D Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo " M-& Installing dependencies..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release

echo " ~Q Adding Docker’s official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo " ~K Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo " ~D Updating package index..."
sudo apt-get update -y

echo " M-3 Installing Docker Engine, C&I & Compose..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "⚡ Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

echo " M-$ Adding user to docker group..."
sudo usermod -aG docker $USER

echo "✅ Docker installation complete!"
echo "ℹ️  Please log out and log back in (or run 'newgrp docker') to use Docker without sudo."

echo " ~M Verifying installation..."
docker --version
docker compose version

