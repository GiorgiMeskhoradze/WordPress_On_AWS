WordPress on AWS
Production-grade WordPress deployment on AWS using Terraform, Ansible, and GitHub Actions. Application runs in private subnets behind a load balancer with shared storage and automated CI/CD.
Architecture
Internet → Route 53 → ALB → Auto Scaling Group (private subnets)
                                    ↓              ↓
                                  RDS MySQL       EFS (shared media)

VPC — public subnets for ALB & Jenkins, private subnets for app, RDS, EFS
ALB — handles HTTPS termination, HTTP → HTTPS redirect
ASG — 2 instances by default, scales to 3, ELB health checks
RDS — MySQL 8.0 in private subnet, accessible only from app layer
EFS — shared /var/www/wordpress across all instances
ACM — TLS certificate with DNS validation via Route 53
CloudWatch + SNS — CPU alarms with email alerts

CI/CD Pipeline
Every push to main triggers:

Setup SSH key + install Ansible & boto3
Discover Jenkins IP and RDS endpoint via AWS CLI
Inject values into inventory and vars
Suspend ASG health checks
Run Ansible playbook
Resume ASG health checks

Project Structure
├── terraform/
│   ├── environments/dev/
│   └── modules/
│       ├── vpc/
│       ├── ec2/
│       ├── asg/
│       ├── alb/
│       ├── rds/
│       ├── efs/
│       ├── acm/
│       ├── security-group/
│       └── monitoring/
├── ansible/
│   ├── playbooks/
│   └── roles/wordpress/
│       ├── tasks/
│       ├── templates/
│       ├── handlers/
│       └── vars/
└── .github/workflows/
Prerequisites

AWS account with IAM permissions
Terraform >= 1.0
Ansible >= 2.12
S3 bucket + DynamoDB table for Terraform state
Route 53 hosted zone for your domain
SSH key pair in AWS

Getting Started
1. Clone the repo
bashgit clone https://github.com/GiorgiMeskhoradze/WordPress_On_AWS.git
cd yourrepo
2. Configure Terraform variables
bashcd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
3. Deploy infrastructure
bashterraform init
terraform apply
4. Encrypt secrets
bashansible-vault encrypt ansible/roles/wordpress/vars/secrets.yml
5. Add GitHub Secrets
Secret Description AWS_ACCESS_KEY_IDAWS access keyAWS_SECRET_ACCESS_KEYAWS secret key SSH_PRIVATE_KEY Contents of your .pem file VAULT_PASS Ansible Vault password ANSIBLE_SECRETS Encrypted secrets.yml content
6. Push to main — pipeline handles the rest
Tech Stack
Layer Tool Infrastructure Terraform Configuration Ansible CI/CD GitHub Actions Web server Nginx Runtime PHP8.3-FPM DatabaseRDS MySQL 8.0 Storage Amazon EFS TLS AWS ACM DNS Route53 Monitoring CloudWatch + SNS