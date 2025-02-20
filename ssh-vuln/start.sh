#!/bin/bash

#/usr/sbin/sshd -D &

# Créer l'utilisateur système sshd
useradd -r -M -d /var/empty/sshd -s /sbin/nologin -c "Privilege-separated SSH" sshd


/usr/sbin/sshd -D &

systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent

sed -i '$d' /var/ossec/etc/ossec.conf && echo -e '  <localfile>\n    <log_format>syslog</log_format>\n    <location>/var/log/messages</location>\n  </localfile>\n\n  <localfile>\n    <log_format>full_command</log_format>\n    <command>netstat -ant |grep -E ".*:22.*ESTABLISHED"</command>\n    <frequency>60</frequency>\n  </localfile>\n\n</ossec_config>' >> /var/ossec/etc/ossec.conf

systemctl restart wazuh-agent



