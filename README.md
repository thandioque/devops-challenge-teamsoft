# DevOps Challenge - Server

This project demonstrates the setup of a server infrastructure using Terraform, Docker Compose, Nginx, Grafana, and Prometheus, integrated with GitHub Actions for CI/CD. The main goal is to provision and configure a server for application deployment and monitoring, following Infrastructure as Code (IaC) principles.

This is a challenge by Coodesh.

# GitHub Actions Pipelines Documentation

### Pipelines

### 1. **Server Pipeline CI/CD to EC2** (`.github/workflows/server-pipe.yml`)

This pipeline is responsible for performing CI/CD for an application hosted on an EC2 instance. It performs the following steps:

#### Events:
- **push**: Triggered on the main branch whenever changes occur in the src/ or nginx/ directories.
- **pull_request**: Triggered on the main branch for pull requests when changes occur in the src/ or nginx/ directories.
- **workflow_dispatch**: Allows manual execution of the pipeline.

#### Jobs:
- **CI**:
  - **Checkout repository**: Checks out the repository.
  - **Validate docker-compose.yml**: Validates the docker-compose.yml configuration file.

- **CD**:
  - **Checkout repository**: Checks out the repository.
  - **Setup git credentials**: Configures Git credentials.
  - **Deploy application using Docker Compose**: Deploys the application using Docker Compose.
  - **Setup thr server public IP**: Configures the server's public IP for replacement in the Nginx configuration file.
  - **Setup Nginx**: Configures Nginx to use the correct configuration file.
  - **Validate Nginx settings and restart the service**: Validates Nginx settings and restarts the service.

### 2. **Terraform Apply** (`.github/workflows/terraform-apply-pipe.yml`)

This pipeline runs the terraform apply command to apply infrastructure changes in AWS, creating or modifying resources according to the Terraform configuration.

#### Events:
- **push**: Triggered on the main branch whenever changes occur in the terraform/ directory.
- **workflow_dispatch**: Allows manual execution.

#### Jobs:
- **apply**:
  - **Checkout**: Checks out the repository.
  - **Setup Terraform**: Installs the specified Terraform version.
  - **Setup github auth**: Configures GitHub authentication using the provided token.
  - **Setup secret values in the EC2's install file**: Replaces variable values in the EC2 installation script.
  - **Terraform fmt**: Checks if Terraform code is properly formatted.
  - **Terraform Init**: Initializes Terraform with the configured backend.
  - **Terraform Validate**: Validates the Terraform configuration.
  - **Terraform Apply**: Applies infrastructure changes using sensitive variables from secrets.

### 3. **Terraform Destroy** (`.github/workflows/terraform-destroy-pipe.yml`)

This pipeline runs the terraform destroy command to remove infrastructure resources provisioned by Terraform.

#### Events:
- **workflow_dispatch**: Manual execution only.

#### Jobs:
- **destroy**:
  - **Checkout**: Checks out the repository.
  - **Setup Terraform**: Installs the specified Terraform version.
  - **Setup github auth**: Configures GitHub authentication.
  - **Setup secret values in the EC2's install file**: Replaces variables in the EC2 installation script.
  - **Terraform fmt**: Checks formatting.
  - **Terraform Init**: Initializes Terraform.
  - **Terraform Validate**: Validates configuration.
  - **Terraform Destroy**: Destroys infrastructure resources, with options to target specific modules (e.g., EC2 and VPC).

### 4. **Terraform Plan** (`.github/workflows/terraform-plan-pipe.yml`)

This pipeline runs the terraform plan command to generate an execution plan showing proposed infrastructure changes.

#### Events:
- **pull_request**: Triggered on changes to Terraform files.
- **workflow_dispatch**: Manual execution.

