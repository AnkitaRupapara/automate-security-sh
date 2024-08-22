# Security Audit and Server Hardening Script

**Overview**

This script automates security audits and server hardening on a Linux server. It performs various checks, including user and group audits, file and directory permissions, service audits, firewall and network security checks, and more. The script generates a detailed report and sends it via email using curl and Gmail's SMTP server.

**Features**
**1 User and Group Audits:** Lists all users, groups, and identifies users with UID 0.
**2 File and Directory Permissions Audits**: Scans for world-writable files and insecure .ssh directory permissions.
**3 Service Audits**: Lists running services and checks for unauthorized services.
**4 Firewall and Network Security Audits:** Checks firewall status and lists open ports.
**5 IP and Network Configuration Audits**: Lists all IP addresses.
**6 Security Updates**: Checks for available security updates.
**7 Log Monitoring:** Checks for suspicious entries in system logs.
**8 Server Hardening**: Applies basic hardening steps, such as disabling IPv6.
**9 Custom Security Checks:** Loads additional custom security checks from a configuration file.
**10 Reporting and Alerting:** Generates a summary report and sends it via email using curl and Gmail's SMTP.

**Prerequisites**
Ensure the following are installed on your system:
* curl: Used for sending the email report.
* mailutils (optional): Required if you want to use the mail command as an alternative.
* sudo privileges: Required for auditing certain system files and services.

**Installation**
**1 Give the file permission :**
chmod +x automate.sh

**2 Install Required Packages:**
sudo apt-get update
sudo apt-get install curl mailutils

**3 Configure SMTP Access:**
If using Gmail for email alerts, ensure that:

You have generated an App Password for your Google account (if using 2FA).
Your Gmail account allows less secure apps or you use an App Password.

**Configuration**
**Script Configuration**

Modify the script to set your alert email address and report file location:

ALERT_EMAIL="your-email@example.com"
REPORT_FILE="/var/log/security_audit_report.log"

**Custom Security Checks**
You can add custom security checks by creating a /etc/security_checks.conf file. The script will source this file and run any additional commands you define.

Example /etc/security_checks.conf:
# Custom security checks
echo "Running custom SSH configuration checks..." | tee -a $REPORT_FILE
grep -Ei 'PermitRootLogin|PasswordAuthentication' /etc/ssh/sshd_config | tee -a $REPORT_FILE

**Usage**
To run the script manually:
sudo ./automate.sh

To automate and schedule the script, add it to cron:
1 : Open the crontab editor:
sudo crontab -e

2: Add an entry to run the script daily at midnight:
0 0 * * * /path/to/automate.sh

**Example Output**

The script generates a log file containing all audit results. Here’s an example of the report:

User and Group Audits:
Listing all users and groups...
root (UID:0)
...
Checking firewall status...
Status: active
...
If configured, the report is also sent via email to the specified recipient.

**Troubleshooting**
Email not sent: Ensure the SMTP credentials are correct and that the Gmail account allows access via SMTP.
Permissions issues: Run the script with sudo to ensure it has access to necessary system files and services.


























