# Worker Service for Async Processing

This folder contains the code and configuration for the ECS Fargate worker service.

## Responsibilities
- Async processing
- Indexing
- Enrichment
- Report generation

## Structure
- `src/` - Worker service source code
- `Dockerfile` - Container build for ECS Fargate
- `README.md` - This file

## Getting Started
1. Add your worker logic in `src/` (Node.js, Python, etc.)
2. Build and push the Docker image
3. Deploy to ECS Fargate using Terraform
