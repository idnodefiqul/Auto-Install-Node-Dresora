#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check command success
check_error() {
    if [ $? -ne 0 ]; then
        print_status "${RED}" "Error: $1"
        exit 1
    fi
}

print_status "${BLUE}" "====================================="
print_status "${GREEN}" "Drosera Auto-Installer - Enhanced Edition"
print_status "${BLUE}" "====================================="

# Update and upgrade system
print_status "${YELLOW}" "Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y
check_error "Failed to update system packages"

# Install required packages
print_status "${YELLOW}" "Installing required packages..."
sudo apt install -y curl ufw iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev
check_error "Failed to install required packages"

# Remove old Docker installations
print_status "${YELLOW}" "Removing old Docker installations..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do 
    sudo apt-get remove -y $pkg 2>/dev/null
done

# Install Docker
print_status "${YELLOW}" "Installing Docker..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
check_error "Failed to download Docker GPG key"
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
check_error "Failed to setup Docker repository"

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
check_error "Failed to install Docker"

# Test Docker
print_status "${YELLOW}" "Testing Docker installation..."
sudo docker run hello-world
check_error "Docker test failed"

# Install Drosera
print_status "${YELLOW}" "Installing Drosera..."
curl -L https://app.drosera.io/install | bash
check_error "Drosera installation failed"

# Ensure .bashrc is properly sourced and PATH is updated
print_status "${YELLOW}" "Configuring PATH and sourcing .bashrc..."
if [ -f /root/.bashrc ]; then
    # Export PATH to include Drosera's binary directory
    export PATH=$PATH:/root/.drosera/bin
    echo 'export PATH=$PATH:/root/.drosera/bin' >> /root/.bashrc
    source /root/.bashrc
    echo "source /root/.bashrc" >> /root/.bash_profile
else
    print_status "${RED}" "Warning: .bashrc not found, creating new one"
    touch /root/.bashrc
    echo 'export PATH=$PATH:/root/.drosera/bin' >> /root/.bashrc
    source /root/.bashrc
fi

# Verify droseraup is available
print_status "${YELLOW}" "Verifying droseraup availability..."
if ! command -v droseraup &> /dev/null; then
    print_status "${RED}" "Error: droseraup command not found. Attempting to locate..."
    if [ -f /root/.drosera/bin/droseraup ]; then
        print_status "${YELLOW}" "Found droseraup in /root/.drosera/bin. Adding to PATH..."
        chmod +x /root/.drosera/bin/droseraup
        export PATH=$PATH:/root/.drosera/bin
        source /root/.bashrc
    else
        print_status "${RED}" "Error: Could not locate droseraup. Please check Drosera installation."
        exit 1
    fi
fi

# Run droseraup
print_status "${YELLOW}" "Running droseraup..."
droseraup
check_error "droseraup failed"

# Install Foundry
print_status "${YELLOW}" "Installing Foundry..."
curl -L https://foundry.paradigm.xyz | bash
check_error "Foundry installation failed"

# Update PATH for Foundry and source .bashrc
print_status "${YELLOW}" "Configuring PATH for Foundry..."
export PATH=$PATH:/root/.foundry/bin
echo 'export PATH=$PATH:/root/.foundry/bin' >> /root/.bashrc
source /root/.bashrc

# Verify foundryup is available
print_status "${YELLOW}" "Verifying foundryup availability..."
if ! command -v foundryup &> /dev/null; then
    print_status "${RED}" "Error: foundryup command not found. Attempting to locate..."
    if [ -f /root/.foundry/bin/foundryup ]; then
        print_status "${YELLOW}" "Found foundryup in /root/.foundry/bin. Adding to PATH..."
        chmod +x /root/.foundry/bin/foundryup
        export PATH=$PATH:/root/.foundry/bin
        source /root/.bashrc
    else
        print_status "${RED}" "Error: Could not locate foundryup. Please check Foundry installation."
        exit 1
    fi
fi

# Run foundryup
print_status "${YELLOW}" "Running foundryup..."
foundryup
check_error "foundryup failed"

# Install Bun
print_status "${YELLOW}" "Installing Bun..."
curl -fsSL https://bun.sh/install | bash
check_error "Bun installation failed"

# Update PATH for Bun
print_status "${YELLOW}" "Configuring PATH for Bun..."
export PATH=$PATH:/root/.bun/bin
echo 'export PATH=$PATH:/root/.bun/bin' >> /root/.bashrc
source /root/.bashrc

# Setup project directory
print_status "${YELLOW}" "Setting up Drosera trap..."
mkdir -p my-drosera-trap
cd my-drosera-trap

