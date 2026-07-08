#!/bin/bash
# Mini SOC Lab - SSH Brute Force Simulation
# MITRE ATT&CK: T1110.001 - Brute Force: Password Guessing
# DISCLAIMER: For educational and lab use only.

TARGET="192.168.56.106"
USER="fakeadmin"

echo "[*] Starting SSH Brute Force simulation against $TARGET..."
echo "[*] Attempting 20 failed logins..."
echo ""

# Loop to generate multiple failed authentication logs
for i in {1..20}; do
    echo "[-] Attempt $i: Trying password 'password123' for user '$USER'..."
    # This will fail and generate auth.log entries
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 $USER@$TARGET exit <<< "wrongpassword" 2>/dev/null
done

echo ""
echo "[+] Brute force simulation complete. Check Wazuh Rules 5763, 5551, 40111."
