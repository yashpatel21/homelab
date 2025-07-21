#!/bin/bash
# Test script to verify cron job creation is working

echo "🧪 Testing Cron Job Creation Fix"
echo "=================================="

echo ""
echo "1️⃣ Re-running NTFY deployment to test OPNsense firmware script cron job..."
ansible-playbook -i inventory/homelab.yml playbooks/services/deploy-ntfy.yml --tags scripts --ask-vault-pass

echo ""
echo "2️⃣ Re-running AdGuard deployment to test DNS failover cron job..."
ansible-playbook -i inventory/homelab.yml playbooks/services/deploy-adguard.yml --tags failover --ask-vault-pass

echo ""
echo "3️⃣ Checking OPNsense cron jobs..."
echo "Expected: firmware-notify.sh (daily 6 PM) and agh_failover.sh (every minute)"
ssh root@192.168.1.1 'crontab -l | grep -E "(firmware-notify|agh_failover)"'

echo ""
echo "4️⃣ Checking Ubuntu cron jobs..."
echo "Expected: check-updates.sh (weekly Sundays 12 PM)"
crontab -l -u yash | grep -F 'check-updates.sh'

echo ""
echo "5️⃣ Checking Proxmox cron jobs..."
echo "Expected: proxmox-update-check.sh (weekly Sundays 12 PM)"
ssh root@192.168.1.10 'crontab -l | grep -F "proxmox-update-check.sh"'

echo ""
echo "✅ Test completed! Check the output above to verify cron jobs were created." 