#### Jobs:
- **plan**:
  - **Checkout**: Checks out the repository.
  - **Setup Terraform**: Installs Terraform.
  - **Setup github auth**: Configures authentication.
  - **Setup secret values in the EC2's install file**: Replaces variable values ​​in the EC2 installation script.
  - **Terraform fmt**: Checks if the Terraform code is formatted correctly.
  - **Terraform Init**: Initializes Terraform with the configured backend.
  - **Terraform Validate**: Validates the Terraform configuration.
  - **Terraform Plan**: Generates the Terraform execution plan.
  - **Show plan in the Pull Request**: Displays the execution plan as a comment in the Pull Request for review.

## Monitoring Components: Grafana, Prometheus, and Node Exporter

Components responsible for collecting and visualizing server and application metrics.

### Components

*   **Grafana:** A data visualization platform used to create interactive dashboards displaying metrics collected by Prometheus.

*   **Prometheus:** An open-source monitoring and alerting system that collects metrics, stores them as time-series data, and provides a query language (PromQL) to analyze them.

*   **Node Exporter:** An agent running on the server that exposes operating system metrics (CPU, memory, disk, network, etc.) to Prometheus.

### Settings

#### `src/docker-compose.yml`

This file defines the Docker services that make up the monitoring solution.

* **Network:** A bridge network called `network-monitoring` is created to allow communication between containers.  
* **Volumes:** Named volumes `grafana-data` and `prometheus-data` are created to persist Grafana and Prometheus data, respectively.  
* **Services:**
  * **Grafana:** Uses the image `grafana/grafana:11.4.0-ubuntu`. It maps the folders `./grafana/datasources` and `./grafana/dashboard` to provision datasources and dashboards, and uses the `grafana-data` volume to persist data.
  * **Prometheus:** Uses the image `prom/prometheus:v3.1.0`. It maps the file `./prometheus/prometheus.yml` to configure Prometheus and uses the `prometheus-data` volume to persist data.
  * **Node Exporter:** Uses the image `quay.io/prometheus/node-exporter:v1.8.2`. It exposes operating system metrics to Prometheus.

#### `grafana/dashboard/dashboard.yml`

This file configures dashboard provisioning in Grafana.

* **Providers:** Defines a provider called "Prometheus" that loads dashboards from files.  
* **Dashboards:** Specifies that dashboards should be loaded from the `/var/lib/grafana/dashboards` folder.

#### `grafana/dashboard/dashboards/node-exporter-dashboard.json`

