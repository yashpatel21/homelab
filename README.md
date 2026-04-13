# Homelab Infrastructure

A comprehensive Infrastructure as Code (IaC) solution for deploying enterprise-grade homelab services using Ansible automation, Docker containerization, and modern DevOps practices.

## Architecture Overview

This project implements a **fully automated, reproducible homelab infrastructure** across 5 deployment phases, featuring enterprise-grade security, comprehensive monitoring, and secure external access capabilities.

### Core Technologies

-   **Ansible** - Infrastructure automation and configuration management
-   **Docker & Docker Compose** - Containerized service deployment
-   **Ansible Vault** - Encrypted secrets management
-   **Traefik** - Reverse proxy with automated SSL certificate management
-   **Authentik** - Single Sign-On (SSO) and identity management with OIDC/SAML2/LDAP support
-   **Prometheus & Grafana** - Infrastructure monitoring with custom dashboards and OPNsense integration
-   **CrowdSec** - Intrusion Detection/Prevention System (IDS/IPS) with behavioral analysis
-   **NTFY** - Real-time push notification service with token authentication
-   **AdGuard Home** - DNS filtering with automated OPNsense failover for internet reliability
-   **Uptime Kuma** - Service availability monitoring with multi-channel notifications
-   **WUD** - Docker container update monitoring with selective management
-   **Pangolin & Newt** - Secure tunneling for external access without port forwarding

## Deployment Phases

### Phase 1: Infrastructure Foundation

**Base system configuration and security hardening**

-   **Base System Setup** - Ubuntu Server hardening, user management, SSH configuration
-   **Storage Configuration** - Docker volumes, backup directories, persistent storage
-   **Docker Installation** - Container runtime with security configurations
-   **SSL Certificate Management** - Let's Encrypt automation for management interfaces
-   **VPN Access** - WireGuard setup for secure remote administration

### Phase 2: Core Services

**Essential infrastructure services with automated failover**

-   **Traefik Reverse Proxy** - SSL termination, routing, automatic certificate management
-   **NTFY Notification Service** - Real-time push notifications with token-based authentication
-   **AdGuard Home** - DNS filtering with automated OPNsense failover (critical for internet reliability - if AdGuard fails, entire network internet access would be lost without failover)

### Phase 3: Supporting Services

**Monitoring, dashboards, and operational tools**

