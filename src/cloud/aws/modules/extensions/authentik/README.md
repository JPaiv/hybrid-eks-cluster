<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.90.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 3.0.0-pre2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.90.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.0-pre2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.authentik](https://registry.terraform.io/providers/hashicorp/helm/3.0.0-pre2/docs/resources/release) | resource |
| [aws_secretsmanager_secret.rds_pass](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.redis_pass](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.skey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.rds_pass](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.redis_pass](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.skey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_ssm_parameter.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Ref: https://artifacthub.io/packages/helm/goauthentik/authentik | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Helm chart installation namespace; must exists priot to install! | `string` | `"auth"` | no |
| <a name="input_rds_pass_secr_name"></a> [rds\_pass\_secr\_name](#input\_rds\_pass\_secr\_name) | AWS RDS Postgress instance password | `string` | n/a | yes |
| <a name="input_rds_ssm_param_name"></a> [rds\_ssm\_param\_name](#input\_rds\_ssm\_param\_name) | AWS Parameter Store parameter with RDS module outputs | `string` | n/a | yes |
| <a name="input_redis_pass_secr_name"></a> [redis\_pass\_secr\_name](#input\_redis\_pass\_secr\_name) | AWS Secrets Manager secret name | `string` | n/a | yes |
| <a name="input_redis_ssm_param_name"></a> [redis\_ssm\_param\_name](#input\_redis\_ssm\_param\_name) | Redis cache configs SSM Parameter store name | `string` | n/a | yes |
| <a name="input_skey_secr_name"></a> [skey\_secr\_name](#input\_skey\_secr\_name) | AWS Secrets Manager secret with the Secret Key for signing token and IDs | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->