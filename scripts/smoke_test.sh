#!/bin/bash
# Smoke test script for Terraform infrastructure
# Runs terraform init and plan for all environments and modules

set -e

ROOT_DIR="$(dirname "$0")"

# Test root
cd "$ROOT_DIR"
echo "Testing root Terraform..."
terraform init -backend=false
terraform validate
terraform plan -detailed-exitcode -out=plan.out || true

# Test environments
envs=(environments/dev environments/uat environments/prod)
for env in "${envs[@]}"; do
  if [ -d "$env" ]; then
    echo "\nTesting $env..."
    cd "$ROOT_DIR/$env"
    terraform init -backend=false
    terraform validate
    terraform plan -detailed-exitcode -out=plan.out || true
    cd "$ROOT_DIR"
  fi
done

# Test modules
for module in modules/*/; do
  if [ -d "$module" ]; then
    echo "\nTesting $module..."
    cd "$ROOT_DIR/$module"
    terraform init -backend=false
    terraform validate
    terraform plan -detailed-exitcode -out=plan.out || true
    cd "$ROOT_DIR"
  fi
done

echo "\nAll smoke tests completed."
