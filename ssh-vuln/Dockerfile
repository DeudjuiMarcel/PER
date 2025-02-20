# Utiliser CentOS 8
FROM centos:8

# Corriger les repos pour CentOS 7
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|^#baseurl=|baseurl=|g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|mirror.centos.org|vault.centos.org|g' /etc/yum.repos.d/CentOS-*


# Installer les dépendances
RUN yum -y update && \
    yum -y install wget rsyslog tar gcc make cronie perl-devel sudo nano net-tools pam-devel zlib-devel

# Télécharger et installer OpenSSL 1.0.2
WORKDIR /usr/src
RUN wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2u.tar.gz && \
    tar -xzf openssl-1.0.2u.tar.gz && \
    cd openssl-1.0.2u && \
    ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib && \
    make && make install

# Ajouter les chemins pour OpenSSL
RUN echo "/usr/local/ssl/lib" > /etc/ld.so.conf.d/openssl-1.0.2u.conf && \
    ldconfig

# Vérifier OpenSSL
RUN /usr/local/ssl/bin/openssl version

# Définir les variables d'environnement pour la compilation
ENV CFLAGS="-I/usr/local/ssl/include"
ENV LDFLAGS="-L/usr/local/ssl/lib"

# Télécharger et compiler OpenSSH 7.7
RUN wget http://ftp.hostserver.de/pub/OpenBSD/OpenSSH/portable/openssh-7.7p1.tar.gz && \
    tar -xzf openssh-7.7p1.tar.gz && \
    cd openssh-7.7p1 && \
    ./configure --prefix=/usr --sysconfdir=/etc/ssh --with-ssl-dir=/usr/local/ssl && \
    make && make install

# Configurer SSH
RUN mkdir -p /run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Ajouter un utilisateur vulnérable
RUN useradd -m -s /bin/bash nayneshkumar && \
    echo "nayneshkumar:barcelona" | chpasswd

RUN echo 'nayneshkumar ALL=(ALL) NOPASSWD: /bin/bash' >> /etc/sudoers

#installer agent 
RUN curl -o wazuh-agent-4.10.0-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.10.0-1.x86_64.rpm && WAZUH_MANAGER='192.168.200.10' rpm -ihv wazuh-agent-4.10.0-1.x86_64.rpm


# Exposer le port SSH
EXPOSE 22

#copie des scripts nécessaires
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Configuration de la tâche cron pour exécuter le script au démarrage
RUN echo "@reboot root /start.sh" >> /etc/crontab