This file contains the JSON configuration for the [Node Exporter Full](https://grafana.com/grafana/dashboards/1860-node-exporter-full/) dashboard.

#### `grafana/datasources/datasources.yml`

This file configures Grafana datasources.

* **Datasources:** Defines a datasource called "Prometheus" that connects to Prometheus at `http://prometheus:9090`.

#### `prometheus/prometheus.yml`

This file configures Prometheus.

* **Global:** Defines global settings such as the metrics collection interval (`scrape_interval`).  
* **Scrape Configs:** Defines metric scraping jobs:
  * `job_name: 'prometheus'`: Collects metrics from Prometheus itself.
  * `job_name: 'node'`: Collects metrics from Node Exporter.

## NGINX
NGINX server configuration.
```
server ...: This block defines a virtual Nginx server.

listen 80; : This directive instructs Nginx to listen on port 80, the default port for HTTP. This means that HTTP requests to this server will be routed to it.

server_name $SERVER-IP;: This directive defines the server name. The $SERVER-IP variable will be replaced with the public IP address of the server where Nginx is running.

location / ...: This block defines how Nginx should handle requests to the root path (/). In this case, all requests to the server root are processed by the directives inside this block.

proxy_pass http://localhost:3000
;: This directive is the core of the reverse proxy setup. It instructs Nginx to forward requests to Grafana, which is running on port 3000 on the same server.

proxy_http_version 1.1;: Sets the HTTP protocol version to 1.1, which is required for proper WebSocket support used by Grafana.

proxy_set_header Upgrade $http_upgrade;: This directive forwards the Upgrade header from the original request to Grafana. This is required to establish WebSocket connections.

proxy_set_header Connection 'upgrade';: This directive forwards the Connection header, also required for WebSocket communication.

proxy_set_header Host $host;: This directive forwards the original Host header to Grafana, ensuring that Grafana is aware of the original request host.

proxy_cache_bypass $http_upgrade;: This directive prevents Nginx from caching WebSocket requests.
```


# Terraform

## EC2 Module

## EC2 Installation and Configuration

The `terraform/modules/ec2/install.sh` module is a script that automates the installation of required packages and configurations on an EC2 instance.

### `install.sh` Script Steps:
- **Update existing packages:** Updates Ubuntu packages.
- **Install essential packages:** Installs packages such as `ca-certificates`, `curl`, `gnupg`, `tar`, `jq`, and others.
- **Docker setup:**
  - Adds Docker GPG key.
  - Configures Docker repository.
  - Installs Docker and Docker Compose.
  - Adds the current user to the Docker group and refreshes it.
- **Nginx setup:**
  - Installs Nginx.
  - Removes default configuration.
  - Enables and starts the Nginx service.
- **GitHub Runner setup:**
  - Creates the runner directory for the `ubuntu` user.
  - Downloads and extracts the latest GitHub Actions Runner package.
  - Configures the runner with custom variables.
  - Registers the runner using the repository token.
  - Installs and starts the runner service.

## EC2 Configuration with Terraform

The `main.tf` file defines resources required to create an EC2 instance using Terraform.

### Terraform Resources

#### SSH Key

- **`tls_private_key`**: Generates a private key based on `var.key_algorithm` and `var.key_rds_bits`.
- **`aws_key_pair`**: Creates an AWS key pair from the generated private key.

#### Private Key Storage in S3

- **`aws_s3_object`**: Stores the generated private key in an S3 bucket with server-side encryption.

#### EC2 Instance

- **`aws_instance`**: Creates an EC2 instance with:
  - AMI from `data.aws_ami.server.id`
  - Optional public IP
  - SSH key pair
  - Security group and subnet configuration
  - User data script (`user_data_path`)
  - Additional encrypted EBS volume

#### AMI Configuration

- **`data.aws_ami`**: Retrieves the latest AMI based on filters like name, architecture, and virtualization type.

### EC2 Variables

- **is_associate_public_ip_address** (`bool`)
- **instance_type** (`string`)
- **security_group_id** (`list(string)`)
- **public_subnet_id** (`string`)
- **user_data_path** (`string`)
- **ec2_instance_name** (`string`)
- **ebs_device_name** (`string`)
- **ebs_is_encrypted** (`bool`)
- **ebs_volume_size** (`number`)
- **is_most_recent** (`bool`)
- **ami_name_filter** (`string`)
- **ami_virtualization_type_filter** (`string`)
- **ami_architecture_filter** (`string`)
- **ami_owner** (`string`)

### SSH Key Variables

- **key_algorithm** (`string`)
- **key_rds_bits** (`number`)
- **key_name** (`string`)

### S3 Variables

- **s3_object_bucket_name** (`string`)
- **s3_bucket_acl** (`string`)
- **s3_bucket_server_side_encryption** (`string`)

### Tags

- **tags** (`map(string)`)

## Outputs

- **instance_id**
- **public_instance_ip**

## GitHub Module

### GitHub Resources

#### Repository

- **data "github_repository"**
- **resource "github_repository"**

#### Branch Protection

- **resource "github_branch_protection"**

#### GitHub Actions Secrets

- AWS credentials, runner token, Git token, CIDR config

## S3 Module

### Resources

- Terraform state bucket (with versioning)
- SSH key bucket
- Tags applied to both

### Variables & Outputs

- Bucket names, versioning, tags
- Output: SSH key bucket ID

## VPC Module

### Resources

- VPC
- Internet Gateway
- Security Group
- Ingress rules (SSH, Prometheus, Node Exporter, HTTP)
- Egress rule (allow all — not recommended for production)
- Public subnet
- Route table + association

### Variables & Outputs

- CIDR blocks, ports, protocols, AZ, tags
- Outputs: subnet ID, security group ID

## Terraform Root Files

### `main.tf`

Calls modules:
- S3
- Git
- VPC
- EC2

### Variables

Covers:
- AWS region
- GitHub config
- S3 config
- VPC config
- EC2 config
- Tags

### `locals.tf`

Defines:

*   `Project: "Server"`
*   `Managedby: "Terraform"`
*   `Owner: "Thandi"`

### Outputs

- `public_instance_ip`

## Terraform Configuration Files

### Backend (`backend.hcl`)

- S3 bucket
- Key
- Region

### Provider (`provider.tf`)

- AWS provider
- GitHub provider
- Terraform version constraint

## Technologies Used

- Terraform
- Docker / Docker Compose
- Nginx
- Grafana
- Prometheus
- Node Exporter
- GitHub Actions
- AWS
- Ubuntu LTS
- Bash

## Notes

The variable `main_thandi_cidr_ipv4` restricts access for security, allowing only one IP. Only HTTP (port 80) is publicly accessible.

## Installation

### Prerequisites

- AWS account
- GitHub account
- Terraform
- Docker + Compose
- AWS CLI

### Local Setup

```bash
git clone https://github.com/thandioque/devops-challenge-teamsoft.git
cd devops-challenge-teamsoft
```

## Environment Variables

Example `.tfvars` file:

```hcl
aws_access_key_id     = "YOUR_AWS_ACCESS_KEY"
aws_secret_access_key = "YOUR_AWS_SECRET_KEY"
# ... other variables
```

## Usage

- The CI/CD pipeline is triggered when changes are made to the `src/` and `nginx/` directories:
  - The **CI job** runs when a Pull Request is opened targeting the `main` branch.
  - Both **CI and CD jobs** run when changes are merged into the `main` branch.

- The **Terraform Plan** pipeline runs automatically when a Pull Request is created with changes in the Terraform files.

- The **Terraform Apply** pipeline runs when changes to Terraform files are merged into the `main` branch.

- The **Terraform Destroy** pipeline must be triggered manually.  
  It is configured to destroy only the EC2 and VPC modules, preventing accidental deletion of:
  - The S3 bucket used for Terraform state
  - GitHub-related configurations

## Additional Information

- A **self-hosted GitHub Actions runner** is configured on the EC2 instance.

- **Grafana** is accessible via port **80** on the EC2 instance, with Nginx acting as a reverse proxy to port **3000**.

- **Prometheus (port 9090)** and **Node Exporter (port 9100)** are restricted to a specific IP address for security purposes.

## Final Notes

### Future Improvements

Due to time constraints and AWS free-tier limitations, some enhancements were not implemented but could be considered in future iterations:

- **VPN setup**  
  Implement a VPN solution to provide secure access to infrastructure resources.

- **Backup services**  
  Configure backup solutions such as AWS Backup or EBS Snapshots to ensure data recovery.

- **Kubernetes (k8s + Helm)**  
  Introduce Kubernetes for container orchestration and Helm for package management to improve scalability.

- **Zabbix monitoring**  
  Evaluate Zabbix as an alternative monitoring solution (not implemented due to resource constraints).

- **Advanced security policies**  
  Apply stricter security rules and best practices for production environments.

- **Log monitoring**  
  Integrate logging solutions such as CloudWatch Logs or other observability tools.

- **Auto Scaling & Load Balancing**  
  Implement Auto Scaling Groups and Load Balancers to handle traffic spikes efficiently.

- **HTTPS & SSL certificates**  
  Configure HTTPS with SSL certificates and a custom domain to ensure secure communication.
