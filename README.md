# 🏗️ AWS 3-Tier Architecture with Terraform

## 📋 Project Overview

This project implements a **production-ready 3-tier architecture** on Amazon Web Services (AWS) using **Terraform** as Infrastructure as Code (IaC). The infrastructure is designed following AWS best practices for **high availability, security, and scalability**.

### The Three Tiers:
- **🌐 Web Tier**: Public-facing load balancer and EC2 instances in public subnets
- **⚙️ Application Tier**: Internal application servers in private subnets
- **🗄️ Database Tier**: RDS MySQL in isolated private subnets
