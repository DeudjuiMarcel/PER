#!/bin/bash

echo "Starting Tomcat..."
/opt/tomcat/bin/catalina.sh run &


systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent


sed -i '$d' /var/ossec/etc/ossec.conf && echo -e '  <localfile>\n    <log_format>syslog</log_format>\n    <location>/opt/tomcat/logs/localhost_access_log.2025-02-17.txt</location>\n  </localfile>\n\n  <localfile>\n    <log_format>full_command</log_format>\n    <command>netstat -anp |grep -E "/bash|/sh"</command>\n    <frequency>60</frequency>\n  </localfile>\n\n</ossec_config>' >> /var/ossec/etc/ossec.conf


systemctl restart wazuh-agent
