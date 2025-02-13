#!/bin/bash

# Farben für die Ausgabe
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starte die Einrichtung des Staging-Servers...${NC}"

# 1️⃣ Docker & Docker-Compose installieren
echo -e "${GREEN}🔧 Installiere Docker & Docker-Compose...${NC}"
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Docker starten & aktivieren
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# 2️⃣ Projektverzeichnis anlegen
STAGING_DIR=~/staging-docker
echo -e "${GREEN}📁 Erstelle das Staging-Verzeichnis unter $STAGING_DIR...${NC}"
mkdir -p $STAGING_DIR/staging

# 3️⃣ Docker-Compose Datei erstellen
echo -e "${GREEN}📜 Erstelle die Docker-Compose Datei...${NC}"
cat <<EOF > $STAGING_DIR/docker-compose.yml
version: '3.7'
services:
  php:
    image: php:8.1-apache
    container_name: php_staging
    restart: always
    ports:
      - "8080:80"
    volumes:
      - ./staging:/var/www/html
    environment:
      - APACHE_RUN_USER=#1000
      - APACHE_RUN_GROUP=#1000

  mysql:
    image: mysql:5.7
    container_name: mysql_staging
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: staging_db
      MYSQL_USER: staging_user
      MYSQL_PASSWORD: staging_pass
    ports:
      - "3307:3306"

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin_staging
    restart: always
    ports:
      - "8081:80"
    environment:
      PMA_HOST: mysql
EOF

# 4️⃣ Beispiel-PHP-Projekt erstellen
echo -e "${GREEN}📝 Erstelle ein Beispiel-PHP-Projekt...${NC}"
cat <<EOF > $STAGING_DIR/staging/index.php
<?php
phpinfo();
?>
EOF

# 5️⃣ Auto-Deployment Skript erstellen
echo -e "${GREEN}🔄 Erstelle Auto-Deployment Skript...${NC}"
cat <<EOF > $STAGING_DIR/deploy.sh
#!/bin/bash
cd $STAGING_DIR/staging
git pull origin staging
docker restart php_staging
EOF

chmod +x $STAGING_DIR/deploy.sh

# 6️⃣ Webhook PHP-Skript für Auto-Deployment erstellen
echo -e "${GREEN}🌐 Erstelle Webhook für Auto-Deployment...${NC}"
cat <<EOF > $STAGING_DIR/staging/deploy.php
<?php
shell_exec('sh /home/$USER/staging-docker/deploy.sh');
echo "Staging Server updated!";
?>
EOF

# 7️⃣ Docker-Container starten
echo -e "${GREEN}🐳 Starte Docker-Container...${NC}"
cd $STAGING_DIR
docker-compose up -d

echo -e "${GREEN}✅ Staging-Server ist bereit!${NC}"
echo -e "🌍 PHP Server: http://deinserver:8080"
echo -e "💾 MySQL Server: localhost:3307 (User: staging_user, Pass: staging_pass)"
echo -e "🛠 phpMyAdmin: http://deinserver:8081"
