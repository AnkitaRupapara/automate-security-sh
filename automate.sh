#!/bin/bash

# Configuration variables
ALERT_EMAIL="backup@edulab.in"
REPORT_FILE="/var/log/security_audit_report.log"

# 1. User and Group Audits
audit_users_groups() {
  echo "User and Group Audits:" | tee -a $REPORT_FILE
  echo "Listing all users and groups..." | tee -a $REPORT_FILE
  getent passwd | awk -F: '{ print $1 " (UID:" $3 ")" }' | tee -a $REPORT_FILE
  echo "Listing users with UID 0 (root privileges)..." | tee -a $REPORT_FILE
  awk -F: '($3 == "0") {print}' /etc/passwd | tee -a $REPORT_FILE
}

# 2. File and Directory Permissions
audit_permissions() {
  echo "File and Directory Permissions Audits:" | tee -a $REPORT_FILE
  echo "Scanning for world-writable files..." | tee -a $REPORT_FILE
  find / -type f -perm -o+w -exec ls -l {} \; | tee -a $REPORT_FILE
  echo "Checking for insecure .ssh directory permissions..." | tee -a $REPORT_FILE
  find /home -name ".ssh" -exec chmod 700 {} \; -exec ls -ld {} \; | tee -a $REPORT_FILE
}

# 3. Service Audits
audit_services() {
  echo "Service Audits:" | tee -a $REPORT_FILE
  echo "Listing all running services..." | tee -a $REPORT_FILE
  systemctl list-units --type=service --state=running | tee -a $REPORT_FILE
  echo "Checking for unauthorized services..." | tee -a $REPORT_FILE
  # Custom service checks can be added here
}

# 4. Firewall and Network Security
audit_firewall_network() {
  echo "Firewall and Network Security Audits:" | tee -a $REPORT_FILE
  echo "Checking firewall status..." | tee -a $REPORT_FILE
  ufw status | tee -a $REPORT_FILE
  echo "Listing open ports..." | tee -a $REPORT_FILE
  netstat -tuln | grep LISTEN | tee -a $REPORT_FILE
}

# 5. IP and Network Configuration Checks
audit_ip_network() {
  echo "IP and Network Configuration Audits:" | tee -a $REPORT_FILE
  echo "Listing IP addresses..." | tee -a $REPORT_FILE
  ip addr show | tee -a $REPORT_FILE
}

# 6. Security Updates and Patching
audit_security_updates() {
  echo "Checking for security updates..." | tee -a $REPORT_FILE
  apt-get update && apt-get upgrade -s | grep -i security | tee -a $REPORT_FILE
}

# 7. Log Monitoring
audit_logs() {
  echo "Log Monitoring:" | tee -a $REPORT_FILE
  echo "Checking for suspicious log entries..." | tee -a $REPORT_FILE
  grep -i "failed" /var/log/auth.log | tee -a $REPORT_FILE
}

# 8. Server Hardening Steps
harden_server() {
  echo "Applying server hardening steps..." | tee -a $REPORT_FILE
  # Disable IPv6
  echo "Disabling IPv6..." | tee -a $REPORT_FILE
  echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
  sysctl -p
  # Additional hardening steps go here
}

# 9. Custom Security Checks
custom_security_checks() {
  echo "Running custom security checks..." | tee -a $REPORT_FILE
  # Load custom checks from a config file
  if [ -f /etc/security_checks.conf ]; then
    source /etc/security_checks.conf
  fi
}

# 10. Reporting and Alerting
generate_report() {
  echo "Generating summary report..." | tee -a "$REPORT_FILE"
  
  if [ -n "$ALERT_EMAIL" ]; then
    # Create a temporary file to hold the email content
    EMAIL_CONTENT=$(mktemp)

    # Write the email subject and body to the temporary file
    {
      echo "Subject: Security Audit Report"
      echo "To: $ALERT_EMAIL"
      echo "MIME-Version: 1.0"
      echo "Content-Type: text/plain"
      echo
      cat "$REPORT_FILE"
    } > "$EMAIL_CONTENT"

    # Send the email using curl
    if curl -s --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
          --mail-from 'backup@edulab.in' \
          --mail-rcpt "$ALERT_EMAIL" \
          --user 'backup@edulab.in:trknbgmtisrybqke' \
          -T "$EMAIL_CONTENT"; then
      echo "Report successfully sent to $ALERT_EMAIL" | tee -a "$REPORT_FILE"
    else
      echo "Error: Failed to send the report via email." | tee -a "$REPORT_FILE"
    fi

    # Remove the temporary file
    rm "$EMAIL_CONTENT"
  else
    echo "No alert email address specified." | tee -a "$REPORT_FILE"
  fi
}




# Run all functions
audit_users_groups
audit_permissions
audit_services
audit_firewall_network
audit_ip_network
audit_security_updates
audit_logs
harden_server
custom_security_checks
generate_report
