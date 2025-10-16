# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform/OpenTofu that provides extra tools for working with multiple modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.aws_account_id
  aws_region   = local.region_vars.locals.aws_region
  aws_region_short = local.region_vars.locals.aws_region_short
  environment = local.environment_vars.locals.environment
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
  default_tags {
  tags = {
      "Description"                  = "Placeholder"
      "Name"                         = "Placeholder"
      "DevOps:DevOps:CI/CD"          = "false/Local"
      "DevOps:DevOps:Cronjob"        = "false"
      "DevOps:DevOps:Email"          = ""
      "DevOps:DevOps:LockID"         = "${local.account_name}-${local.aws_region}-${local.environment}-tf-state-LockID"
      "DevOps:DevOps:ManagedBy"      = "OpenTofu/Terragrunt"
      "DevOps:DevOps:Region"         = "${local.account_name}-${local.aws_region}"
      "DevOps:DevOps:Stage"          = "${local.environment}"
      "DevOps:DevOps:StateBucket"    = "${local.account_name}-${local.aws_region}-${local.environment}-tf-state"
      "DevOps:DevOps:StateBucketKey" = "${path_relative_to_include()}/tf.tfstate"
      "DevOps:DevOps:Terratest"      = "false"
      "DevOps:DevOps:UpdateDatetime" = "${timestamp()}"
      "DevOps:Development:Repo"      = "Placeholder"
    }
  }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    bucket         = "${local.account_name}-${local.aws_region}-${local.environment}-tf-state"
    dynamodb_table = "${local.account_name}-${local.aws_region}-${local.environment}-tf-state-LockID"
    encrypt        = true
    key            = "${path_relative_to_include()}/tf.tfstate"
    region         = local.aws_region
  }
  generate = {
    path      = "state.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)

generate "id_label" {
  path      = "id-label.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
module "id_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace      = "${local.account_name}"
  environment    = "${local.aws_region_short}"
  stage          = "${local.environment}"
  name           = "${basename(get_terragrunt_dir())}"
  delimiter      = "-"

  label_order = ["namespace", "environment", "stage", "name"]
}
EOF
}
