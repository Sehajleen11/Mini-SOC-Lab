# 🛡️ Incident Response Report | Mini SOC Lab | Wazuh SIEM

This project presents a **Mini SOC Lab** built using **Wazuh SIEM** to detect, analyze, and document a **multi-vector attack campaign** in an isolated lab environment. The lab simulates real-world attack behavior from a Kali Linux attacker against an Ubuntu server, while Wazuh collects, correlates, and alerts on host, web, authentication, and network events.

---

## 📌 Project Summary

- **Date:** June 30, 2026  
- **Analyst:** Sehajleen Kaur  
- **Classification:** CONFIDENTIAL  
- **Incident Type:** Multi-Vector Attack Campaign  
- **Severity Level:** HIGH  
- **Target System:** Ubuntu Server (`192.168.56.106`) — Agent: `sehajleen`  
- **Attacker Host:** Kali Linux (`192.168.56.108`)  
- **Wazuh Manager:** `192.168.56.107`  

---

## 🎯 Executive Summary

On **June 26, 2026**, the Wazuh SIEM detected a coordinated **multi-vector attack campaign** against the Ubuntu server (`192.168.56.106`) originating from a Kali Linux host (`192.168.56.108`). The campaign comprised five distinct attack phases:

1. Web reconnaissance  
2. Web application exploitation  
3. Malicious file drop  
4. SSH brute force  
5. SYN flood denial-of-service  

Wazuh successfully detected and correlated all activities, with the **SSH brute force** escalating to a **HIGH severity alert**. No system compromise occurred.

### Impact Assessment

- **Data Compromised:** None  
- **System Downtime:** None (DoS mitigated)  
- **Business Impact:** Low (lab environment)  

---

## 🏗️ Lab Setup

The SOC lab was deployed in an isolated VirtualBox environment with the following systems:

| Component     | Role                     | IP Address     |
|---------------|--------------------------|----------------|
| Wazuh Manager | SIEM / Dashboard         | 192.168.56.107 |
| Ubuntu Server | Victim / Monitored Agent | 192.168.56.106 |
| Kali Linux    | Attacker Machine         | 192.168.56.108 |

---

## ⚔️ Attack Breakdown

### Attack 1 — Web Directory Enumeration (Reconnaissance)

- **Description:** Attacker probed for common admin panels such as `/admin`, `/wp-admin`, and `/phpmyadmin`
- **Tool Used:** `curl`
- **Server Response:** HTTP 404 Not Found
- **MITRE ATT&CK:** `T1595 - Active Scanning`
- **Wazuh Rules:**  
  - `31108` (Level 7) — Attempt to access a sensitive file or directory  
  - `31504` (Level 5) — Web server 404 error code  
  - `31153` (Level 10) — Multiple 404 errors from same source IP  
- **Log Source:** `/var/log/apache2/access.log`

---

### Attack 2 — Web Application Attack (SQLi / XSS)

- **Description:** Injection of SQL and XSS payloads via URL parameters
- **Tool Used:** `curl`
- **Payloads Used:**  
  - `?id=1' OR '1'='1`  
  - `<script>alert(1)</script>`
- **MITRE ATT&CK:** `T1190 - Exploit Public-Facing Application`
- **Wazuh Rules:**  
  - `31101` (Level 7) — SQL injection attack  
  - `31102` (Level 6) — XSS attempt  
  - `31168` (Level 10) — Multiple web attacks from same source IP  
- **Log Source:** `/var/log/apache2/access.log`

---

### Attack 3 — Malicious File Drop (File Integrity Monitoring)

- **Description:** Creation of a suspicious executable file in a monitored system directory
- **Method:** `touch /etc/malware_test.sh` + `chmod +x`
- **MITRE ATT&CK:** `T1105 - Ingress Tool Transfer`
- **Wazuh Rules:**  
  - `554` — File added to monitored directory  
  - `550` — Integrity checksum changed  
- **Detection Method:** File Integrity Monitoring (FIM)

---

### Attack 4 — SSH Brute Force [Primary Incident]

