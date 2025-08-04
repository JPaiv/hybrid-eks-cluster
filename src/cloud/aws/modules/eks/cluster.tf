resource "aws_eks_cluster" "this" {
  // -- General
  bootstrap_self_managed_addons = false // -- Automatic add-on bootstrapping prevents Cilium deployment
  name                          = var.id_label
  role_arn                      = aws_iam_role.cluster.arn
  version                       = var.cluster_version

  // -- Logging
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  // -- Authentication
  access_config {
    authentication_mode = "API"
  }

  // -- Secrets
  encryption_config {
    resources = [
      "secrets",
    ]
    provider {
      key_arn = aws_kms_key.cluster.arn
    }
  }

  // -- Hybrid Nodes Config
  remote_network_config {
    remote_node_networks {
      cidrs = [
        "172.16.0.0/18",
      ]
    }
    remote_pod_networks {
      cidrs = [
        "172.16.64.0/18",
      ]
    }
  }

  // -- Networking
  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "10.100.0.0/16"
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = var.security_group_ids
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
    "Description"                               = "UMS Primary K8S Cluster for on-prem deployments"
    "Name"                                      = var.id_label
    "k8s.io/cluster-autoscaler/${var.id_label}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"         = true
    "kubernetes.io/cluster/${var.id_label}"     = "shared"
  }
}
