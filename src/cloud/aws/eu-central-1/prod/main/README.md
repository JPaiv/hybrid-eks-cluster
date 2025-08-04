<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.90.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.90.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | ../../../modules/acm | n/a |
| <a name="module_axp_ci_role"></a> [axp\_ci\_role](#module\_axp\_ci\_role) | ../../../modules/gitlab/ci-role | n/a |
| <a name="module_dev_sec_ops_ci_role"></a> [dev\_sec\_ops\_ci\_role](#module\_dev\_sec\_ops\_ci\_role) | ../../../modules/gitlab/ci-role | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ../../../modules/eks | n/a |
| <a name="module_elasticache_argocd"></a> [elasticache\_argocd](#module\_elasticache\_argocd) | ../../../modules/elasticache | n/a |
| <a name="module_id_label"></a> [id\_label](#module\_id\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_komatsu"></a> [komatsu](#module\_komatsu) | ../../../modules/ecr | n/a |
| <a name="module_oidc_gitlab"></a> [oidc\_gitlab](#module\_oidc\_gitlab) | ../../../modules/gitlab/oidc | n/a |
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