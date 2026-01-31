# Run tflint on all Terraform modules and environments
for dir in Web/infra/terraform Web/infra/terraform/environments/* Web/infra/terraform/modules/*; do
  if [ -d "$dir" ]; then
    echo "Running tflint in $dir"
    tflint "$dir" || true
  fi
done
