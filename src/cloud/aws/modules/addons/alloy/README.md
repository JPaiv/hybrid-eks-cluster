<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.10.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | ref: https://artifacthub.io/packages/helm/grafana/alloy | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | EKS Cluster id/name; same as the id\_label | `string` | n/a | yes |
| <a name="input_loki_lbalancer_url"></a> [loki\_lbalancer\_url](#input\_loki\_lbalancer\_url) | Same namespace as with all the other monitoring components | `string` | `"loki.unikiemarshalling.com"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | `"monitoring"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->