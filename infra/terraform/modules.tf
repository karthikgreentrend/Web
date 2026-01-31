# =============================================================================
# Module Declarations
# =============================================================================

# -----------------------------------------------------------------------------
# VPC Module
# -----------------------------------------------------------------------------

module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# Route 53 Module (Hosted Zone only - no CloudFront dependency)
# -----------------------------------------------------------------------------

module "route53" {
  source = "./modules/route53"

  project_name       = var.project_name
  environment        = var.environment
  domain_name        = var.domain_name
  create_hosted_zone = var.create_hosted_zone
  hosted_zone_id     = var.hosted_zone_id

  # CloudFront alias target will be set to null initially
  # DNS records will be created by a separate resource after CloudFront is ready
  cloudfront_domain_name    = null
  cloudfront_hosted_zone_id = null

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# ACM Certificate Module
# -----------------------------------------------------------------------------

module "acm" {
  source = "./modules/acm"

  project_name       = var.project_name
  environment        = var.environment
  domain_name        = var.domain_name
  create_certificate = var.create_certificate
  certificate_arn    = var.certificate_arn
  hosted_zone_id     = module.route53.hosted_zone_id

  tags = local.common_tags

  depends_on = [module.route53]
}

# -----------------------------------------------------------------------------
# S3 Module (for static hosting)
# -----------------------------------------------------------------------------

module "s3" {
  source = "./modules/s3"
  count  = var.enable_s3_hosting ? 1 : 0

  project_name = var.project_name
  environment  = var.environment

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# CloudFront Module
# -----------------------------------------------------------------------------

module "cloudfront" {
  source = "./modules/cloudfront"
  count  = var.enable_cloudfront ? 1 : 0

  project_name    = var.project_name
  environment     = var.environment
  domain_name     = var.domain_name
  certificate_arn = module.acm.certificate_arn
  price_class     = var.cloudfront_price_class

  # S3 origin
  s3_bucket_regional_domain_name = var.enable_s3_hosting ? module.s3[0].bucket_regional_domain_name : null
  s3_bucket_id                   = var.enable_s3_hosting ? module.s3[0].bucket_id : null

  tags = local.common_tags

  depends_on = [module.acm]
}

# -----------------------------------------------------------------------------
# S3 Bucket Policy for CloudFront OAI (applied after both modules are created)
# -----------------------------------------------------------------------------

resource "aws_s3_bucket_policy" "cloudfront_access" {
  count = var.enable_s3_hosting && var.enable_cloudfront ? 1 : 0

  bucket = module.s3[0].bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOAI"
        Effect = "Allow"
        Principal = {
          AWS = module.cloudfront[0].origin_access_identity_arn
        }
        Action   = "s3:GetObject"
        Resource = "${module.s3[0].bucket_arn}/*"
      }
    ]
  })

  depends_on = [module.s3, module.cloudfront]
}

# -----------------------------------------------------------------------------
# ECR Module
# -----------------------------------------------------------------------------

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

# -----------------------------------------------------------------------------
# ECS Module
# -----------------------------------------------------------------------------

module "ecs" {
  source = "./modules/ecs"

  project_name       = var.project_name
  environment        = var.environment
  aws_region         = var.aws_region
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  certificate_arn    = module.acm.certificate_arn
  ecr_frontend_url   = module.ecr.frontend_url
  ecr_backend_url    = module.ecr.backend_url

  frontend_cpu           = var.environment == "prod" ? 512 : 256
  frontend_memory        = var.environment == "prod" ? 1024 : 512
  backend_cpu            = var.environment == "prod" ? 512 : 256
  backend_memory         = var.environment == "prod" ? 1024 : 512
  frontend_desired_count = var.environment == "prod" ? 3 : 1
  backend_desired_count  = var.environment == "prod" ? 3 : 1

  tags = local.common_tags

  depends_on = [module.vpc, module.acm, module.ecr]
}

# -----------------------------------------------------------------------------
# S3 Artifacts Module (Security Reports Storage)
# -----------------------------------------------------------------------------

module "s3_artifacts" {
  source = "./modules/s3-artifacts"

  project_name = var.project_name
  tags         = local.common_tags
}

# -----------------------------------------------------------------------------
# Aurora Module (RDS Aurora Cluster)
# -----------------------------------------------------------------------------

module "aurora" {
  source = "./modules/aurora"

  cluster_identifier      = "${var.project_name}-${var.environment}-aurora"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.04.0"
  master_username         = var.aurora_master_username
  master_password         = var.aurora_master_password
  database_name           = var.aurora_database_name
  vpc_security_group_ids  = [module.vpc.default_db_sg_id]
  db_subnet_group_name    = "${var.project_name}-${var.environment}-aurora-subnet-group"
  subnet_ids              = module.vpc.private_subnet_ids
  instance_count          = 2
  instance_class          = "db.r6g.large"
  publicly_accessible     = false

  depends_on = [module.vpc]
}

# -----------------------------------------------------------------------------
# ElastiCache Module (Redis)
# -----------------------------------------------------------------------------

module "elasticache" {
  source = "./modules/elasticache"

  cluster_id           = "${var.project_name}-${var.environment}-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  subnet_group_name    = "${var.project_name}-${var.environment}-redis-subnet-group"
  subnet_ids           = module.vpc.private_subnet_ids
  security_group_ids   = [module.vpc.default_db_sg_id]

  depends_on = [module.vpc]
}

# -----------------------------------------------------------------------------
# OpenSearch Module
# -----------------------------------------------------------------------------

module "opensearch" {
  source = "./modules/opensearch"

  domain_name        = "${var.project_name}-${var.environment}-os"
  engine_version     = "OpenSearch_2.11"
  instance_type      = "t3.small.search"
  instance_count     = 1
  volume_size        = 10
  volume_type        = "gp3"
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.default_db_sg_id]
  access_policies    = var.opensearch_access_policies

  depends_on = [module.vpc]
}

# -----------------------------------------------------------------------------
# Route53 DNS Records for CloudFront (created after CloudFront is ready)
# -----------------------------------------------------------------------------



resource "aws_route53_record" "cloudfront_alias" {
  count = var.enable_cloudfront ? 1 : 0

  zone_id = module.route53.hosted_zone_id
  name    = local.app_domain
  type    = "A"

  alias {
    name                   = module.cloudfront[0].domain_name
    zone_id                = module.cloudfront[0].hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [module.cloudfront]
}

resource "aws_route53_record" "cloudfront_alias_ipv6" {
  count = var.enable_cloudfront ? 1 : 0

  zone_id = module.route53.hosted_zone_id
  name    = local.app_domain
  type    = "AAAA"

  alias {
    name                   = module.cloudfront[0].domain_name
    zone_id                = module.cloudfront[0].hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [module.cloudfront]
}

resource "aws_route53_record" "cloudfront_www" {
  count = var.environment == "prod" && var.enable_cloudfront ? 1 : 0

  zone_id = module.route53.hosted_zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.cloudfront[0].domain_name
    zone_id                = module.cloudfront[0].hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [module.cloudfront]
}
