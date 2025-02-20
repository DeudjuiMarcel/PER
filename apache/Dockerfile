# Utiliser CentOS 7 comme base
FROM centos:8

# Mainteneur
#LABEL maintainer="ton.nom@exemple.com"

# Corriger les repos pour CentOS 7
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|^#baseurl=|baseurl=|g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|mirror.centos.org|vault.centos.org|g' /etc/yum.repos.d/CentOS-*


# Installer les dépendances nécessaires
RUN yum -y update && \
    yum -y install epel-release net-tools rsyslog wget openssh-server nano cronie gcc pcre-devel expat-devel make \
    openssl-devel tar gzip perl-devel libtool bzip2 && \
    yum -y install which

# Installer APR et APR-util
WORKDIR /usr/src

RUN wget https://archive.apache.org/dist/apr/apr-1.7.0.tar.gz && \
    tar -xzf apr-1.7.0.tar.gz && \
    cd apr-1.7.0 && \
    ./configure --prefix=/usr/local/apr && make && make install

RUN wget https://archive.apache.org/dist/apr/apr-util-1.6.1.tar.gz && \
    tar -xzf apr-util-1.6.1.tar.gz && \
    cd apr-util-1.6.1 && \
    ./configure --with-apr=/usr/local/apr --prefix=/usr/local/apr-util && \
    make && make install

# Télécharger, compiler et installer Apache 2.4.50
RUN wget https://archive.apache.org/dist/httpd/httpd-2.4.50.tar.gz && \
    tar -xzf httpd-2.4.50.tar.gz && \
    cd httpd-2.4.50 && \
    ./configure --enable-so --enable-ssl --with-mpm=event --with-apr=/usr/local/apr \
    --with-apr-util=/usr/local/apr-util --prefix=/usr/local/apache2 && \
    make && make install

# Créer des liens pour faciliter la gestion d'Apache
RUN ln -s /usr/local/apache2/bin/httpd /usr/sbin/httpd && \
    ln -s /usr/local/apache2/bin/apachectl /usr/sbin/apachectl

# Configurer le serveur pour écouter sur toutes les interfaces
#RUN sed -i 's/^Listen 80$/Listen 0.0.0.0:80/' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's/^Listen 80$/Listen 0.0.0.0:80/' /usr/local/apache2/conf/httpd.conf

#mot de passe
RUN echo "root:lmkbqsdbnmlksdk214" | chpasswd


#configuration vulnérable
RUN echo '<Directory />' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    Require all granted' >> /usr/local/apache2/conf/httpd.conf && \
    echo '</Directory>' >> /usr/local/apache2/conf/httpd.conf && \
    echo '' >> /usr/local/apache2/conf/httpd.conf && \
    echo '<IfModule !mpm_prefork_module>' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    LoadModule cgid_module modules/mod_cgid.so' >> /usr/local/apache2/conf/httpd.conf && \
    echo '</IfModule>' >> /usr/local/apache2/conf/httpd.conf


#configuration vulnérable pour le fichier password

RUN chmod 777 /etc/passwd

# Exposer le port 80 ou 8181
EXPOSE 80

# Ajouter une page d'accueil de test
RUN echo "<h1>Bienvenue sur mon site.</h1>" > /usr/local/apache2/htdocs/index.html && \
    echo "<h2>Amuse toi bien</h2>" >> /usr/local/apache2/htdocs/index.html && \
    echo "<!-- Si tu veux un indice pense au path traversal et RCE et aussi à l'encodage -->" >> /usr/local/apache2/htdocs/index.html 


#installer agent 

RUN curl -o wazuh-agent-4.10.0-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.10.0-1.x86_64.rpm && WAZUH_MANAGER='192.168.100.10' rpm -ihv wazuh-agent-4.10.0-1.x86_64.rpm


# Copie des scripts nécessaires
COPY start-apache.sh /start-apache.sh
RUN chmod +x /start-apache.sh

# Configuration de la tâche cron
RUN echo "@reboot root /start-apache.sh" >> /etc/crontab


# Commande de démarrage
#CMD ["apachectl", "-DFOREGROUND"]
