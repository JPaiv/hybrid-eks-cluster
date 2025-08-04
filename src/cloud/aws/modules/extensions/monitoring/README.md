<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.90.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 3.0.0-pre2 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 2.1.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.90.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.0-pre2 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | ~> 2.1.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.kube_prometheus_stack](https://registry.terraform.io/providers/hashicorp/helm/3.0.0-pre2/docs/resources/release) | resource |
| [kubectl_manifest.storage_class](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_pass_secr_name"></a> [admin\_pass\_secr\_name](#input\_admin\_pass\_secr\_name) | Grafana admin user password AWS Secrets Manager secret name | `string` | n/a | yes |
| <a name="input_chart_vers"></a> [chart\_vers](#input\_chart\_vers) | Helm chart version; ref: https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | EKS Cluster id/name; same as the id\_label | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | `"monitoring"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->