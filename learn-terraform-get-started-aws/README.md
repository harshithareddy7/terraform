# Terraform AWS Infrastructure Setup

This project uses **Terraform** to provision and manage infrastructure in **AWS**. It serves as a foundational setup for creating resources such as EC2 instances, VPCs, subnets, and related networking components.

## 🛠️ Project Structure

| File | Description |
|------|-------------|
| `main.tf`       | Defines AWS provider, data sources, and EC2 instance resources. |
| `outputs.tf`    | Declares output variables like instance hostname, IP, etc. |
| `terraform.tf`  | Configures Terraform settings, provider versions, and required Terraform version. |
| `variables.tf`  | Contains input variable definitions used across the configuration. |