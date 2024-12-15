#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

# Function to check and install udevadm
install_udevadm() {
  # Detect if the system is Debian/Ubuntu or Arch-based
  if [ -f /etc/debian_version ]; then
    echo "Detected Debian/Ubuntu-based system. Installing udevadm..."
    apt update && apt install -y udev
  elif [ -f /etc/arch-release ]; then
    echo "Detected Arch-based system. Installing udevadm..."
    pacman -Syu --noconfirm systemd
  else
    echo "Unsupported system. udevadm is required to manage device rules. Exiting."
    exit 1
  fi
}

# Check if udevadm is installed
if ! command -v udevadm &> /dev/null; then
  echo "udevadm not found. Attempting to install it..."
  install_udevadm
else
  echo "udevadm is already installed."
fi

# Download the Android udev rules file
echo "Downloading Android udev rules..."
curl -o /etc/udev/rules.d/51-android.rules \
  https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/android/51-android.rules

# Set correct permissions for the udev rules file
echo "Setting permissions for the udev rules file..."
chmod 644 /etc/udev/rules.d/51-android.rules

# Reload udev rules to apply the changes
echo "Reloading udev rules..."
udevadm control --reload-rules

# Confirm the installation
echo "Android udev rules installed and reloaded successfully."
