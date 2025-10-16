# ---------------------------------------------------------------------------------------------------------------------
# MAIN EKS CLUSTER
# Disable addon bootstrapping, so Cilium can function as the CNI without AWS CNI
# Disable ConfigMap authentication
# -> Use only API for increased security
# Cilium needs to be deployed manually after the EKS Cluster is operational but during the Managed Node Group deployment
# Control Plane logs CW Log Group is created with TF before the cluster
# -> We need more control over encryption etc.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_eks_cluster" "this" {
  # General
  bootstrap_self_managed_addons = false # Automatic add-on bootstrapping prevents Cilium deployment
  name                          = var.id_label
  role_arn                      = aws_iam_role.cluster.arn
  version                       = var.cluster_version

  # Logging
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  # Authentication
  access_config {
    authentication_mode = "API"
  }

  # Secrets
  encryption_config {
    resources = [
      "secrets",
    ]
    provider {
      key_arn = aws_kms_key.cluster.arn
    }
  }

  # Networking
  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "10.100.0.0/16"
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = concat(var.private_subnet_ids, var.public_subnet_ids)

    public_access_cidrs = [
      "0.0.0.0/0",
    ]
  }

  zonal_shift_config {
    enabled = true
  }

  depends_on = [
    aws_cloudwatch_log_group.this,
  ]

  tags = {
    "Description"                               = "UMS Primary K8S Cluster"
    "Name"                                      = var.id_label
    "k8s.io/cluster-autoscaler/${var.id_label}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"         = true
    "kubernetes.io/cluster/${var.id_label}"     = "shared"
    "Unikie:DevSecOps:ClusterName"              = var.id_label
  }
}
