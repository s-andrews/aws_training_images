#!/usr/bin/env bash

set -euo pipefail

# Install required tools
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg

# Add CRAN GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
  | sudo gpg --dearmor -o /etc/apt/keyrings/cran.gpg

# Add CRAN repository for Ubuntu 24.04 (Noble)
echo "deb [signed-by=/etc/apt/keyrings/cran.gpg] https://cloud.r-project.org/bin/linux/ubuntu noble-cran40/" \
  | sudo tee /etc/apt/sources.list.d/cran-r.list

# Update package lists
sudo apt-get update

# Install R
sudo apt-get install -y r-base r-base-dev

# Verify installation
R --version
