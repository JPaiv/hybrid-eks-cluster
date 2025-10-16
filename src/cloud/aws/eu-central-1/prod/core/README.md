<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | ../../../modules/acm | n/a |
| <a name="module_axp"></a> [axp](#module\_axp) | ../../../modules/ecr | n/a |
| <a name="module_cache_shared"></a> [cache\_shared](#module\_cache\_shared) | ../../../modules/elasticache | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ../../../modules/eks | n/a |
| <a name="module_gitlab_iam_axp"></a> [gitlab\_iam\_axp](#module\_gitlab\_iam\_axp) | ../../../modules/gitlab/iam | n/a |
| <a name="module_gitlab_iam_dev_sec_ops"></a> [gitlab\_iam\_dev\_sec\_ops](#module\_gitlab\_iam\_dev\_sec\_ops) | ../../../modules/gitlab/iam | n/a |
| <a name="module_gitlab_oidc"></a> [gitlab\_oidc](#module\_gitlab\_oidc) | ../../../modules/gitlab/oidc | n/a |
| <a name="module_id_label"></a> [id\_label](#module\_id\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_rds_authentik"></a> [rds\_authentik](#module\_rds\_authentik) | ../../../modules/rds | n/a |
| <a name="module_vault_cache_shared"></a> [vault\_cache\_shared](#module\_vault\_cache\_shared) | ../../../modules/secret | n/a |
| <a name="module_vault_rds_authentik"></a> [vault\_rds\_authentik](#module\_vault\_rds\_authentik) | ../../../modules/secret | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../../modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->