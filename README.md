# InnovateMart: EKS Microservices Infrastructure (Project Bedrock)

This repository contains the **Infrastructure as Code (Terraform)** and **Kubernetes manifests** for **Project Bedrock** — a highly available, scalable retail application deployed on **Amazon EKS**.

This project demonstrates real-world cloud engineering practices including networking, container orchestration, CI/CD, security, and database integration.

---

## 🚀 Live Demo

**Storefront URL:**  
http://k8s-retailap-retailap-3c6aa53d7a-814425573.us-east-1.elb.amazonaws.com

---

## 🏗️ Architecture Overview

The project implements a modern **cloud-native microservices architecture**:

- **VPC Networking**
  - Custom VPC
  - 3 Public subnets
  - 3 Private subnets
  - Multi-AZ deployment for high availability

- **Container Orchestration**
  - Amazon **EKS (Elastic Kubernetes Service)**
  - Four independently deployed microservices

- **Data Layer**
  - **Amazon RDS (MySQL)** — Catalog service
  - **Amazon RDS (PostgreSQL)** — Orders service
  - **DynamoDB Local** — Carts service

- **Serverless**
  - **AWS Lambda** triggered by **S3** for automated image processing

- **Traffic Management**
  - AWS **Application Load Balancer (ALB)** integrated with Kubernetes Ingress

---

## 🛠️ Tech Stack

- **Terraform** — Infrastructure provisioning
- **Kubernetes** — Container orchestration
- **AWS Services**
  - EKS
  - RDS
  - DynamoDB
  - S3
  - Lambda
  - IAM
  - ALB
- **GitHub Actions** — CI/CD pipeline for automated deployments

---

## 📋 Features & Implementation Details

### 1. Service Discovery & Networking

To ensure reliable communication between microservices:

- Implemented **Kubernetes hostAliases**
- Used **environment variable overrides**
- Resolved internal DNS issues (`NXDOMAIN`) between the UI and backend services

This ensured stable service-to-service communication inside the cluster.

---

### 2. Database Initialization

#### Relational Databases
- Automated schema migrations for:
  - **MySQL**
  - **PostgreSQL**
- Managed using **Flyway** during application startup

#### NoSQL (DynamoDB Local)
- Manual initialization of the `Items` table
- Achieved using:
  - `kubectl port-forward`
  - AWS CLI against DynamoDB Local

---

### 3. Security & RBAC

- Created a dedicated **Developer View IAM User**
  - User: `bedrock-dev-view`
  - Restricted permissions (read-only access)
- Sensitive values managed using:
  - Terraform outputs
  - Kubernetes Secrets
- Followed the **principle of least privilege**

---

## 💻 Deployment Guide

### Prerequisites

Ensure the following tools are installed and configured:

- AWS CLI (configured with valid credentials)
- Terraform `>= 1.5.0`
- kubectl

---

### Deployment Steps

#### 1️⃣ Provision Infrastructure

```bash
terraform init
terraform apply --auto-approve
## 🛠️ Step-by-Step Implementation Guide

### Phase 2: Kubernetes Deployment & Networking
1.  **ALB Ingress Controller**: Installed the AWS Load Balancer Controller using Helm and IAM OIDC provider to automatically manage the Application Load Balancer (ALB).
2.  **Microservices Deployment**: Applied Kubernetes manifests for the four core services: `ui`, `catalog`, `carts`, and `orders`.
3.  **Internal DNS Patching**: To resolve connectivity issues where services couldn't find each other (`NXDOMAIN` errors), I implemented **Host Aliases** in the UI deployment to map internal `ClusterIP` addresses to service names.



### Phase 3: Data Layer Initialization & Troubleshooting
1.  **Database Migration**: Verified via `kubectl logs` that the Catalog (MySQL) and Orders (Postgres) services successfully ran Flyway migrations against the RDS instances.
2.  **DynamoDB Local Setup**: The Carts service required a manual schema initialization. I used `kubectl port-forward` to bridge the local DynamoDB container and executed the following:
    ```bash
    aws dynamodb create-table \
        --table-name Items \
        --attribute-definitions AttributeName=id,AttributeType=S \
        --key-schema AttributeName=id,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
        --endpoint-url [http://127.0.0.1:8000](http://127.0.0.1:8000) \
        --region us-east-1
    ```
3.  **Environment Sync**: Updated the UI deployment environment variables to ensure endpoints were prefixed correctly (e.g., `CATALOG_ENDPOINT=http://retail-app-catalog:80`).



### Phase 4: Serverless Flow & Validation
1.  **S3 Storage**: Created the S3 bucket `bedrock-assets-alt-soe-025-1379` with a public-read policy for asset delivery.
2.  **Lambda Trigger**: Configured a Python Lambda function with an S3 trigger (`s3:ObjectCreated:*`). 
3.  **Observability**: Verified the end-to-end flow by uploading an image and checking **CloudWatch Logs** for the "Image received" event execution.

---

## 🏆 Final Deliverable Checklist
- [x] **GitHub Repo**: Publicly accessible.
- [x] **Grading Data**: `grading.json` present in the root.
- [x] **Store URL**: Live via AWS Application Load Balancer.
- [x] **IAM User**: `bedrock-dev-view` credentials shared in the Google Doc.