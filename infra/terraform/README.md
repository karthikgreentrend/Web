# AWS Terraform Infrastructure with GitFlow CI/CD

This directory contains Terraform infrastructure code for deploying a web application to AWS using GitFlow branching strategy.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              AWS Infrastructure                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                   │
│  │   Route 53   │───▶│  CloudFront  │───▶│     S3       │                   │
│  │  (DNS/SSL)   │    │    (CDN)     │    │  (Hosting)   │                   │
│  └──────────────┘    └──────────────┘    └──────────────┘                   │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                              VPC                                     │    │
│  │  ┌─────────────────────┐    ┌─────────────────────┐                 │    │
│  │  │   Public Subnets    │    │   Private Subnets   │                 │    │
│  │  │  (NAT Gateway)      │    │  (Application)      │                 │    │
│  │  └─────────────────────┘    └─────────────────────┘                 │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## GitFlow Branch → Environment Mapping

| Branch       | Environment | Domain              | Purpose            |
|--------------|-------------|---------------------|--------------------|
| `develop`    | **dev**     | dev.example.com     | Development        |
| `release/*`  | **uat**     | uat.example.com     | User Acceptance    |
| `main`       | **prod**    | example.com         | Production         |

## Directory Structure

```
infra/terraform/
├── main.tf                     # Main configuration & provider
├── variables.tf                # Variable definitions
├── outputs.tf                  # Output definitions
├── modules.tf                  # Module declarations
│
├── modules/                    # Terraform modules
│   ├── vpc/                    # VPC, subnets, routing
│   ├── route53/                # DNS & hosted zones
│   ├── acm/                    # SSL certificates
│   ├── s3/                     # S3 static hosting
│   └── cloudfront/             # CDN distribution
│
├── environments/               # Environment configurations
│   ├── dev/
│   │   ├── terraform.tfvars    # Dev variables
│   │   └── backend.hcl         # Dev state backend
│   ├── uat/
│   │   ├── terraform.tfvars    # UAT variables
│   │   └── backend.hcl         # UAT state backend
│   └── prod/
│       ├── terraform.tfvars    # Prod variables
│       └── backend.hcl         # Prod state backend
│
└── scripts/
    └── bootstrap.sh            # State infrastructure setup
```

## Prerequisites

1. **AWS CLI** configured with appropriate credentials
2. **Terraform** >= 1.0.0
3. **AWS Account** with necessary permissions
4. **Domain** registered and available for use

## Quick Start

### 1. Bootstrap State Infrastructure

First, create the S3 buckets and DynamoDB tables for Terraform state:

```bash
cd infra/terraform/scripts
chmod +x bootstrap.sh
./bootstrap.sh
```

### 2. Update Backend Configuration

Update `environments/*/backend.hcl` files with the bucket names output from the bootstrap script.

### 3. Update Environment Variables

Update `environments/*/terraform.tfvars` files with your:
- Domain name
- Hosted zone ID (or set `create_hosted_zone = true`)
- Other environment-specific settings

### 4. Initialize and Apply

```bash
# For dev environment
cd infra/terraform
terraform init -backend-config="environments/dev/backend.hcl"
terraform plan -var-file="environments/dev/terraform.tfvars"
terraform apply -var-file="environments/dev/terraform.tfvars"

# For uat environment
terraform init -backend-config="environments/uat/backend.hcl" -reconfigure
terraform plan -var-file="environments/uat/terraform.tfvars"
terraform apply -var-file="environments/uat/terraform.tfvars"

# For prod environment
terraform init -backend-config="environments/prod/backend.hcl" -reconfigure
terraform plan -var-file="environments/prod/terraform.tfvars"
terraform apply -var-file="environments/prod/terraform.tfvars"
```

## CI/CD Pipeline

The GitHub Actions workflows handle automatic deployments:

### Terraform Workflow (`.github/workflows/terraform.yml`)

- **Triggers**: Push to `main`, `develop`, or `release/*` branches
- **Actions**:
  - Validates Terraform code
  - Runs `terraform plan`
  - Applies changes on push (not PRs)

### Deploy Workflow (`.github/workflows/deploy.yml`)

- **Triggers**: Push to `main`, `develop`, or `release/*` branches
- **Actions**:
  - Builds frontend application
  - Syncs to S3
  - Invalidates CloudFront cache

### Required GitHub Secrets

Configure these secrets in your GitHub repository:

| Secret                  | Description                    |
|-------------------------|--------------------------------|
| `AWS_ACCESS_KEY_ID`     | AWS access key                 |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key                 |

### GitHub Environments

Create these environments in GitHub Settings → Environments:

1. **dev** - Development environment
2. **uat** - User Acceptance Testing
3. **prod** - Production (consider adding protection rules)

## Modules

### VPC Module

Creates a VPC with:
- Public and private subnets across multiple AZs
- Internet Gateway
- NAT Gateway
- Route tables

### Route 53 Module

Manages DNS:
- Hosted zone (optional creation)
- A and AAAA records for CloudFront
- WWW subdomain for production

### ACM Module

SSL/TLS certificates:
- Creates ACM certificate
- DNS validation via Route 53
- Wildcard certificate for subdomains

### S3 Module

Static hosting:
- S3 bucket for website files
- Bucket versioning and encryption
- CloudFront OAI access policy
- CORS configuration

### CloudFront Module

CDN distribution:
- Origin Access Identity
- Custom domain aliases
- SSL/TLS configuration
- SPA error handling
- Cache behaviors

## Environment Configuration

### Dev (`develop` branch)

- Minimal resources (2 AZs)
- Lower CloudFront price class
- Development-optimized settings

### UAT (`release/*` branches)

- Production-like setup (3 AZs)
- Testing environment
- Staging domain

### Prod (`main` branch)

- Full production setup (3 AZs)
- All CloudFront edge locations
- Production domain

## Destroying Infrastructure

Use the destroy workflow in GitHub Actions or run locally:

```bash
terraform destroy -var-file="environments/<env>/terraform.tfvars"
```

## Cost Considerations

- **NAT Gateway**: ~$32/month per AZ
- **CloudFront**: Based on data transfer
- **Route 53**: $0.50/month per hosted zone
- **S3**: Minimal for static hosting

Consider using VPC endpoints or removing NAT Gateway for development environments to reduce costs.

## Security

- All S3 buckets have public access blocked
- CloudFront uses OAI for S3 access
- HTTPS enforced via ACM certificates
- TLS 1.2 minimum protocol

## Troubleshooting

### Certificate Validation Timeout

ACM certificates require DNS validation. Ensure:
1. Hosted zone ID is correct
2. Domain nameservers point to Route 53

### CloudFront Deployment Slow

CloudFront distributions can take 15-30 minutes to deploy. Check the status:

```bash
aws cloudfront get-distribution --id <distribution-id> --query 'Distribution.Status'
```

### State Lock Issues

If terraform state is locked:

```bash
terraform force-unlock <lock-id>
```
