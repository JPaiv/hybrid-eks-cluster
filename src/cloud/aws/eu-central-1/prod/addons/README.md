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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.10.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 2.1.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ../../../modules/addons/alb | n/a |
| <a name="module_alloy"></a> [alloy](#module\_alloy) | ../../../modules/addons/alloy | n/a |
| <a name="module_argo_cd"></a> [argo\_cd](#module\_argo\_cd) | ../../../modules/addons/argo-cd | n/a |
| <a name="module_authentik"></a> [authentik](#module\_authentik) | ../../../modules/addons/authentik | n/a |
| <a name="module_cilium"></a> [cilium](#module\_cilium) | ../../../modules/addons/cilium | n/a |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | ../../../modules/addons/external-dns | n/a |
| <a name="module_external_secrets"></a> [external\_secrets](#module\_external\_secrets) | ../../../modules/addons/external-secrets | n/a |
| <a name="module_gl_runner_axp"></a> [gl\_runner\_axp](#module\_gl\_runner\_axp) | ../../../modules/addons/gitlab-runner | n/a |
| <a name="module_gl_runner_dev_sec_ops"></a> [gl\_runner\_dev\_sec\_ops](#module\_gl\_runner\_dev\_sec\_ops) | ../../../modules/addons/gitlab-runner | n/a |
| <a name="module_id_label"></a> [id\_label](#module\_id\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | ../../../modules/addons/karpenter | n/a |
| <a name="module_kube_prometheus_stack"></a> [kube\_prometheus\_stack](#module\_kube\_prometheus\_stack) | ../../../modules/addons/kube-prometheus-stack | n/a |
| <a name="module_loki"></a> [loki](#module\_loki) | ../../../modules/addons/loki | n/a |
| <a name="module_vault_argo_cd_admin"></a> [vault\_argo\_cd\_admin](#module\_vault\_argo\_cd\_admin) | ../../../modules/secret | n/a |
| <a name="module_vault_authentik_skey"></a> [vault\_authentik\_skey](#module\_vault\_authentik\_skey) | ../../../modules/secret | n/a |
| <a name="module_vault_gl_axp"></a> [vault\_gl\_axp](#module\_vault\_gl\_axp) | ../../../modules/secret | n/a |
| <a name="module_vault_gl_dev_sec_ops"></a> [vault\_gl\_dev\_sec\_ops](#module\_vault\_gl\_dev\_sec\_ops) | ../../../modules/secret | n/a |
| <a name="module_vault_grafana"></a> [vault\_grafana](#module\_vault\_grafana) | ../../../modules/secret | n/a |

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.namespace_auth](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.namespace_ci_cd](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.namespace_monitoring](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->