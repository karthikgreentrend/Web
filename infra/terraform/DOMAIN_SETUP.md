# 🌐 Domain Setup Guide: karthik.uk

This guide explains how to set up your domain for all three environments.

## Architecture Overview

```
                    ┌─────────────────────────────────────────────────────────┐
                    │                   karthik.uk Domain                     │
                    └─────────────────────────────────────────────────────────┘
                                              │
                    ┌─────────────────────────┼─────────────────────────┐
                    │                         │                         │
                    ▼                         ▼                         ▼
        ┌───────────────────┐    ┌───────────────────┐    ┌───────────────────┐
        │  dev.karthik.uk   │    │  uat.karthik.uk   │    │  prod.karthik.uk  │
        │      (DEV)        │    │      (UAT)        │    │  karthik.uk       │
        └─────────┬─────────┘    └─────────┬─────────┘    └─────────┬─────────┘
                  │                        │                        │
                  ▼                        ▼                        ▼
        ┌───────────────────┐    ┌───────────────────┐    ┌───────────────────┐
        │    CloudFront     │    │    CloudFront     │    │    CloudFront     │
        │   (CDN + SSL)     │    │   (CDN + SSL)     │    │   (CDN + SSL)     │
        └─────────┬─────────┘    └─────────┬─────────┘    └─────────┬─────────┘
                  │                        │                        │
                  ▼                        ▼                        ▼
        ┌───────────────────┐    ┌───────────────────┐    ┌───────────────────┐
        │  S3 + ALB (ECS)   │    │  S3 + ALB (ECS)   │    │  S3 + ALB (ECS)   │
        │      (DEV)        │    │      (UAT)        │    │     (PROD)        │
        └───────────────────┘    └───────────────────┘    └───────────────────┘
```

## Prerequisites

1. **Own the domain**: You must own `karthik.uk`
2. **Domain registrar access**: To update NS records
3. **AWS Account**: With appropriate permissions

## Step-by-Step Setup

### Step 1: Deploy DEV Environment First

This creates the Route53 hosted zone and ACM certificate:

```bash
cd infra/terraform
terraform init -backend-config="envs/dev/backend.hcl"
terraform plan -var-file="envs/dev/terraform.tfvars"
terraform apply -var-file="envs/dev/terraform.tfvars"
```

### Step 2: Get Route53 Name Servers

After DEV deployment, get the name servers:

```bash
terraform output route53_name_servers
```

This will output something like:
```
[
  "ns-123.awsdns-45.com",
  "ns-456.awsdns-78.co.uk",
  "ns-789.awsdns-01.net",
  "ns-012.awsdns-23.org"
]
```

### Step 3: Update Your Domain Registrar

Go to your domain registrar (e.g., GoDaddy, Namecheap, UK2) and update the nameservers:

| Nameserver | Value |
|------------|-------|
| NS1 | ns-123.awsdns-45.com |
| NS2 | ns-456.awsdns-78.co.uk |
| NS3 | ns-789.awsdns-01.net |
| NS4 | ns-012.awsdns-23.org |

**⚠️ Important**: DNS propagation can take up to 48 hours!

### Step 4: Get Hosted Zone ID for Other Environments

```bash
terraform output route53_hosted_zone_id
```

Copy this value (e.g., `Z1234567890ABC`) and update:
- `envs/uat/terraform.tfvars` → `hosted_zone_id = "Z1234567890ABC"`
- `envs/prod/terraform.tfvars` → `hosted_zone_id = "Z1234567890ABC"`

### Step 5: Deploy UAT Environment

```bash
terraform init -backend-config="envs/uat/backend.hcl"
terraform plan -var-file="envs/uat/terraform.tfvars"
terraform apply -var-file="envs/uat/terraform.tfvars"
```

### Step 6: Deploy PROD Environment

```bash
terraform init -backend-config="envs/prod/backend.hcl"
terraform plan -var-file="envs/prod/terraform.tfvars"
terraform apply -var-file="envs/prod/terraform.tfvars"
```

## Expected URLs After Deployment

| Environment | URL | Status |
|-------------|-----|--------|
| DEV | https://dev.karthik.uk | ✅ |
| UAT | https://uat.karthik.uk | ✅ |
| PROD | https://karthik.uk | ✅ |
| PROD | https://www.karthik.uk | ✅ |
| PROD | https://prod.karthik.uk | ✅ |

## AWS Resources Created

### For Each Environment:

| Resource | Purpose |
|----------|---------|
| **Route53 Hosted Zone** | DNS management for karthik.uk |
| **ACM Certificate** | SSL/TLS for *.karthik.uk |
| **CloudFront Distribution** | CDN + HTTPS termination |
| **S3 Bucket** | Static file hosting |
| **ALB (Application Load Balancer)** | ECS service load balancing |
| **ECS Cluster + Services** | Container orchestration |

### DNS Records Created:

| Type | Name | Target |
|------|------|--------|
| A | dev.karthik.uk | CloudFront (Alias) |
| AAAA | dev.karthik.uk | CloudFront (Alias) |
| A | uat.karthik.uk | CloudFront (Alias) |
| AAAA | uat.karthik.uk | CloudFront (Alias) |
| A | karthik.uk | CloudFront (Alias) |
| A | www.karthik.uk | CloudFront (Alias) |
| CNAME | _xxxxx.karthik.uk | ACM validation |

## Verify SSL Certificate

After deployment, verify your certificate:

```bash
# Check certificate status
aws acm list-certificates --region us-east-1

# Describe specific certificate
aws acm describe-certificate --certificate-arn <arn>
```

## Troubleshooting

### DNS Not Resolving

1. Check NS records at registrar match Route53
2. Wait for DNS propagation (use https://dnschecker.org)
3. Verify Route53 hosted zone has correct records

### Certificate Not Validating

1. Ensure Route53 hosted zone is authoritative
2. Check CNAME validation records exist
3. Certificate must be in `us-east-1` for CloudFront

### CloudFront 403 Error

1. Check S3 bucket policy allows CloudFront OAI
2. Verify origin access identity is configured
3. Check default root object is set

### Health Check Failing

1. Verify ECS tasks are running
2. Check security group allows ALB traffic
3. Verify health check path responds with 200

## Quick Commands

```bash
# Check Route53 records
aws route53 list-resource-record-sets --hosted-zone-id <zone-id>

# Test DNS resolution
dig dev.karthik.uk
nslookup uat.karthik.uk

# Test HTTPS
curl -I https://dev.karthik.uk
curl -I https://uat.karthik.uk
curl -I https://prod.karthik.uk

# Check CloudFront status
aws cloudfront list-distributions --query "DistributionList.Items[*].[Id,DomainName,Aliases.Items[0]]"
```

## Cost Estimate

| Resource | Cost (approx/month) |
|----------|---------------------|
| Route53 Hosted Zone | $0.50 |
| ACM Certificate | FREE |
| CloudFront (per env) | $5-50 (usage based) |
| ALB (per env) | $20-30 |
| ECS Fargate (per env) | $30-100 |
| S3 | $1-5 |

**Total per environment**: ~$60-200/month depending on traffic

## Security Best Practices

- ✅ HTTPS enforced (redirect HTTP → HTTPS)
- ✅ TLS 1.2+ required
- ✅ CloudFront WAF (optional)
- ✅ S3 private with OAI
- ✅ Security groups restrict access
