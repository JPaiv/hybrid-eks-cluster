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
  account_id   = local.account_vars.locals.aws_account_id
  account_name = local.account_vars.locals.account_name
  aws_region   = local.region_vars.locals.aws_region
  aws_region_short = local.region_vars.locals.aws_region_short
  environment = local.environment_vars.locals.environment
  state_bucket = "nes-${local.aws_region_short}-${local.environment}-tf-state"
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
      "Description"           = "Missing"
      "Name"                  = "Missing"
      "DevOps:CI/CD"          = "False/Local"
      "DevOps:Cronjob"        = "False"
      "DevOps:LockID"         = "${local.state_bucket}-LockID"
      "DevOps:ManagedBy"      = "OpenTofu/Terragrunt"
      "DevOps:Region"         = "${local.aws_region_short}"
      "DevOps:Stage"          = "${local.environment}"
      "DevOps:StateBucket"    = "${local.state_bucket}"
      "DevOps:StateBucketKey" = "${path_relative_to_include()}/tf.tfstate"
      "DevOps:Terratest"      = "False"
      "DevOps:UpdateDatetime" = "${timestamp()}"
    }
  }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    bucket         = "${local.state_bucket}"
    dynamodb_table = "${local.state_bucket}-LockID"
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

# Generate shared unique ID label
generate "id_label" {
  path      = "id-label.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
module "id_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace      = "nes"
  environment    = "${local.aws_region_short}"
  stage          = "${local.environment}"
  name           = "${basename(get_terragrunt_dir())}"
  delimiter      = "-"

  label_order = ["namespace", "environment", "stage", "name"]
}
EOF
}
