# Homelab Infrastructure

Infrastructure as Code (IaC) for a personal homelab: Ansible playbooks, Docker Compose stacks, and encrypted secrets via Ansible Vault. Playbooks deploy the host, containers, reverse proxy, SSO, monitoring, and tunnel-based external access.

## Stack

### Host and platform

Base system configuration and security hardening on the Ubuntu services host:

-   **Base System Setup** - Ubuntu Server hardening, user management, SSH configuration.
-   **Storage Configuration** - Proxmox directory storage for VM disks. Ansible configures data volumes on the **Ubuntu services host**. **NFS** on the hypervisor sends **VM backups** to a NAS. **NFS** on the services host sends app-level backups (e.g. Nextcloud BorgBackup) to the same NAS.
-   **Docker & Docker Compose** - Containerized service deployment. Container runtime with security configurations on the daemon.
-   **VPN Access** - WireGuard setup for secure remote administration.
-   **Ansible** - Infrastructure automation and configuration management. Declarative, version-controlled playbooks and vars for repeatable deploys. Idempotent tasks (intended to be re-run without unintended drift). Public variables in `vars.yml`, encrypted secrets in Vault.
-   **Ansible Vault** - Encrypted secrets management. Sensitive values in `vault.yml`. Credentials and tokens referenced from playbooks.

### Core infrastructure services

-   **Traefik Reverse Proxy** - Reverse proxy with SSL termination and routing. Let's Encrypt certificates (Cloudflare DNS challenge) for any service that has a Traefik router enabled in its playbook and `traefik_routed_services`.
-   **AdGuard Home** - DNS filtering with blocklists. Automatic failover to Cloudflare DNS configured in OPNsense (without failover, the network loses DNS if AdGuard fails).
-   **NTFY Notification Service** - Real-time push notifications with token-based authentication. Alerts from monitoring, deploy scripts, backup jobs, and weekly system update checks.
-   **Portainer CE** - Browser-based Docker control: inspect what is running, manage Compose stacks, and review logs and disk usage without relying on the CLI for day-to-day work.

### Monitoring, dashboards, and operations

-   **Prometheus + Grafana** - Infrastructure monitoring with custom Grafana dashboards built from Prometheus scrape targets: host resource usage (CPU, memory, disk) via node_exporter, network metrics from OPNsense, container metrics from cAdvisor, DNS metrics from AdGuard Home (adguard-exporter), and uptime check metrics from Uptime Kuma.
-   **Uptime Kuma** - Service availability and uptime monitoring. Notifies with NTFY on failure.
-   **WUD (What's Up Docker)** - Docker container update monitoring and selective update notifications. Image bumps via playbooks.
-   **Homarr Dashboard** - Centralized service dashboard with Proxmox, Docker, and AdGuard Home integration.

### Authentication and external access

-   **Authentik SSO** - Single Sign-On (SSO) and identity management with OIDC/SAML2/LDAP support. Centralized authentication for web apps. Role-Based Access Control with per-service and per-group permissions.
    -   PostgreSQL backend for user data
    -   Redis caching for performance
    -   Forward auth and native OIDC integration
    -   Email recovery with custom templates
-   **Pangolin & Newt** - Secure tunneling for external access without port forwarding. VPS-based server, encrypted WireGuard connections, resource-based service exposure. Pangolin/Newt terminates on Traefik on the host (no inbound port forward on the home router).

### Security and isolation

-   **CrowdSec** - IDS/IPS with behavioral analysis, community blocklists, local decisions, automated response, and decision management.
    -   Cloudflare Turnstile captcha integration
-   **System Hardening** - Ubuntu security configurations and firewall rules.
-   **Container Isolation** - Shared `homelab` bridge for east-west traffic between core services, plus dedicated `*-traefik` bridges between Traefik and each HTTPS-routed app (`traefik_routed_services` in `vars.yml`).
-   **Logging** - Docker container logs and host/journal logs as configured per service.

### Personal apps

-   **Nextcloud All-in-One** - File synchronization, collaboration, and productivity suite.
-   **IT Tools** - 100+ developer and IT utilities collection.
-   **ConvertX** - Universal file conversion service supporting 1000+ formats.

## Architecture

### Request path

```
Internet → Cloudflare → Pangolin VPS → Encrypted Tunnel → Homelab
                                                           ↓
                                          Traefik (SSL + Routing)
                                                           ↓
                                        Authentik SSO (Authentication)
                                                           ↓
                                          Individual Services
```

## Deployment and data

-   **Playbook-driven deploys** - Services brought up via `deploy-*.yml` playbooks.
-   **Configuration Templating** - Jinja2 templates for dynamic configuration generation, rendered with environment variables on the host.
-   **Dependency Management** - Service ordering and health checks in playbooks.
-   **Docker Compose** - Per-service compose templates with networks, volumes, and automatic restarts.
-   **Rollback** - Documented/manual steps where playbooks support reverting config or images.
-   **Persistent Storage** - Docker volumes for service data persistence.
-   **Backup Strategy** - Automated backup scheduling with notification integration.

## Service Matrix

| Service         | Purpose           | Authentication             | External Access  |
| --------------- | ----------------- | -------------------------- | ---------------- |
| **Authentik**   | SSO/Identity      | Built-in Admin             | ✅ Pangolin      |
| **ConvertX**    | File Conversion   | Authentik Forward Auth     | ✅ Pangolin      |
| **Grafana**     | Dashboards        | Authentik OIDC             | ✅ Pangolin      |
| **Homarr**      | Dashboard         | Authentik OIDC             | ✅ Pangolin      |
| **IT Tools**    | Utilities         | Authentik Forward Auth     | ✅ Pangolin      |
| **NTFY**        | Notifications     | Authentik Forward Auth     | ✅ Pangolin      |
| **Nextcloud**   | File Sync         | Authentik OIDC             | ✅ Pangolin      |
| **Uptime Kuma** | Monitoring        | Authentik Forward Auth     | ✅ Pangolin      |
| **Traefik**     | Reverse Proxy     | Authentik Forward Auth     | ❌ Internal Only |
| **AdGuard**     | DNS Filtering     | Authentik Header Injection | ❌ Internal Only |
| **Portainer**   | Docker UI         | Authentik OIDC             | ❌ Internal Only |
| **Prometheus**  | Metrics           | Authentik Forward Auth     | ❌ Internal Only |
| **WUD**         | Update Monitoring | Authentik OIDC             | ❌ Internal Only |
