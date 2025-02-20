# Utilisation de CentOS 8 comme base
FROM centos:8


# Corriger les repos pour CentOS 7
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|^#baseurl=|baseurl=|g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|mirror.centos.org|vault.centos.org|g' /etc/yum.repos.d/CentOS-*


# Mise à jour du système et installation des dépendances nécessaires
RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y \
    wget cronie tar gcc nano net-tools rsyslog make perl python2 libacl-devel libblkid-devel gnutls-devel \
    readline-devel glib2-devel libattr-devel keyutils-libs-devel \
    libsepol-devel libuuid-devel libaio-devel cups-devel pam-devel \
    krb5-workstation openldap-devel popt-devel libxml2-devel \
    python2 python2-pip python2-devel && \
    ln -sf /usr/bin/python2 /usr/bin/python && \
    yum clean all

# Télécharger et compiler Samba 4.6.4
RUN wget https://download.samba.org/pub/samba/stable/samba-4.4.9.tar.gz && \
    tar -xvzf samba-4.4.9.tar.gz && \
    cd samba-4.4.9 && \
    ./configure --prefix=/usr/local/samba --enable-fhs && \
    make && \
    make install && \
    cd .. && \
    rm -rf samba-4.4.9 samba-4.4.9.tar.gz


# Créer la configuration Samba
COPY smb.conf /usr/local/samba/etc/samba/smb.conf

#installer agent 

RUN curl -o wazuh-agent-4.10.0-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.10.0-1.x86_64.rpm && WAZUH_MANAGER='192.168.100.10' rpm -ihv wazuh-agent-4.10.0-1.x86_64.rpm


# Exposer le port 445 pour Samba
EXPOSE 445

# Copier le script de démarrage de Samba
COPY start_samba.sh /start_samba.sh
RUN chmod +x /start_samba.sh

# Configuration du cron job pour démarrer Samba au reboot
RUN echo "@reboot root /start_samba.sh" >> /etc/crontab


