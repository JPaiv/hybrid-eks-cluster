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
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_random_password.passwords](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_random_password) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_abac_tags"></a> [abac\_tags](#input\_abac\_tags) | Map of attribute-based access control (ABAC) tags to apply, where the key is the tag name and the value is an object of tag details. | `map(string)` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Human-readable description of the secret | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map of secret JSON object keys and values | <pre>map(object(<br/>    {<br/>      name                = string<br/>      password_length     = optional(number)<br/>      exclude_characters  = optional(string)<br/>      exclude_punctuation = optional(bool)<br/>      require_each_type   = optional(bool)<br/>    }<br/>  ))</pre> | <pre>{<br/>  "password": {<br/>    "exclude_characters": null,<br/>    "exclude_punctuation": false,<br/>    "name": "password",<br/>    "password_length": 50,<br/>    "require_each_type": false<br/>  }<br/>}</pre> | no |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | Fully qualified name of the secret | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->