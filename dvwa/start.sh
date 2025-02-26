#!/bin/bash
# Démarrer MariaDB
/usr/bin/mysqld_safe &

# Attendre que MySQL soit prêt
sleep 5

# Initialisation de la base de données DVWA
#mysql -e "CREATE DATABASE dvwa;"
#mysql -e "GRANT ALL PRIVILEGES ON dvwa.* TO 'dvwa'@'localhost' IDENTIFIED BY 'p@ssw0rd'; FLUSH PRIVILEGES;"


DB_USER="dvwa"
DB_PASS="p@ssw0rd"
DB_NAME="dvwa"

echo "[INFO] Vérification de MySQL..."
if ! systemctl is-active --quiet mysql; then
    echo "[ERROR] MySQL n'est pas en cours d'exécution. Démarrage..."
    systemctl start mysql 
fi

echo "[INFO] Création de l'utilisateur et de la base de données DVWA..."

mysql -u root <<EOF 
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "[SUCCESS] Configuration MySQL terminée ! "


# Démarrer Apache


systemctl enable httpd

systemctl start httpd



systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent

sed -i '$d' /var/ossec/etc/ossec.conf && echo -e '  <localfile>\n    <log_format>syslog</log_format>\n    <location>/var/log/httpd/access_log</location>\n  </localfile>\n\n  <localfile>\n    <log_format>full_command</log_format>\n    <command>netstat -anp |grep -E "/bash|/sh"</command>\n    <frequency>60</frequency>\n  </localfile>\n\n</ossec_config>' >> /var/ossec/etc/ossec.conf


systemctl restart wazuh-agent