-   **Homarr Dashboard** - Centralized service dashboard with Proxmox integration
-   **Uptime Kuma** - Service monitoring with multi-notification channels
-   **WUD (What's Up Docker)** - Container update notifications with selective management
-   **Prometheus + Grafana** - Infrastructure monitoring with custom dashboards and OPNsense integration

### Phase 4: Productivity Services

**Productivity and utility platforms**

-   **Nextcloud All-in-One** - File synchronization, collaboration, and productivity suite
-   **IT Tools** - 100+ developer and IT utilities collection
-   **ConvertX** - Universal file conversion service supporting 1000+ formats

### Phase 5: Authentication & External Access

**Enterprise security and secure external access**

-   **Authentik SSO** - Complete identity management with OIDC/SAML2/LDAP support
    -   PostgreSQL backend for user data
    -   Redis caching for performance
    -   Forward auth and native OIDC integration
    -   Email recovery with custom templates
-   **🔗 Pangolin Secure Tunneling** - External access without port forwarding
    -   VPS-based server deployment
    -   Encrypted tunnel connections
    -   Resource-based service exposure
-   **CrowdSec Security** - Advanced threat protection
    -   Behavioral analysis and threat detection
    -   Cloudflare Turnstile captcha integration
    -   Automated decision management

## Security Features

### Infrastructure Security

-   **Encrypted Secrets Management** - All sensitive data stored in Ansible Vault
-   **SSL/TLS Everywhere** - Automated certificate management for all services
-   **Container Isolation** - Docker containerization with shared homelab network
-   **System Hardening** - Ubuntu security configurations and firewall rules

### Authentication & Access Control

-   **Single Sign-On (SSO)** - Centralized authentication via Authentik
-   **Token-Based Authentication** - TOTP capability available in Authentik
-   **Role-Based Access Control** - Granular permissions per service and user group
-   **Secure External Access** - Encrypted tunneling without direct internet exposure

### Monitoring & Threat Detection

-   **Real-time Monitoring** - Prometheus metrics with Grafana visualization
-   **Behavioral Analysis** - CrowdSec threat detection with automated response
-   **Proactive Notifications** - NTFY integration for immediate issue alerts
-   **Comprehensive Logging** - Centralized log collection and analysis

## Monitoring & Observability

### Infrastructure Monitoring

-   **System Metrics** - CPU, memory, disk, network monitoring via Prometheus
-   **Service Health** - Uptime Kuma monitoring with multi-channel notifications
-   **Container Updates** - WUD monitoring for Docker image updates
-   **Network Performance** - OPNsense integration with custom Grafana dashboards

### Automated Notifications

-   **Update Notifications** - Weekly system update checks with NTFY alerts
-   **Service Monitoring** - Real-time uptime monitoring with immediate notifications
-   **DNS Failover** - Automatic AdGuard failover with OPNsense integration

### Custom Dashboards

-   **Unified Monitoring** - Single Grafana dashboard for infrastructure overview
-   **Service Status** - Homarr dashboard with integrated service health
-   **Security Overview** - CrowdSec decision tracking and threat analysis

## DevOps Practices

### Infrastructure as Code

-   **Declarative Configuration** - All infrastructure defined in version-controlled code
-   **Reproducible Deployments** - Identical environments via automated playbooks
-   **Idempotent Operations** - Safe execution of automation without side effects
-   **Environment Separation** - Public variables and encrypted secrets management

### Configuration Management

-   **Zero-Touch Deployment** - Fully automated service provisioning via Ansible
-   **Configuration Templating** - Jinja2 templates for dynamic configuration generation
-   **Dependency Management** - Proper service ordering and health checks
-   **Rollback Capabilities** - Safe deployment practices with rollback procedures

### Container Orchestration

-   **Docker Compose** - Service definitions with proper networking and volumes
-   **Health Checks** - Container health monitoring and automatic restarts
-   **Resource Management** - CPU and memory limits for stable operations
-   **Update Strategies** - Controlled container updates with minimal downtime

## 🔧 Technical Implementation

### Service Architecture

```
Internet → Cloudflare → Pangolin VPS → Encrypted Tunnel → Homelab
                                                           ↓
                                          Traefik (SSL + Routing)
                                                           ↓
                                        Authentik SSO (Authentication)
                                                           ↓
                                          Individual Services
```

### Network Flow

-   **External Traffic** - Cloudflare DNS → Pangolin tunneling → Traefik reverse proxy
-   **Authentication** - Authentik SSO with forward auth and OIDC integration
-   **Internal Communication** - Docker networks with service discovery
-   **Monitoring Data** - Prometheus metrics collection → Grafana visualization

### Data Management

-   **Persistent Storage** - Docker volumes for service data persistence
-   **Backup Strategy** - Automated backup scheduling with notification integration
-   **Configuration Management** - Template-based configuration with environment variables
-   **Secrets Handling** - Ansible Vault encryption for all sensitive data

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
| **Prometheus**  | Metrics           | Authentik Forward Auth     | ❌ Internal Only |
| **WUD**         | Update Monitoring | Authentik OIDC             | ❌ Internal Only |

## Quick Start

### Prerequisites

-   Ansible installed (conda environment provided)
-   Proxmox VE with Ubuntu Server 22.04+ VM or bare metal Ubuntu Server
-   Domain name with Cloudflare DNS management
-   VPS for external access (optional)

### Deployment

```bash
# 1. Setup Ansible environment
conda env create -f environment.yml
conda activate homelab

# 2. Configure variables
cd inventory/group_vars/all
cp vault_template.yml vault.yml
# Edit vault.yml with your values
ansible-vault encrypt vault.yml

# 3. Deploy infrastructure
ansible-playbook -i inventory/homelab.yml playbooks/infrastructure/setup-base.yml --ask-vault-pass

# 4. Deploy services by phase
ansible-playbook -i inventory/homelab.yml playbooks/services/deploy-traefik.yml --ask-vault-pass
# Continue with remaining services...
```
