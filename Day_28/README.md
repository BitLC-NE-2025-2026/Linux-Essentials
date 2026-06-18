# 📊 Docker Swarm Monitoring & GitHub Actions CI/CD — Tag 28

![Linux Essentials Day 28 Header](./header.png)

> **Entwickler & Administrator:** Tobias Boyke  
> **Status:** 🚀 100% Dokumentiert & LPIC-1/Cloud-Native Fokussiert  
> **Kompatibilität:** ![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-8%20%7C%209-blue) ![Debian](https://img.shields.io/badge/Debian-12%20%7C%2013-red) ![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Latest-cyan)

---

## 📑 Inhaltsverzeichnis
- [📖 1. Monitoring & Metrics-Scraping im Docker Swarm](#-1-monitoring--metrics-scraping-im-docker-swarm)
  - [A. Die Herausforderung im Multi-Host Cluster](#a-die-herausforderung-im-multi-host-cluster)
  - [B. Die Werkzeuge: Prometheus, Grafana & cAdvisor](#b-die-werkzeuge-prometheus-grafana--cadvisor)
- [🏗️ 2. CI/CD-Pipelines mit GitHub Actions & Docker Registry](#️-2-cicd-pipelines-mit-github-actions--docker-registry)
  - [A. Der DevOps Continuous Deployment-Workflow](#a-der-devops-continuous-deployment-workflow)
  - [B. Git-basierte Builds & Rolling Updates](#b-git-basierte-builds--rolling-updates)
- [📄 3. Konfigurationsdateien im Detail](#-3-konfigurationsdateien-im-detail)
  - [A. docker-stack-monitoring.yml (Monitoring-Stack)](#a-docker-stack-monitoringyml-monitoring-stack)
  - [B. prometheus.yml (Scrape-Konfiguration)](#b-prometheusyml-scrape-konfiguration)
  - [C. deploy-github-actions.yml (GitHub Actions Pipeline)](#c-deploy-github-actionsyml-github-actions-pipeline)
- [🛠️ 4. Step-by-Step Tutorial: Monitoring & CI/CD etablieren](#️-4-step-by-step-tutorial-monitoring--cicd-etablieren)
  - [Schritt 1: Prometheus-Konfiguration vorbereiten](#schritt-1-prometheus-konfiguration-vorbereiten)
  - [Schritt 2: Monitoring-Stack im Swarm deployen](#schritt-2-monitoring-stack-im-swarm-deployen)
  - [Schritt 3: SSH-Schlüssel für GitHub Actions aufsetzen](#schritt-3-ssh-schlüssel-für-github-actions-aufsetzen)
  - [Schritt 4: Pipeline aktivieren & Rolling Update verifizieren](#schritt-4-pipeline-aktivieren--rolling-update-verifizieren)
- [🔑 Keywords](#-keywords)
- [🧠 LPIC-1/Cloud-Native Relevanz & Wissenstest](#-lpic-1cloud-native-relevanz--wissenstest)
- [🔗 Zurück zur Übersicht](#-zurück-zur-übersicht)

---

## 📖 1. Monitoring & Metrics-Scraping im Docker Swarm

### A. Die Herausforderung im Multi-Host Cluster
Wenn Container über mehrere Hosts hinweg orchestriert werden (wie srv-deb-01 und srv-deb-02), reicht ein einfacher Aufruf von `docker stats` nicht aus. Wir benötigen eine zentralisierte Instanz, die Leistungsdaten (CPU, RAM, Netzwerk, Disk I/O) aller Hosts und Container kontinuierlich sammelt und visualisiert.

### B. Die Werkzeuge: Prometheus, Grafana & cAdvisor
* **cAdvisor (Container Advisor):** Wird als `global`-Service auf jedem Swarm-Node deployt. Es liest die cgroups- und Systemdaten direkt aus dem Kernel des jeweiligen Hosts aus und stellt diese als Prometheus-Metrik-Endpoint bereit.
* **Prometheus:** Ein Zeitseriendatenbank-System (TSDB), das die Metriken per HTTP-Scrape (Pull-Verfahren) von allen cAdvisor-Instanzen abholt.
* **Grafana:** Das Visualisierungstool, welches sich mit Prometheus verbindet und schicke Dashboards zur Systemüberwachung zeichnet.

---

## 🏗️ 2. CI/CD-Pipelines mit GitHub Actions & Docker Registry

### A. Der DevOps Continuous Deployment-Workflow
Bei jeder Code-Änderung soll die Anwendung automatisch getestet, gebaut und auf dem Produktiv-Swarm aktualisiert werden:

```mermaid
flowchart LR
    Dev["📝 Code Push"] --> Actions["GitHub Actions"]
    Actions --> Build["🐳 Build Image"]
    Build --> Push["📦 Push to GHCR"]
    Push --> SSH["🔑 SSH to Manager"]
    SSH --> Deploy["🚀 Service Update"]
```

### B. Git-basierte Builds & Rolling Updates
* **GitHub Container Registry (GHCR):** Dient als sicherer Speicherort für unsere gebauten Images (`ghcr.io`).
* **SSH-Deployments:** GitHub Actions meldet sich sicher per SSH auf dem Swarm-Manager an und aktualisiert das Image mit `docker service update --image`.
* **Zero-Downtime:** Der Swarm stoppt durch unsere `update_config` (siehe Tag 27) nacheinander die alten Container und startet die neuen parallel.

---

## 📄 3. Konfigurationsdateien im Detail

Alle Konfigurationsdateien sind im [assets](./assets)-Ordner dieses Tages abgelegt.

### A. docker-stack-monitoring.yml (Monitoring-Stack)
Diese Stack-Datei deklariert Prometheus, Grafana und die globalen cAdvisor-Agenten. Siehe [docker-stack-monitoring.yml](./assets/docker-stack-monitoring.yml).

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - prometheus-config:/etc/prometheus
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
    ports:
      - "9090:9090"
    networks:
      - monitoring-net
    deploy:
      placement:
        constraints:
          - node.role == manager

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana
    networks:
      - monitoring-net
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    deploy:
      placement:
        constraints:
          - node.role == manager

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:v0.47.2
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    networks:
      - monitoring-net
    deploy:
      mode: global
      resources:
        limits:
          memory: 128M
        reservations:
          memory: 64M

networks:
  monitoring-net:
    driver: overlay
    attachable: true

volumes:
  prometheus-config:
  prometheus-data:
  grafana-data:
```

### B. prometheus.yml (Scrape-Konfiguration)
Weist Prometheus an, cAdvisor im Overlay-Netzwerk abzufragen. Siehe [prometheus.yml](./assets/prometheus.yml).

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'cadvisor'
    dns_sd_configs:
      - names:
          - 'tasks.cadvisor'
        type: 'A'
        port: 8080
```

### C. deploy-github-actions.yml (GitHub Actions Pipeline)
Die CI/CD Definition für den GitHub-Workflow. Siehe [deploy-github-actions.yml](./assets/deploy-github-actions.yml).

```yaml
name: CI/CD Deployment to Docker Swarm

on:
  push:
    branches:
      - main

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Log in to the Container registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          file: Dockerfile
          push: true
          tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest

  deploy-to-swarm:
    needs: build-and-push
    runs-on: ubuntu-latest

    steps:
      - name: Deploy Stack via SSH on Swarm Manager
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: 172.16.7.42
          username: admin
          key: ${{ secrets.SWARM_SSH_PRIVATE_KEY }}
          envs: GITHUB_TOKEN
          script: |
            docker login ghcr.io -u ${{ github.actor }} -p ${{ secrets.GITHUB_TOKEN }}
            docker service update --image ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest ticketsplease_web
```

---

## 🛠️ 4. Step-by-Step Tutorial: Monitoring & CI/CD etablieren

### Schritt 1: Prometheus-Konfiguration vorbereiten
Erstellen Sie auf dem Swarm-Manager das Konfigurationsverzeichnis und kopieren Sie die `prometheus.yml`:
```bash
sudo mkdir -p /var/lib/docker/volumes/monitoring-stack_prometheus-config/_data/
sudo cp assets/prometheus.yml /var/lib/docker/volumes/monitoring-stack_prometheus-config/_data/prometheus.yml
```

### Schritt 2: Monitoring-Stack im Swarm deployen
Führen Sie das Monitoring-Stack Deployment auf `srv-deb-01` aus:
```bash
sudo docker stack deploy -c assets/docker-stack-monitoring.yml monitoring
```

* Grafana ist anschließend auf dem Swarm-Manager unter `http://172.16.7.42:3000` erreichbar (Default-Login: `admin` / `admin`).
* Fügen Sie Prometheus (`http://prometheus:9090`) als Data Source in Grafana hinzu und importieren Sie das Dashboard-Template (z. B. ID `11600` für cAdvisor).

### Schritt 3: SSH-Schlüssel für GitHub Actions aufsetzen
1. Generieren Sie einen SSH-Schlüssel auf Ihrem lokalen System:
   ```bash
   ssh-keygen -t ed25519 -f swarm-deploy-key
   ```
2. Tragen Sie den Public Key (`swarm-deploy-key.pub`) auf dem Swarm-Manager in `~/.ssh/authorized_keys` ein.
3. Fügen Sie den Private Key in Ihrem GitHub-Repository unter **Settings -> Secrets and variables -> Actions** mit dem Namen `SWARM_SSH_PRIVATE_KEY` hinzu.

### Schritt 4: Pipeline aktivieren & Rolling Update verifizieren
Nach einem Push auf den `main`-Branch baut GitHub das Image und deployt es im Swarm. 
Überprüfen Sie den Status des Deployments auf dem Manager-Node:
```bash
sudo docker service ps ticketsplease_web
```

---

## 🔑 Keywords

| Keyword / Befehl | Erklärung |
| :--- | :--- |
| `cAdvisor` | Container Advisor: Sammelt Ressourcen- und Leistungsdaten laufender Container auf Node-Ebene. |
| `Prometheus` | Open-Source-Datenbank und Warnsystem für Metriken (Pull-basiert). |
| `Grafana` | Visualisierungs- und Dashboard-Plattform für diverse Datenquellen (z. B. Prometheus). |
| `GitHub Container Registry` | Image-Registry (`ghcr.io`) zum Hosten von Docker-Images innerhalb von GitHub. |
| `docker service update` | Führt Updates (z. B. Image-Wechsel oder Ressourcengrenzen) auf einem Swarm-Dienst aus. |

---

## 🧠 LPIC-1/Cloud-Native Relevanz & Wissenstest

<details>
<summary><b>Fragen zu Monitoring & CI/CD (Klicken zum Ausklappen)</b></summary>

1. **Wie unterscheidet sich die Funktionsweise von cAdvisor von klassischen Monitoring-Agenten auf Betriebssystemebene?**
   <details><summary>Antwort</summary>cAdvisor liest Metriken direkt aus dem virtuellen Dateisystem des Kernels (<code>/sys/fs/cgroup</code>) aus und analysiert die Namespaces. Klassische Agenten messen oft nur den Gesamt-Host.</details>

2. **Warum wird cAdvisor als <code>global</code> und Prometheus als <code>replicated</code> (bzw. auf dem Manager platziert) deklariert?**
   <details><summary>Antwort</summary>cAdvisor muss auf *jedem* physischen Host laufen (global), um dessen Container zu überwachen. Prometheus benötigt ein persistentes Volume und sollte zur leichteren Abfrage an einem festen Ort laufen (z. B. auf dem Swarm-Manager).</details>

3. **Welchen Vorteil bietet <code>docker service update</code> gegenüber einem manuellen Stoppen und Starten mit Docker Compose?**
   <details><summary>Antwort</summary>Es führt ein automatisiertes, rollierendes Update aus (Rolling Update), wodurch mindestens ein Replikat während des Updates online bleibt und somit keine Downtime entsteht.</details>

</details>

---

## 🔗 Zurück zur Übersicht

* **Tag 27 (Docker Swarm & C#-Redundanz):** [⬅️ Tag 27](../Day_27/README.md)
* **Tag 29 (LPIC-1 Simulation 101):** [➡️ Tag 29](../Day_29/README.md)
* **Master-Repository:** [🌌 Zurück zum Master-Repository](../README.md)

---
*Erstellt & gepflegt von Tobias Boyke, Juni 2026.*
