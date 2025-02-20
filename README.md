
# PER
Code source du PER
=======
# 🚀 Installation de Wazuh en Single-Node avec Docker

Ce projet permet d'installer et de déployer **Wazuh** et une infrastructure qui contient des mservices vulnérables sur un serveur en mode **Single-Node** à l'aide de **Docker et Docker Compose**.
Les différents répertoires à l'exception de wazuh-docker contiennent les Dockerfiles que nous avons utilisés pour créer les images dockers des services vulnérables. 

## 📌 Prérequis

Avant de commencer, assurez-vous que votre serveur dispose de :
- Un système Linux (Ubuntu/Debian recommandé)
- Un accès **root** ou un utilisateur avec `sudo`
- `git` installé (`sudo apt install git -y`)

---

## 🛠️ Installation

### 1️⃣ Installation de `curl`
```bash
sudo apt install -y curl
```
> 📌 `curl` est utilisé pour télécharger des fichiers depuis Internet.

### 2️⃣ Installation de Docker
```bash
sudo curl -sSL https://get.docker.com/ | sh
sudo systemctl start docker
```
> 📌 Télécharge et installe **Docker**, puis démarre le service.

### 3️⃣ Augmenter la mémoire du noyau pour Elasticsearch
```bash
sudo sysctl -w vm.max_map_count=262144
```
> 📌 Augmente la mémoire utilisée par **Elasticsearch** pour éviter des erreurs lors du déploiement de Wazuh.

### 4️⃣ Installation de Docker Compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
> 📌 Télécharge et installe **Docker Compose**, un outil permettant de gérer des conteneurs Docker avec des fichiers YAML.

### 5️⃣ Clonage du projet Wazuh Docker
```bash
git clone https://github.com/DeudjuiMarcel/PER.git
cd PER/wazuh-docker/single-node/
```
> 📌 Clone le dépôt de ce projet **PER** et se place dans le répertoire **single-node**.

### 6️⃣ Génération des certificats pour Wazuh
```bash
docker-compose -f generate-indexer-certs.yml run --rm generator
```
> 📌 Génère les certificats nécessaires pour sécuriser la communication entre les services Wazuh.

### 7️⃣ Déploiement de Wazuh
```bash
docker-compose up -d
```
> 📌 Démarre tous les services **Wazuh**, **Elasticsearch**, et **Kibana** et également les services vulnérables en mode **détaché** (`-d`), ce qui signifie qu'ils s'exécuteront en arrière-plan.


---

## 📢 Vérification du déploiement

Après quelques minutes, vous pouvez vérifier si les conteneurs tournent correctement avec :
```bash
docker ps
```
Vous devriez voir plusieurs conteneurs **wazuh_manager**, **wazuh_indexer**, et **wazuh_dashboard** et les autres services vulnérables ainsi qu'une machine kali permétant de simuler des scénarios d'attaque en cours d'exécution.

---

## 📊 Accès à l'interface Wazuh

1. Ouvrez votre navigateur et accédez à **Kibana** via :
   ```
   https://@IP_docker
   ```
2. Connectez-vous avec :
   - **Utilisateur** : `admin`
   - **Mot de passe** : `SecretPassword` *(modifiable dans la config Wazuh)*

---

## 🛠️ Gestion des conteneurs

- **Arrêter les services** :
  ```bash
  docker-compose down
  ```
- **Redémarrer les services** :
  ```bash
  docker-compose up -d
  ```
- **Afficher les logs** :
  ```bash
  docker-compose logs -f
  ```

---

## 🔍 Dépannage

Si vous rencontrez des problèmes :

