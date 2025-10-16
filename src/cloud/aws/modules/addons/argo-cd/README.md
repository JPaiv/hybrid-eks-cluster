<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.10.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0.2 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 2.1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.10.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0.2 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | ~> 2.1.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.external_secret_admin](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.external_secret_redis](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.secret_store](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.trust_relationships](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_abac_tags"></a> [abac\_tags](#input\_abac\_tags) | Map of attribute-based access control (ABAC) tags to apply, where the key is the tag name and the value is an object of tag details. | <pre>map(object({<br/>    tag_type    = string<br/>    abac_key    = string<br/>    abac_values = list(string)<br/>  }))</pre> | `null` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | ArgoCD Helm chart version, ref: https://artifacthub.io/packages/helm/argo/argo-cd | `string` | `"8.1.3"` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | EKS Cluster ID | `string` | n/a | yes |
| <a name="input_ingress_url"></a> [ingress\_url](#input\_ingress\_url) | Ingress base hostname | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ArgoCD install namespace; should not be kube-system or other k8s necessary namespace | `string` | `"ci-cd"` | no |
| <a name="input_oidc_identity_issuer_url"></a> [oidc\_identity\_issuer\_url](#input\_oidc\_identity\_issuer\_url) | EKS Cluster OIDC Identity issuer url | `string` | n/a | yes |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | EKS Cluster OIDC Provider ARN | `string` | n/a | yes |
| <a name="input_redis_ssm"></a> [redis\_ssm](#input\_redis\_ssm) | Redis cache configs SSM Parameter store name | `string` | n/a | yes |
| <a name="input_vault_admin"></a> [vault\_admin](#input\_vault\_admin) | n/a | `string` | n/a | yes |
| <a name="input_vault_redis"></a> [vault\_redis](#input\_vault\_redis) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->