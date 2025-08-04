// -- AWS IAM OIDC Provider for gitlab.com
module "oidc_gitlab" {
  source = "../../../modules/gitlab/oidc"

  // -- Naming
  id_label = module.id_label.id
}

// -- GitLab Project dev-sec-ops CI Role
module "dev_sec_ops_ci_role" {
  source = "../../../modules/gitlab/ci-role"

  // -- Naming
  id_label = module.id_label.id
  project  = "dev-sec-ops"

  // -- GitLab OIDC Provider
  oidc_provider_arn = module.oidc_gitlab.oidc_provider_arn
  oidc_provider_url = module.oidc_gitlab.oidc_provider_url

  actions = [
    "access-analyzer:*",
    "acm:*",
    "cloudtrail:*",
    "dynamodb:*",
    "ec2:*",
    "ecr:*",
    "ecs:*",
    "eks:*",
    "elasticache:*",
    "events:*",
    "iam:*",
    "kms:*",
    "lambda:*",
    "logs:*",
    "rds-db:*",
    "rds:*",
    "route53:*",
    "s3:*",
    "secretsmanager:*",
    "sqs:*",
    "ssm:*",
    "sts:*",
  ]

  resources = [
    "*"
  ]
}

// -- GitLab Project axp CI Role
module "axp_ci_role" {
  source = "../../../modules/gitlab/ci-role"

  // -- Naming
  id_label = module.id_label.id
  project  = "axp"

  // -- GitLab OIDC Provider
  oidc_provider_arn = module.oidc_gitlab.oidc_provider_arn
  oidc_provider_url = module.oidc_gitlab.oidc_provider_url

  actions = [
    "ecr:*",
    "iam:*",
    "sts:*",
  ]

  resources = [
    "*",
  ]
}
