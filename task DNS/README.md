# DNS Troubleshooting and Network Diagnostics Guide

A comprehensive guide for diagnosing and resolving DNS issues on Linux systems using various networking tools and configuration methods.

## 🔍 Problem Overview
This guide documents the step-by-step process of troubleshooting a DNS resolution issue for `internal.example.com` and implementing multiple resolution methods.

## 📋 Commands and Solutions

### Step 1: Check Current DNS Configuration
```bash
cat /etc/resolv.conf
```
**Output:**
```
nameserver 127.0.0.53
```
*Shows the system is using systemd-resolved local DNS stub*

### Step 2: Test DNS Resolution
```bash
dig internal.example.com
```
**Result:** `status: SERVFAIL`
*Local DNS resolver cannot resolve the domain*

### Step 3: Test with External DNS Server
```bash
dig @8.8.8.8 internal.example.com
```
**Result:** `status: NXDOMAIN`
*Domain doesn't exist in public DNS records*

### Step 4: Check System DNS Status
```bash
resolvectl status
```
*Displays current DNS resolver configuration and status*

### Step 5: Add Custom DNS Server
```bash
sudo nano /etc/resolv.conf
```
**Add:**
```
nameserver 192.168.1.1
```
*Configure local router as DNS server*

### Step 6: Retest DNS Resolution
```bash
dig internal.example.com
```
**Result:** `status: NXDOMAIN`
*Still not resolved - domain may not exist*

### Step 7: Update Package Repository
```bash
sudo apt update
```

### Step 8: Install Network Scanning Tool
```bash
sudo apt install nmap
```

### Step 9: Network Discovery Scan
```bash
nmap -p 80,443 192.168.1.0/24
```
**Output:**
```
Starting Nmap 7.80 ( https://nmap.org ) at 2025-04-28 19:27 EEST
Nmap scan report for _gateway (192.168.1.1)
Host is up (0.032s latency).
PORT    STATE SERVICE
80/tcp  open  http
443/tcp open  https
```
*Discovered that 192.168.1.1 has web services running*

### Step 10: Create Local DNS Entry
```bash
sudo nano /etc/hosts
```
**Add:**
```
192.168.1.1   internal.example.com
```
*Map the domain to the discovered IP address*

### Step 11: Test Connectivity
```bash
ping internal.example.com
```
**Result:** ✅ **Response successful**
*Domain now resolves to 192.168.1.1*

### Step 12: Test HTTP Response
```bash
curl -I http://internal.example.com
```
**Output:**
```
HTTP/1.1 400 Bad Request
```
*Connection established but server returns error (likely configuration issue)*

### Step 13: Test Raw TCP Connection
```bash
telnet internal.example.com 80
```
**Output:**
```
Trying 192.168.1.1...
Connected to internal.example.com.
Escape character is '^]'.
HTTP/1.1 200 OK
```
*Direct connection works - confirms service is running*

### Step 14: Create Persistent DNS Configuration
```bash
sudo mkdir -p /etc/systemd/resolved.conf.d
```

### Step 15: Configure System DNS Servers
```bash
sudo nano /etc/systemd/resolved.conf.d/dns_servers.conf
```
**Add:**
```
[Resolve]
DNS=8.8.8.8 1.1.1.1
FallbackDNS=9.9.9.9
```
*Configure primary and fallback DNS servers*

### Step 16: Apply DNS Configuration
```bash
sudo systemctl restart systemd-resolved
```

### Step 17: Verify Final Configuration
```bash
resolvectl status
```
*Confirm new DNS settings are active*

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| `cat` | View file contents |
| `dig` | DNS lookup utility |
| `resolvectl` | systemd-resolved management |
| `nano` | Text editor |
| `apt` | Package management |
| `nmap` | Network discovery and security auditing |
| `ping` | Test network connectivity |
| `curl` | HTTP client |
| `telnet` | TCP connection testing |
| `systemctl` | Service management |




