# AWS-EC2-Terraform-Docker-Strappi-Private_EC2

# Task-4: Deploy Strapi Application on Docker (AWS Private Subnet via Bastion Server)

## Overview
This project demonstrates the deployment of a **Strapi application** using **Docker** on an **AWS EC2 instance** within a **private subnet**. The application is accessed securely through a **bastion server**.

Strapi is a headless CMS that allows content management with API-first architecture. Docker ensures the application runs consistently across different environments.

---

             ┌─────────────────────────┐
             │        Internet         │
             └───────────┬────────────┘
                         │ SSH
                         v
             ┌─────────────────────────┐
             │   Bastion Server        │
             │   (Public Subnet)       │
             │ - Accessible via SSH    │
             │ - Security Group restricts │
             │   access to your IP     │
             └───────────┬────────────┘
                         │ SSH Tunnel
                         v
             ┌─────────────────────────┐
             │  Private EC2 Instance   │
             │  (Private Subnet)      │
             │ - Runs Docker          │
             │ - Hosts Strapi app     │
             │ - Only accessible via  │
             │   Bastion Server       │
             └───────────┬────────────┘
                         │ Docker Volume
                         v
             ┌─────────────────────────┐
             │  Persistent Storage     │
             │  /srv/strapi/uploads    │
             │ - Stores uploaded files │
             │ - Data persists outside │
             │   the container        │
             └─────────────────────────┘



**Components:**

- **Internet:** Origin of SSH connections from your machine.  
- **Bastion Server:** Publicly accessible server for secure access to private EC2 instances.  
- **Private EC2:** Runs Strapi in Docker, isolated from the internet.  
- **Docker Container:** Encapsulates Strapi app for consistency.  
- **Persistent Storage:** Stores uploaded files outside the container to maintain data persistence.

---

## Prerequisites

Before starting, ensure you have:

- AWS account with proper IAM permissions.  
- EC2 instances launched:  
  - Bastion Server (Public Subnet)  
  - Private EC2 Instance (Private Subnet)  
- Security groups configured:  
  - Bastion: Allow SSH (22) from your IP  
  - Private EC2: Allow SSH only from Bastion  
  - Strapi port (1337) open for internal testing if needed  
- Docker installed on private EC2.  
- Node.js installed (optional for Strapi CLI).  
- SSH client (MobaXterm, PuTTY, or terminal).

---

## Setup Instructions

## 1. Connect to Bastion Server
```bash
ssh -i /path/to/key.pem ec2-user@<Bastion-Public-IP>
```
##2. Connect to Private EC2 via Bastion

3. Install Docker on Private EC2
```
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
docker --version
```
4. Create Persistent Storage Directory
    ```
   sudo mkdir -p /srv/strapi/uploads
   sudo chown -R ec2-user:ec2-user /srv/strapi/uploads
   ```
##5. Pull and Run Strapi Docker Container
```docker rm -f strapi || true

docker run -d \
  --name strapi \
  --restart unless-stopped \
  -p 1337:1337 \
  -v /srv/strapi/uploads:/app/public/uploads \
  strapi/strapi
```
##6. Verify Strapi Container
```
docker ps
   docker logs strapi
docker exec -it strapi bash
```
## Accessing Strapi via Application Load Balancer (ALB)

In a production-like setup, Strapi can be accessed securely through an **AWS Application Load Balancer (ALB)** that sits in front of your private EC2 instance.

## 1. Setup ALB
- Create an **ALB** in a **public subnet**.  
- Configure a **target group** pointing to your private EC2 instance running Strapi (port 1337).  
- Ensure the ALB’s **security group** allows HTTP/HTTPS traffic from the internet.  
- Ensure the **EC2 security group** allows traffic from the ALB only.

## 2. Access Strapi
Once the ALB is configured and healthy:

1. Get the **DNS name** of your ALB from the AWS console (e.g., `my-strapi-alb-123456.ap-south-1.elb.amazonaws.com`).  
2. Open a browser and navigate to:

```
http://strapi-alb-785125566.ap-south-1.elb.amazonaws.com/admin
```
---
> If you configure HTTPS on the ALB, you can use `https://<ALB-DNS-Name>` instead.

## 3. Notes
- The ALB forwards requests to the private EC2 instance securely.  
- No need for SSH tunnel or direct public access to the EC2 instance.  
- You can later configure **SSL/TLS** on the ALB for secure HTTPS access.  
- ALB ensures **high availability** and **scalability** if multiple EC2 instances are added in the target group.

---
