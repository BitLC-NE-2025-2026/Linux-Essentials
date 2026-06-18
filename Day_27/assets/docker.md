# Docker & Orchestrierungs-Dokumentation für TicketsPlease

Diese Dokumentation fasst alle Docker-bezogenen Dateien und die gestern (17. Juni 2026) vorgenommenen Änderungen zusammen. Ziel war es, die .NET 10.0 Anwendung für Docker vorzubereiten und die Orchestrierung für Docker Swarm zu optimieren.

---

## 1. Übersicht der betroffenen Dateien

| Datei | Zweck | Letzte Änderungen |
| :--- | :--- | :--- |
| `Dockerfile` | Multi-Stage-Build-Definition für die Webanwendung | Upgrade auf .NET 10.0 SDK & Runtime, Kommentierung der Layer |
| `stack.yml` | Docker Swarm Stack Definition für die Produktions-Orchestrierung | Umstellung auf physikalische IP, Key-Value-Format, Ausfallsicherheit (Replikate), Secrets für Passwörter, Placement Constraints |
| `docker-compose.yml` | Lokale Orchestrierung für Entwicklung & Tests | Initial erstellt für das Zusammenspiel von Web-App und MSSQL-Datenbank |

---

## 2. Detaillierte Dateiinhalte und Erklärungen

### `Dockerfile`
Die `Dockerfile` verwendet einen modernen **Multi-Stage-Build**, um die finale Image-Größe minimal zu halten. Sie wurde gestern auf **.NET 10.0** aktualisiert.

```dockerfile
# Basisabbild fuer den Build Prozess mit .NET 10.0 SDK
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Kopieren der Projektdateien fuer den Restore Vorgang
COPY ["src/TicketsPlease.Web/TicketsPlease.Web.csproj", "src/TicketsPlease.Web/"]
COPY ["src/TicketsPlease.Infrastructure/TicketsPlease.Infrastructure.csproj", "src/TicketsPlease.Infrastructure/"]
COPY ["src/TicketsPlease.Application/TicketsPlease.Application.csproj", "src/TicketsPlease.Application/"]
COPY ["src/TicketsPlease.Domain/TicketsPlease.Domain.csproj", "src/TicketsPlease.Domain/"]

# Wiederherstellen der NuGet Pakete
RUN dotnet restore "src/TicketsPlease.Web/TicketsPlease.Web.csproj"

# Kopieren des restlichen Quellcodes
COPY . .
WORKDIR "/src/src/TicketsPlease.Web"

# Kompilieren der Anwendung im Release Modus
RUN dotnet build "TicketsPlease.Web.csproj" -c Release -o /app/build

# Veroeffentlichen der Anwendung
FROM build AS publish
RUN dotnet publish "TicketsPlease.Web.csproj" -c Release -o /app/publish

# Laufzeitumgebung mit .NET 10.0 ASP.NET Core
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
EXPOSE 8080

# Kopieren der veroeffentlichten Dateien aus dem Publish Layer
COPY --from=publish /app/publish .

# Startpunkt der Anwendung definieren
ENTRYPOINT ["dotnet", "TicketsPlease.Web.dll"]
```

---

### `stack.yml` (Docker Swarm Produktion)
Die Swarm-Konfiguration wurde in mehreren Schritten verfeinert und gehärtet:
* **Registry-IP:** Aktualisierung des Web-Images auf die physische IP des Managers (`172.16.7.42:5000`), damit Worker-Nodes das Image im Cluster ziehen können.
* **Syntax-Bereinigung:** Environment-Variablen wurden von Sequenzen (`- KEY=VALUE`) auf native YAML-Mappings (`KEY: "VALUE"`) umgestellt.
* **Hochverfügbarkeit & Updates:** Skalierung des Web-Services auf 2 Replikate (`replicas: 2`) mit definierten Update-Verzögerungen (`delay: 10s`) und einer aggressiven Restart-Policy bei Ausfällen.
* **Placement Constraints:** Beschränkung der Microsoft SQL Server-Datenbank ausschließlich auf den Manager-Node (`node.role == manager`) zur Vermeidung von Dateninkonsistenzen.
* **Sicherheits-Hardening:** Entfernung des hardcodierten Passworts `SecurePassword123!` durch die dynamische Variable `${MSSQL_SA_PASSWORD}` zur Vermeidung von Credential-Leaks im Git-Repository.

```yaml
# Version der Docker Compose Spezifikation für Swarm
version: '3.8'

services:
  web:
    # Verwendet die physische IP des Managers für den Image-Download durch Worker-Nodes
    image: 172.16.7.42:5000/ticketsplease:latest
    ports:
      # Mappt den Host-Port 8080 auf den Container-Port 8080
      - "8080:8080"
    environment:
      # Definition der Umgebungsvariablen im Key-Value Format
      ASPNETCORE_ENVIRONMENT: "Production"
      # Connection String nutzt den Swarm Service-Namen tickets_db für DNS-Auflösung
      ConnectionStrings__DefaultConnection: "Server=tickets_db;Database=TicketsPlease;User Id=sa;Password=${MSSQL_SA_PASSWORD};TrustServerCertificate=True;"
    networks:
      - my-overlay-net
    depends_on:
      - db
    deploy:
      # Startet zwei Replikate der Webanwendung für Hochverfügbarkeit
      replicas: 2
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        # Bedingung any erzwingt den Neustart auch bei Exit Code 0
        condition: any
        delay: 5s

  db:
    # Offizielles SQL Server 2022 Image
    image: mcr.microsoft.com/mssql/server:2022-latest
    environment:
      ACCEPT_EULA: "Y"
      MSSQL_SA_PASSWORD: "${MSSQL_SA_PASSWORD}"
    networks:
      - my-overlay-net
    volumes:
      # Bindet das persistente Volume für Datenbankdateien ein
      - mssql-data:/var/opt/mssql
    deploy:
      placement:
        constraints:
          # Beschränkt die Datenbankausführung ausschließlich auf den Manager-Node
          - node.role == manager

networks:
  my-overlay-net:
    # Deklariert das existierende attachable Overlay-Netzwerk
    external: true

volumes:
  # Deklariert das benannte Volume für persistente Datenhaltung
  mssql-data:
```

---

### `docker-compose.yml` (Lokale Entwicklung)
Speziell für das schnelle lokale Starten der Entwicklungs-Datenbank und der Web-App wurde diese compose-Datei hinzugefügt. Sie baut das Image lokal und verlinkt die Container.

```yaml
version: '3.8'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ConnectionStrings__DefaultConnection=Server=db;Database=TicketsPlease;User Id=sa;Password=YourStrongPass123!;TrustServerCertificate=True;
    depends_on:
      - db

  db:
    image: mcr.microsoft.com/mssql/server:2022-latest
    ports:
      - "1433:1433"
    environment:
      - ACCEPT_EULA=Y
      - MSSQL_SA_PASSWORD=YourStrongPass123!
    volumes:
      - mssql-data:/var/opt/mssql

volumes:
  mssql-data:
```