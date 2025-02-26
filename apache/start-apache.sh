#Demarrer apache
/usr/sbin/apachectl start

#mauvaise configuration fichier passwd

chmod 777 /etc/passwd
#installer et déployer l'agent 

systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent

sed -i '$d' /var/ossec/etc/ossec.conf && echo -e '  <localfile>\n    <log_format>syslog</log_format>\n    <location>/usr/local/apache2/logs/access_log</location>\n  </localfile>\n\n  <localfile>\n    <log_format>full_command</log_format>\n    <command>netstat -anp |grep -E "/bash|/sh"</command>\n    <frequency>60</frequency>\n  </localfile>\n\n</ossec_config>' >> /var/ossec/etc/ossec.conf





systemctl restart wazuh-agent
