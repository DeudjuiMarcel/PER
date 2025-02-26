
#!/bin/bash
echo "Bonjour Marcel"
# Démarrer le service Samba
/usr/local/samba/sbin/smbd -D
/usr/local/samba/sbin/nmbd -D
/usr/local/samba/sbin/smbd 


systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent

#configuration samba vulnerable
sed -i '$d' /var/ossec/etc/ossec.conf && echo -e '  <localfile>\n    <log_format>syslog</log_format>\n    <location>/usr/local/samba/var/log/samba/log.smbd</location>\n  </localfile>\n\n  <localfile>\n    <log_format>full_command</log_format>\n    <command>netstat -anp |grep -E "/bash|/sh"</command>\n    <frequency>60</frequency>\n  </localfile>\n\n</ossec_config>' >> /var/ossec/etc/ossec.conf

systemctl restart wazuh-agent
