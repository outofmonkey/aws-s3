#!/bin/bash

# Exit on any error
set -e

# Function for logging
log() {
    echo "[INFO] $1"
}

# Ensure the script is run as root
if [[ "$EUID" -ne 0 ]]; then
  echo "[ERROR] This script must be run as root."
  exit 1
fi

# Update package list
log "Updating package list..."
apt update -y

# Install Apache2 if not already installed
if ! dpkg -s apache2 >/dev/null 2>&1; then
  log "Installing Apache2..."
  apt install -y apache2
else
  log "Apache2 is already installed."
fi

# Enable Apache2 on boot
log "Enabling Apache2 to start on boot..."
systemctl enable apache2

# Get system hostname and IP
HOSTNAME=$(hostname)
IP_ADDRESS=$(hostname -I | awk '{print $1}')  # Picks the first IP address

log "Hostname: $HOSTNAME"
log "IP Address: $IP_ADDRESS"

# Create a custom HTML page
log "Creating web page..."
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Hello from $HOSTNAME</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f2f2f2;
      color: #333;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }
    .container {
      background: white;
      padding: 40px;
      border-radius: 10px;
      box-shadow: 0 0 15px rgba(0,0,0,0.1);
      text-align: center;
    }
    h1 {
      color: #2c3e50;
      margin-bottom: 10px;
    }
    p {
      font-size: 18px;
      color: #555;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Hello, World!</h1>
    <p>From <strong>$HOSTNAME</strong> at <strong>$IP_ADDRESS</strong></p>
  </div>
</body>
</html>
EOF

# Start Apache service
log "Starting Apache2..."
systemctl start apache2

# Optionally open firewall (uncomment if using UFW)
# log "Allowing HTTP traffic through firewall..."
# ufw allow 'Apache'

log "Setup complete! Visit http://$IP_ADDRESS in your browser."