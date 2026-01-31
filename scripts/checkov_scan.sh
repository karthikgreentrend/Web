# Run Checkov on all Terraform code
checkov -d Web/infra/terraform --quiet --compact || true
