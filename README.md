# Auto-Install-Node-Dresora
Drosera Node Auto-Installer
This repository provides an automated installation script for setting up a Drosera node. Follow the instructions below to install and configure the node using the provided script.
Prerequisites

A VPS running Ubuntu (preferably 20.04 or 22.04).
Root access or a user with sudo privileges.
Stable internet connection.
Basic knowledge of terminal commands.

Installation Steps
1. Start a Screen Session
To ensure the installation process continues even if your SSH session disconnects, use the screen command to create a persistent session.
Run the following command to start a new screen session named dresora:
screen -S dresora

This will open a new screen session where you can run the installation script.
2. Notes on Using Screen

Why use screen? It allows the installation to continue running in the background if your terminal session is interrupted (e.g., due to network issues).
Basic Screen Commands:
Detach from the session: Press Ctrl + A, then D to detach and return to your main terminal. The session will keep running.
Reattach to the session: Run screen -r dresora to return to the dresora session.
List all screen sessions: Run screen -ls to see all active sessions.
Exit the session: When done, type exit inside the screen session to close it.


If screen is not installed, you can install it with:sudo apt install screen



3. Run the Auto-Installer Script
Inside the dresora screen session, execute the following command to download and run the auto-installer script directly from GitHub:
curl -fsSL https://raw.githubusercontent.com/idnodefiqul/Auto-Install-Node-Dresora/main/autodresora.sh | bash

This command will:

Download the autodresora.sh script from the repository.
Execute it in your terminal, installing all required dependencies and configuring the Drosera node.

4. Follow the Script's Instructions
The script is interactive and will prompt you for inputs during execution, such as:

GitHub username and email.
Private key for deployment.
Operator ETH wallet address.
Confirmation to proceed after depositing Bloom Boost ETH on Holesky.

Follow the on-screen prompts carefully to complete the installation. The script will:

Install dependencies (Docker, Foundry, Bun, etc.).
Configure the Drosera node and operator CLI.
Set up a systemd service for the node.
Configure the firewall.

5. Post-Installation
After the script completes, it will display useful commands to monitor the node:

Check logs: journalctl -u drosera.service -f
Check status: sudo systemctl status drosera
Note: If the status shows errors or no logs are displayed, try rebooting the VPS with sudo reboot.

If you detached from the screen session during installation, reattach using:
screen -r dresora

Troubleshooting

Script errors: If the script fails (e.g., due to missing commands like droseraup or foundryup), ensure you’re running it in a screen session and check the PATH:echo $PATH
source /root/.bashrc


Network issues: If the curl command fails, verify your internet connection and try again.
Screen issues: If you can’t reattach to the session, list all sessions with screen -ls and ensure the dresora session is active.

Support
For issues or questions, open an issue in this repository or contact the maintainer.
Happy node running!
