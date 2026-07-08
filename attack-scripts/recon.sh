#!/bin/bash
# Mini SOC Lab - Reconnaissance Script
# MITRE ATT&CK: T1595.002 - Active Scanning (Vulnerability Scanning)
# DISCLAIMER: For educational and lab use only.

TARGET="192.168.56.106"

echo "[*] Starting Network Reconnaissance against $TARGET..."
echo "[*] Running Nmap Aggressive Scan (-A -T4)..."
echo ""

# Perform the scan
nmap -A -T4 $TARGET

echo ""
echo "[+] Reconnaissance complete. Check Wazuh for alerts."
