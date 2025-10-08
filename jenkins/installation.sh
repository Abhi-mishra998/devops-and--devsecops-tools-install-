#!/bin/bash

# --------------------------------------------------------
# Jenkins + Java 21 + Maven + Git Setup Script
# Works on: Ubuntu / Debian systems
# Author: Abhishek Mishra 
# --------------------------------------------------------

set -e  # Exit if any command fails

# --- COLORS ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW} Updating system packages...${NC}"
sudo apt update -y && sudo apt upgrade -y

# --- INSTALL GIT ---
echo -e "${GREEN} Installing Git...${NC}"
sudo apt install git -y
git --version

# --- INSTALL JAVA 21 (LTS) ---
echo -e "${GREEN}  Installing OpenJDK 21 (LTS)...${NC}"
sudo apt install -y fontconfig openjdk-21-jre
java -version

# --- INSTALL MAVEN 3.9.11 (Manual installation for latest version) ---
echo -e "${GREEN}  Installing Maven 3.9.11...${NC}"
cd /opt
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.tar.gz
sudo tar -xvzf apache-maven-3.9.11-bin.tar.gz
sudo mv apache-maven-3.9.11 maven
sudo rm -f apache-maven-3.9.11-bin.tar.gz

# --- SETUP MAVEN ENVIRONMENT VARIABLES ---
echo -e "${GREEN}  Configuring Maven environment variables...${NC}"
sudo tee /etc/profile.d/maven.sh > /dev/null << 'EOF'
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
EOF

sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
mvn -version

# --- INSTALL JENKINS ---
echo -e "${GREEN} Installing Jenkins...${NC}"

# Add Jenkins key and repo
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update and install Jenkins
sudo apt update -y
sudo apt install -y jenkins

# --- ENABLE & START JENKINS ---
echo -e "${GREEN}  Enabling and starting Jenkins service...${NC}"
sudo systemctl enable jenkins
sudo systemctl start jenkins

# --- FIREWALL CONFIGURATION (optional) ---
if command -v ufw &> /dev/null; then
  echo -e "${GREEN}  Allowing Jenkins port (8080)...${NC}"
  sudo ufw allow 8080
  sudo ufw reload
fi

# --- DISPLAY INITIAL ADMIN PASSWORD ---
echo -e "${YELLOW}🔑 Jenkins initial admin password:${NC}"
echo "-------------------------------------------------------------"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword || echo "Password not available yet. Wait 1–2 minutes."
echo "-------------------------------------------------------------"

echo -e "${GREEN} Jenkins Setup Completed Successfully!${NC}"
echo -e " Access Jenkins: ${YELLOW}http://<your-server-ip>:8080${NC}"
echo -e "Use the above password to unlock Jenkins."
