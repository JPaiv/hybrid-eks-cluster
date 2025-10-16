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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_iam_policy_document.permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.trust_relationships](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | The version of the AWS Load Balancer Controller Helm chart (see: https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller). | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The name of the EKS cluster. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace where the AWS Load Balancer Controller will be deployed. Defaults to kube-system. | `string` | `"kube-system"` | no |
| <a name="input_oidc_identity_issuer_url"></a> [oidc\_identity\_issuer\_url](#input\_oidc\_identity\_issuer\_url) | The issuer URL of the EKS cluster's OIDC identity provider. | `string` | n/a | yes |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | The ARN of the EKS cluster's OIDC provider. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC associated with the EKS cluster. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->