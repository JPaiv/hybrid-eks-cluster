<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.90.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.90.0 |

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
| [aws_iam_policy_document.cw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cache_name"></a> [cache\_name](#input\_cache\_name) | Elasticache cluster name | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Consistent naming label as a unique resource identifier | `string` | n/a | yes |
| <a name="input_eks_sg_id"></a> [eks\_sg\_id](#input\_eks\_sg\_id) | AWS managed EKS worker node security group ID | `string` | n/a | yes |
| <a name="input_elasticache_logs"></a> [elasticache\_logs](#input\_elasticache\_logs) | Elasticache logs and Cloudwatch log group | <pre>map(<br/>    object<br/>    (<br/>      {<br/>        log_group_class   = string<br/>        log_type          = string<br/>        retention_in_days = number<br/>      }<br/>    )<br/>  )</pre> | <pre>{<br/>  "engine": {<br/>    "log_group_class": "STANDARD",<br/>    "log_type": "engine-log",<br/>    "retention_in_days": 90<br/>  },<br/>  "slow": {<br/>    "log_group_class": "STANDARD",<br/>    "log_type": "slow-log",<br/>    "retention_in_days": 90<br/>  }<br/>}</pre> | no |
| <a name="input_pass_secr_name"></a> [pass\_secr\_name](#input\_pass\_secr\_name) | Redis auth token AWS Secrets Manager secret name | `string` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | Redis port number | `number` | `6379` | no |
| <a name="input_priv_subn_ids"></a> [priv\_subn\_ids](#input\_priv\_subn\_ids) | Private Subnet ID's | `list(string)` | n/a | yes |
| <a name="input_sg_ids"></a> [sg\_ids](#input\_sg\_ids) | Associated VPC security group ID's | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Associated VPC security group ID's | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->