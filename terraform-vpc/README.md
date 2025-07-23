# 🌐 Terraform AWS VPC Setup

This Terraform configuration creates a custom VPC on AWS with:

- A user-defined CIDR block
- Two public subnets in different availability zones (`us-east-2a` and `us-east-2b`)
- An Internet Gateway
- A public route table with a default route to the internet
- A route table association for Subnet A

---

## 📁 Files

- `main.tf` – Terraform resources for VPC, subnets, IGW, and routing
- `variables.tf` – Input variable definitions
- `terraform.tfvars` – (Optional) Values for input variables
- `README.md` – Project documentation

---

##  Resources Created

| Resource                             | Description                            |
|--------------------------------------|----------------------------------------|
| `aws_vpc.main`                       | Main VPC                               |
| `aws_subnet.publicsubnetA`          | Public Subnet A (`us-east-2a`)         |
| `aws_subnet.publicsubnetB`          | Public Subnet B (`us-east-2b`)         |
| `aws_internet_gateway.igw`          | Internet Gateway for VPC               |
| `aws_route_table.publicroutetable`  | Route table for public internet access |
| `aws_route_table_association.publicassocation` | Associates Subnet A with the public route table |

---

## ⚙️ Usage

```bash
terraform init

terraform plan

terraform apply

### Destroy the infrastructure (when done)
terraform destroy 


