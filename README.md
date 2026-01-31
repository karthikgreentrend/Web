# HCL Hackathon Web Application

A full-stack web application with infrastructure as code, following GitFlow deployment strategy.

## Repository Structure

```
repo/
├── app/                          # Application code
│   ├── frontend/                 # React/Web UI
│   ├── backend/                  # REST API (Symfony/Node.js)
│   ├── worker/                   # Async processing (optional)
│   ├── simulator/                # Mock data generator (recommended)
│   └── scripts/                  # Smoke tests & game-day scripts
│
├── infra/                        # Infrastructure as Code
│   └── terraform/
│       ├── backend/              # S3 + DynamoDB remote state bootstrap
│       ├── modules/              # Reusable Terraform modules
│       │   ├── acm/              # SSL Certificates
│       │   ├── cloudfront/       # CDN Distribution
│       │   ├── ecr/              # Container Registry
│       │   ├── ecs/              # Container Orchestration
│       │   ├── route53/          # DNS Management
│       │   ├── s3/               # Static Hosting
│       │   ├── s3-artifacts/     # Security Reports Storage
│       │   └── vpc/              # Network Infrastructure
│       └── envs/                 # Environment configurations
│           ├── dev/              # Development environment
│           ├── uat/              # UAT/Staging environment
│           └── prod/             # Production environment
│
└── .github/workflows/            # CI/CD Pipeline definitions
    ├── ci-cd-pipeline.yml        # Main CI/CD pipeline
    ├── ci-cd-pipeline-part2.yml  # ECR, Terraform, ECS stages
    ├── ci-cd-pipeline-part3.yml  # Security scans & reports
    ├── deploy.yml                # Application deployment
    ├── terraform.yml             # Infrastructure deployment
    ├── terraform-destroy.yml     # Infrastructure teardown
    └── upload-artifacts.yml      # Artifact management
```

## GitFlow Branching Strategy

| Branch | Environment | Auto-Deploy |
|--------|-------------|-------------|
| `main` | Production | ✅ On merge |
| `develop` | Development | ✅ On push |
| `release/*` | UAT/Staging | ✅ On push |

## Quick Start

### Prerequisites

- Node.js 20+
- Docker
- AWS CLI configured
- Terraform 1.6+

### Local Development

```bash
# Frontend
cd app/frontend
npm install
npm run dev

# Backend
cd app/backend
npm install
npm run dev
```

### Infrastructure Setup

1. **Bootstrap Remote State:**
   ```bash
   cd infra/terraform/backend
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   terraform init
   terraform apply
   ```

2. **Deploy Infrastructure:**
   ```bash
   cd infra/terraform
   terraform init -backend-config="envs/dev/backend.hcl"
   terraform plan -var-file="envs/dev/terraform.tfvars"
   terraform apply -var-file="envs/dev/terraform.tfvars"
   ```

### Running Tests

```bash
# Smoke tests
cd app/scripts
./smoke-tests.sh

# Game day scenarios
./game-day.sh
```

## CI/CD Pipeline Stages

1. **Checkout** - Clone repository
2. **Build** - Build frontend and backend
3. **SonarCloud** - Code quality analysis
4. **Docker Build** - Container image creation
5. **Trivy Scan** - Container vulnerability scanning
6. **ECR Push** - Push images to AWS ECR
7. **Terraform Fmt** - Format validation
8. **TFLint** - Terraform linting
9. **Terraform Deploy** - Infrastructure provisioning
10. **ECS Deploy** - Container deployment
11. **OWASP ZAP** - Dynamic security testing
12. **Lighthouse** - Performance audit
13. **S3 Reports** - Upload security reports
14. **Smoke Tests** - Health verification

## Security

- All secrets managed via GitHub Secrets
- Container images scanned for vulnerabilities
- Infrastructure follows AWS security best practices
- SSL/TLS certificates via AWS ACM
- Private S3 buckets with CloudFront OAI

## Contributing

1. Create feature branch from `develop`
2. Make changes and commit
3. Open PR to `develop`
4. After review, merge to `develop`
5. Create `release/*` branch for UAT testing
6. Merge to `main` for production deployment

## License

Proprietary - All rights reserved.
