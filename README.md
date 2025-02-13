🚀 Automatischer Staging-Server mit Docker auf Rocky Linux

Dieses Skript richtet einen **lokalen Staging-Server** auf **Rocky Linux** ein, basierend auf **Docker und Docker-Compose**.  
Der Server ermöglicht die **automatische Bereitstellung (Auto-Deployment) von PHP-Projekten**, die in einem Git-Repository verwaltet werden.  

✨ Funktionen
✅ **Automatische Installation von Docker & Docker-Compose**  
✅ **Einrichten eines vollständigen Staging-Servers mit Apache, PHP & MySQL**  
✅ **Auto-Deployment mit Git Webhooks** (Änderungen werden bei jedem Git-Push übernommen)  
✅ **Einfache Verwaltung mit Docker-Compose**  
✅ **phpMyAdmin für die Datenbankverwaltung**  

🚀 Installation & Nutzung

1️⃣ **Skript herunterladen**
```bash
git clone https://github.com/deinuser/staging-docker.git
cd staging-docker
```

2️⃣ **Skript ausführbar machen**
```bash
chmod +x setup_staging.sh
```

### 3️⃣ **Skript ausführen**
```bash
./setup_staging.sh
```

Das Skript installiert Docker & Docker-Compose, erstellt die benötigten Konfigurationsdateien und startet den Staging-Server.