- **Description:** Repeated automated SSH login attempts within a short time window
- **Tool Used:** Hydra / automated SSH attempts
- **MITRE ATT&CK:** `T1110.001 - Brute Force: Password Guessing`
- **Success Rate:** `0%` — No successful logins
- **Wazuh Rules:**  
  - `5763` — sshd brute force  
  - `5551` — PAM multiple failed logins  
  - `40111` — Multiple authentication failures  
  - `2502` — User missed password  
- **Alert Level:** `Level 10 - HIGH Severity`
- **Log Source:** `/var/log/auth.log`

---

### Attack 5 — SYN Flood (Denial of Service)

- **Description:** High-volume TCP SYN packet flood to exhaust connection table resources
- **Tool Used:** `hping3 -S --flood`
- **MITRE ATT&CK:** `T1498 - Network Denial of Service`
- **Wazuh Rules:** `5710` / firewall-related connection flood detection
- **Log Source:** Kernel / firewall logs

---

## 🕒 Timeline of Events

| Time     | Event |
|----------|-------|
| 13:26    | Web directory enumeration begins (`/admin`, `/wp-admin`, `/phpmyadmin`) |
| 13:28    | SQL injection and XSS payloads sent via URL parameters |
| 13:29:34 | SSH multiple authentication failures detected (`Rule 40111`)| 
| 13:29:46 | SSH brute force attack detected (`Rule 5763`) |
| 13:30:14 | PAM multiple failed logins flagged (`Rule 5551`)| 
| 13:31:05 | HIGH severity alert raised by Wazuh SIEM |
| 13:35    | Malicious file dropped in `/etc` — FIM alert triggered (`Rule 554`)| 
| 13:40    | SYN flood (DoS) launched via `hping3` |
| 13:45    | Analyst begins investigation and log review| 

---

## 🚨 Indicators of Compromise (IOCs)

| Indicator              | Value |
|------------------------|-------|
| **Attacker IP**        | `192.168.56.108` |
| **Target Host**        | `192.168.56.106` (Agent: `sehajleen`) |
| **Targeted Ports**     | `22 (SSH), 80 (HTTP)` |
| **Malicious File**     | `/etc/malware_test.sh` |
| **Web Attack Strings** | `' OR '1'='1` , `<script>alert(1)</script>` |
| **Key Rules Fired**    | `5763, 5551, 40111, 2502, 31101, 31103, 554` |
| **Log Sources**        | `auth.log, apache2/access.log, kernel/firewall logs` |
| **Wazuh Manager**      | `192.168.56.107` |

---

## 🛡️ Response Actions Taken

- Identified attacker IP: `192.168.56.108`
- Confirmed zero successful logins or system breaches
- Verified malicious file via FIM alert and removed it
- Reviewed web, authentication, and network logs end-to-end
- Preserved evidence through screenshots and exported logs

---

## ✅ Recommendations

### Host Hardening
- Disable root SSH login
- Enforce SSH key-based authentication only
- Install **fail2ban** to block brute-force attempts
- Deploy **ModSecurity WAF** to block SQLi and XSS
- Establish FIM baseline for `/etc`, `/bin`, and `/usr`
- Enable SYN cookies and network rate-limiting

### Detection Improvements
- Configure email/Slack alerts for Wazuh events at **Level 10+**
- Enable **Wazuh Active Response** for automatic IP blocking
- Integrate **threat intelligence** and IP reputation feeds
- Deploy **Suricata** for enhanced DoS and lateral movement visibility

---

## 📚 Key Lessons Learned

- Wazuh effectively detected a **multi-vector campaign** spanning web, host, authentication, and network layers
- Log correlation turned multiple low-level events into actionable **HIGH-severity alerts**
- Defense-in-depth through FIM, authentication monitoring, and web log analysis provided full attack-chain visibility
- Strong passwords, WAF rules, and network rate-limiting remain essential first-line defenses

---

## 📂 Repository Contents

- `Incident Response Report`  
- Wazuh screenshots and alert evidence  
- Attack timeline and IOC documentation  
- SOC lab methodology and findings  

---

## ⚠️ Disclaimer

This project was performed in a **controlled lab environment** for **educational purposes only**. All systems involved were owned and managed within the test environment. No unauthorized activity was conducted on public or third-party systems.

---

## 👤 Author

*Sehajleen Kaur*

If you found this project useful, feel free to star the repository.
