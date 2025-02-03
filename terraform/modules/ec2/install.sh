#!/bin/bash

# Update existing packages
sudo apt update -y

# Install required packages (ca-certificates, curl, gnupg)
sudo apt install -y ca-certificates curl gnupg tar jq

# Add Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the official Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update packages again to include the Docker repository
sudo apt update -y

# Install Docker and Docker Compose
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to Docker group
sudo usermod -aG docker $USER
sudo newgrp docker

# Install Nginx
sudo apt install -y nginx

# Remove the default nginx file
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default

# Ensure Nginx is started and enabled
sudo systemctl enable nginx
sudo systemctl start nginx

# Start and enable the Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Configure self-hosted runner under user 'ubuntu'

# Create the runner directory in the ubuntu user's home path
sudo -u ubuntu mkdir -p /home/ubuntu/actions-runner && cd /home/ubuntu/actions-runner

# Download the latest runner package
sudo -u ubuntu curl -o actions-runner-linux-x64-2.321.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-linux-x64-2.321.0.tar.gz

# Extract the runner package
sudo -u ubuntu tar xzf ./actions-runner-linux-x64-2.321.0.tar.gz

# Configuring runner variables
RUNNER_NAME="server-ip-$(curl ifconfig.me)"
RUNNER_GROUP="Default"
WORK_FOLDER="_work"
LABELS="self-hosted,Linux,X64,server"
REPO="{{ env.GITHUB_REPOSITORY }}"

# Send the request to obtain the runner registration token
RESPONSE=$(curl -L -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer {{ secrets.RUNNER_GITHUB_TOKEN }}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$REPO/actions/runners/registration-token")

# Extract token from JSON response using jq
RUNNER_TOKEN=$(echo $RESPONSE | jq -r .token)

# Configure self-hosted runner
sudo -u ubuntu ./config.sh --url "https://github.com/$REPO" \
                           --token "$RUNNER_TOKEN" \
                           --name "$RUNNER_NAME" \
                           --runnergroup "$RUNNER_GROUP" \
                           --labels "$LABELS" \
                           --work "$WORK_FOLDER"

# Install and start the runner service
sudo ./svc.sh install
sudo ./svc.sh start
