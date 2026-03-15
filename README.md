# Azure DevOps CI/CD Pipeline — Terraform + AKS Deployment

## Overview
YAML-based multi-stage Azure DevOps pipeline automating end-to-end 
infrastructure provisioning and application deployment on Microsoft Azure.

## Architecture
GitHub Repo (main branch push)
↓
Azure DevOps Pipeline (azure-pipelines.yml)
│
├── Stage 1: Terraform
│ ├── terraform init
│ ├── terraform plan
│ └── terraform apply
│ └── Provisions: RG + AKS + ACR + Key Vault
│
├── Stage 2: Docker Build
│ ├── Build image from Dockerfile
│ └── Push to Azure Container Registry (ACR)
│
└── Stage 3: Deploy to AKS
├── Environment approval gate
├── Rolling update deployment (zero downtime)
└── Liveness + Readiness health probes

text

## Tech Stack
| Tool | Purpose |
|---|---|
| Terraform | Infrastructure as Code — AKS, ACR, Key Vault |
| Azure DevOps (YAML) | Multi-stage CI/CD pipeline |
| Azure Kubernetes Service | Container orchestration |
| Azure Container Registry | Private Docker image registry |
| Azure Key Vault | Secrets management (zero hardcoded credentials) |
| Docker | Application containerization |
| Azure RBAC + Managed Identity | Least-privilege security model |

## Key Features
- **Zero hardcoded secrets** — All credentials via Azure Key Vault + Variable Groups
- **Rolling deployment** — Zero downtime with automated rollback on health probe failure
- **Environment approval gates** — Manual approval required before production deploy
- **Managed Identity** — Pipeline authenticates to Azure without service principal passwords
- **IaC everything** — Full infra reproducible via single `terraform apply`

## Pipeline Stages
### Stage 1 — Infrastructure (Terraform)
Provisions complete Azure infrastructure from scratch:
- Resource Group
- AKS cluster (Standard_B2s, 1 node)
- Azure Container Registry (Basic SKU)
- Key Vault with access policies

### Stage 2 — Build
- Builds Docker image from application Dockerfile
- Tags with `$(Build.BuildId)` for traceability  
- Pushes to private ACR (no public registry)

### Stage 3 — Deploy
- Pulls manifest from `k8s/deployment.yaml`
- Rolling update: maxSurge=1, maxUnavailable=0
- Health probes validate deployment before completing
