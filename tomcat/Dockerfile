FROM centos:8

# Corriger les repos pour CentOS 7
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|^#baseurl=|baseurl=|g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|mirror.centos.org|vault.centos.org|g' /etc/yum.repos.d/CentOS-*


# Variables d'environnement pour Tomcat
ENV TOMCAT_VERSION=7.0.81 \
    CATALINA_HOME=/opt/tomcat \
    PATH=$CATALINA_HOME/bin:$PATH

# Installer les dépendances nécessaires
RUN yum update -y && \
    yum install -y \
    java-1.8.0-openjdk-devel \
    wget nano cronie rsyslog net-tools \
    tar \
    which && \
    yum clean all

# Créer un utilisateur pour exécuter Tomcat
RUN groupadd -r tomcat && useradd -r -g tomcat -d /opt/tomcat -s /bin/false tomcat

# Ajouter un mot de passe root
RUN echo "root:admin" | chpasswd

# Télécharger et installer Tomcat
RUN wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.81/bin/apache-tomcat-7.0.81.tar.gz -P /tmp && \
    tar xvfz /tmp/apache-tomcat-7.0.81.tar.gz -C /opt && \
    mv /opt/apache-tomcat-7.0.81 /opt/tomcat && \
    rm /tmp/apache-tomcat-7.0.81.tar.gz

# Configurer Tomcat pour être vulnérable
#RUN sed -i 's/<param-name>readonly<\/param-name><param-value>true<\/param-value>/<param-name>readonly<\/param-name><param-value>false<\/param-value>/' /opt/tomcat/conf/web.xml
RUN sed -i '/<servlet-name>default<\/servlet-name>/,/<load-on-startup>1<\/load-on-startup>/s|<load-on-startup>1</load-on-startup>|  <init-param>\n    <param-name>readonly</param-name>\n    <param-value>false</param-value>\n  </init-param>\n<load-on-startup>1</load-on-startup>|' /opt/tomcat/conf/web.xml

# Changer les permissions
RUN chown -R tomcat:tomcat /opt/tomcat

#installer agent 

RUN curl -o wazuh-agent-4.10.0-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.10.0-1.x86_64.rpm && WAZUH_MANAGER='192.168.100.10' rpm -ihv wazuh-agent-4.10.0-1.x86_64.rpm



# Exposer le port par défaut de Tomcat
EXPOSE 8080

# Définir l'utilisateur root pour permettre d'autres installations
USER root

# Copie des scripts nécessaires
COPY start-tomcat.sh /start-tomcat.sh
RUN chmod +x /start-tomcat.sh

# Configuration de la tâche cron
RUN echo "@reboot root /start-tomcat.sh" >> /etc/crontab

