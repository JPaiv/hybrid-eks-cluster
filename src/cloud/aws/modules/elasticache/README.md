<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_replication_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_kms_alias.cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.cw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.cw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cache_name"></a> [cache\_name](#input\_cache\_name) | Elasticache cluster name | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Consistent naming label as a unique resource identifier | `string` | n/a | yes |
| <a name="input_elasticache_logs"></a> [elasticache\_logs](#input\_elasticache\_logs) | Elasticache logs and Cloudwatch log group | <pre>map(<br/>    object<br/>    (<br/>      {<br/>        log_group_class   = string<br/>        log_type          = string<br/>        retention_in_days = number<br/>      }<br/>    )<br/>  )</pre> | <pre>{<br/>  "engine": {<br/>    "log_group_class": "STANDARD",<br/>    "log_type": "engine-log",<br/>    "retention_in_days": 90<br/>  },<br/>  "slow": {<br/>    "log_group_class": "STANDARD",<br/>    "log_type": "slow-log",<br/>    "retention_in_days": 90<br/>  }<br/>}</pre> | no |
| <a name="input_port"></a> [port](#input\_port) | Redis port number | `number` | `6379` | no |
| <a name="input_priv_subnet_ids"></a> [priv\_subnet\_ids](#input\_priv\_subnet\_ids) | A list of private subnet IDs where the RDS instance will be deployed. These subnets should be part of the EKS cluster's VPC and configured to prevent public access. | `list(string)` | n/a | yes |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | Cache AWS Secrets Manager name | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC (Virtual Private Cloud) where the RDS instance will be provisioned. This should be the same VPC as your EKS cluster. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->