FROM centos:latest

# Corriger les repos pour CentOS 7
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|^#baseurl=|baseurl=|g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|mirror.centos.org|vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Installer les dépendances nécessaires
RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y httpd php php-mysqli git unzip wget mariadb-server && \
    yum install -y nano cronie net-tools rsyslog

# Démarrer et activer MariaDB pour initialiser les bases de données
RUN systemctl enable mariadb.service

# Installer DVWA depuis le dépôt GitHub
RUN git clone https://github.com/digininja/DVWA.git /var/www/html/dvwa

# Changer les permissions
RUN chown -R apache:apache /var/www/html/dvwa && \
    chmod -R 755 /var/www/html/dvwa

# Configurer DVWA
RUN cp /var/www/html/dvwa/config/config.inc.php.dist /var/www/html/dvwa/config/config.inc.php

#installer agent 
RUN curl -o wazuh-agent-4.10.0-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.10.0-1.x86_64.rpm && WAZUH_MANAGER='192.168.100.10' rpm -ihv wazuh-agent-4.10.0-1.x86_64.rpm


# Démarrer Apache et MariaDB dans un conteneur
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Exposer le port HTTP pour DVWA
EXPOSE 80

RUN echo "@reboot root /start.sh" >> /etc/crontab
