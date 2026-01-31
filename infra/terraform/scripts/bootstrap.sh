#!/bin/bash
# =============================================================================
# Terraform State Bootstrap Script
# Creates S3 bucket and DynamoDB table for remote state management
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="${PROJECT_NAME:-web-app}"
AWS_REGION="${AWS_REGION:-us-east-1}"
ENVIRONMENTS=("dev" "uat" "prod")

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Terraform State Infrastructure Bootstrap${NC}"
echo -e "${GREEN}========================================${NC}"

# Check AWS CLI
if ! command -v aws &> /dev/null; then
    echo -e "${RED}Error: AWS CLI is not installed${NC}"
    exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}Error: AWS credentials not configured${NC}"
    exit 1
fi

echo -e "${YELLOW}AWS Account: $(aws sts get-caller-identity --query 'Account' --output text)${NC}"
echo -e "${YELLOW}AWS Region: ${AWS_REGION}${NC}"
echo ""

# Create resources for each environment
for ENV in "${ENVIRONMENTS[@]}"; do
    echo -e "${GREEN}Setting up ${ENV} environment...${NC}"

    BUCKET_NAME="terraform-state-${PROJECT_NAME}-${ENV}-$(aws sts get-caller-identity --query 'Account' --output text)"
    DYNAMODB_TABLE="terraform-state-locks-${ENV}"

    # Create S3 bucket
    echo "  Creating S3 bucket: ${BUCKET_NAME}"
    if aws s3api head-bucket --bucket "${BUCKET_NAME}" 2>/dev/null; then
        echo -e "  ${YELLOW}Bucket already exists${NC}"
    else
        aws s3api create-bucket \
            --bucket "${BUCKET_NAME}" \
            --region "${AWS_REGION}" \
            $(if [ "${AWS_REGION}" != "us-east-1" ]; then echo "--create-bucket-configuration LocationConstraint=${AWS_REGION}"; fi)

        # Enable versioning
        aws s3api put-bucket-versioning \
            --bucket "${BUCKET_NAME}" \
            --versioning-configuration Status=Enabled

        # Enable encryption
        aws s3api put-bucket-encryption \
            --bucket "${BUCKET_NAME}" \
            --server-side-encryption-configuration '{
                "Rules": [{
                    "ApplyServerSideEncryptionByDefault": {
                        "SSEAlgorithm": "AES256"
                    }
                }]
            }'

        # Block public access
        aws s3api put-public-access-block \
            --bucket "${BUCKET_NAME}" \
            --public-access-block-configuration '{
                "BlockPublicAcls": true,
                "IgnorePublicAcls": true,
                "BlockPublicPolicy": true,
                "RestrictPublicBuckets": true
            }'

        echo -e "  ${GREEN}✓ Bucket created${NC}"
    fi

    # Create DynamoDB table for state locking
    echo "  Creating DynamoDB table: ${DYNAMODB_TABLE}"
    if aws dynamodb describe-table --table-name "${DYNAMODB_TABLE}" 2>/dev/null; then
        echo -e "  ${YELLOW}Table already exists${NC}"
    else
        aws dynamodb create-table \
            --table-name "${DYNAMODB_TABLE}" \
            --attribute-definitions AttributeName=LockID,AttributeType=S \
            --key-schema AttributeName=LockID,KeyType=HASH \
            --billing-mode PAY_PER_REQUEST \
            --region "${AWS_REGION}"

        echo -e "  ${GREEN}✓ Table created${NC}"
    fi

    echo ""
done

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Bootstrap Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Update your backend.hcl files with the following bucket names:"
echo ""
for ENV in "${ENVIRONMENTS[@]}"; do
    BUCKET_NAME="terraform-state-${PROJECT_NAME}-${ENV}-$(aws sts get-caller-identity --query 'Account' --output text)"
    DYNAMODB_TABLE="terraform-state-locks-${ENV}"
    echo "${ENV}:"
    echo "  bucket         = \"${BUCKET_NAME}\""
    echo "  dynamodb_table = \"${DYNAMODB_TABLE}\""
    echo ""
done