# GitHub configuration
print_status "${YELLOW}" "Configuring GitHub..."
read -p "Enter GitHub Username: " USER_GH
read -p "Enter GitHub Email: " EMAIL_GH
git config --global user.name "$USER_GH"
git config --global user.email "$EMAIL_GH"
check_error "GitHub configuration failed"

# Initialize trap
print_status "${YELLOW}" "Initializing trap..."
forge init -t drosera-network/trap-foundry-template
check_error "Trap initialization failed"

# Compile trap
print_status "${YELLOW}" "Compiling trap..."
bun install
forge build
check_error "Trap compilation failed"

# Deploy trap
print_status "${YELLOW}" "Deploying trap..."
read -p "Enter Private Key: " KEYY
DROSERA_PRIVATE_KEY=$KEYY drosera apply
check_error "Trap deployment failed"

# Wait for deposit
print_status "${YELLOW}" "Please deposit or send Bloom Boost ETH on Holesky at https://app.drosera.io"
read -p "Press ENTER to continue after deposit: "

# Dry run
print_status "${YELLOW}" "Running dryrun..."
drosera dryrun
check_error "Dryrun failed"

# Operator setup
print_status "${YELLOW}" "Setting up operator..."
read -p "Enter Operator ETH Wallet Address: " OP_ETH

# Update drosera.toml
print_status "${YELLOW}" "Updating drosera.toml..."
cat << EOF >> $HOME/my-drosera-trap/drosera.toml
private_trap = true
whitelist = ["$OP_ETH"]
EOF
check_error "Failed to update drosera.toml"

DROSERA_PRIVATE_KEY=$KEYY drosera apply
check_error "Second drosera apply failed"

# Install Operator CLI
print_status "${YELLOW}" "Installing Operator CLI..."
curl -LO https://github.com/drosera-network/releases/releases/download/v1.16.2/drosera-operator-v1.16.2-x86_64-unknown-linux-gnu.tar.gz
check_error "Failed to download Operator CLI"
tar -xvf drosera-operator-v1.16.2-x86_64-unknown-linux-gnu.tar.gz
sudo cp drosera-operator /usr/bin
check_error "Failed to install Operator CLI"

# Verify Operator CLI
drosera-operator --version
check_error "Operator CLI verification failed"

# Register operator
print_status "${YELLOW}" "Registering operator..."
drosera-operator register --eth-rpc-url https://ethereum-holesky-rpc.publicnode.com --eth-private-key $KEYY
check_error "Operator registration failed"

# Setup systemd service
print_status "${YELLOW}" "Creating Drosera systemd service..."
IP4=$(curl -s https://api64.ipify.org)
cat << EOF | sudo tee /etc/systemd/system/drosera.service > /dev/null
[Unit]
Description=Drosera node service
After=network-online.target

[Service]
User=$USER
Restart=always
RestartSec=15
LimitNOFILE=65535
ExecStart=/usr/bin/drosera-operator node --db-file-path "$HOME/.drosera.db" --network-p2p-port 31313 --server-port 31314 \
    --eth-rpc-url "https://ethereum-holesky-rpc.publicnode.com" \
    --eth-backup-rpc-url "https://1rpc.io/holesky" \
    --drosera-address "0xea08f7d533C2b9A62F40D5326214f39a8E3A32F8" \
    --eth-private-key "$KEYY" \
    --listen-address "0.0.0.0" \
    --network-external-p2p-address "$IP4" \
    --disable-dnr-confirmation true

[Install]
WantedBy=multi-user.target
EOF
check_error "Failed to create systemd service"

# Configure firewall
print_status "${YELLOW}" "Configuring firewall..."
sudo ufw allow ssh
sudo ufw allow 22
sudo ufw allow 31313/tcp
sudo ufw allow 31314/tcp
sudo ufw --force enable
check_error "Failed to configure firewall"

# Start service
print_status "${YELLOW}" "Starting Drosera service..."
sudo systemctl daemon-reload
sudo systemctl enable drosera
sudo systemctl start drosera
check_error "Failed to start Drosera service"

print_status "${GREEN}" "====================================="
print_status "${GREEN}" "Installation Complete!"
print_status "${GREEN}" "====================================="
print_status "${YELLOW}" "Useful Commands:"
print_status "${BLUE}" "Check logs: journalctl -u drosera.service -f"
print_status "${BLUE}" "Check status: sudo systemctl status drosera"
print_status "${BLUE}" "Note: If status shows error or no logs, try rebooting the VPS"
print_status "${GREEN}" "====================================="
