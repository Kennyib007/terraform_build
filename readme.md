
# Terraform AWS Dev Environment

This project provisions a cloud-based development environment on AWS using Infrastructure as Code (IaC) with Terraform.

It automates the creation of key infrastructure components including a custom VPC, subnets, routing, security groups, and an EC2 instance. A key aspect of the design is enabling secure and seamless SSH access to the instance via a generated SSH config file, making it easy to connect with tools like VS Code Remote SSH.

The project is ideal for developers and DevOps engineers who want a reproducible and scalable dev environment, and demonstrates Terraform concepts such as data sources, resource dependencies, provisioners, output values, and state management.

This Terraform project provisions:

- A **Virtual Private Cloud (VPC)** with public subnets
- An **Internet Gateway** and **route table** for internet access
- A **Security Group** allowing SSH access
- An **EC2 instance** using the latest Amazon Linux 2 AMI
- A **key pair** for SSH authentication
- A **local SSH config entry** using a `local-exec` provisioner to simplify SSH access
- A **userdata** script to install docker, minikube and kubectl to instance upon launch

While provisioner `local-exec` works for this use case it is recommended as a last case option for configuration management. The project will be continously refactored to improve general structure.

---

## File Structure
.
├── main.tf               # Main Terraform config
├── variables.tf          # Input variables
├── outputs.tf            # Output values (like instance IP)
├── provider.tf           # AWS provider setup
├── terraform.tfvars      # User-defined variable values
└── .gitignore            # Ignores sensitive and state files

