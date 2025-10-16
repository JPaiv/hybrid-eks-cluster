# ---------------------------------------------------------------------------------------------------------------------
# EKS CLUSTER MANAGED BOTTLEROCKET NODE GROUP
# Operator instructions: deploy the EKS Cluster without this file.
# -> Cilium needs to be deployed simultaniously, or else the cluster has no CNI
# -> Cilium is in the modules/addons/cilium
# ---------------------------------------------------------------------------------------------------------------------

# Get the latest AWS Bottlerocket OS
data "aws_ami" "bottlerocket" {
  most_recent = true
  owners = [
    "amazon",
  ]

  filter {
    name = "name"
    values = [
      "bottlerocket-aws-k8s-${var.cluster_version}-x86_64-*",
    ]
  }
}

resource "aws_eks_node_group" "this" {
  #General
  ami_type        = "CUSTOM"
  node_group_name = "${aws_eks_cluster.this.name}-critical"
  cluster_name    = aws_eks_cluster.this.name
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids

  labels = {
    role = "core"
  }

  # Prevent pod schedule before the Cilium controller is ready
  taint {
    key    = "node.cilium.io/agent-not-ready"
    value  = "true"
    effect = "NO_EXECUTE"
  }

  # Only mission-critical addons such as Karpenter and Cilium
  taint {
    key    = "CriticalAddonsOnly"
    value  = "true"
    effect = "NO_EXECUTE"
  }

  launch_template {
    name    = "${aws_eks_cluster.this.name}-critical"
    version = aws_launch_template.this.latest_version
  }

  scaling_config {
    desired_size = 2
    max_size     = 10
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    "Description"                                            = "Managed Node Group for the Karpenter and Cilium addon controllers"
    "Name"                                                   = "${aws_eks_cluster.this.name}-critical"
    "k8s.io/cluster-autoscaler/${aws_eks_cluster.this.name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                      = true
    "kubernetes.io/cluster/${aws_eks_cluster.this.name}"     = "owned"
  }
}

# Cilium and Karpenter Controllers EC2 Bottlerocket Instances template
# -> Karpenter handles non-critical workloads
resource "aws_launch_template" "this" {
  disable_api_stop        = false
  disable_api_termination = false
  image_id                = data.aws_ami.bottlerocket.id
  instance_type           = "t3.medium"
  name                    = "${aws_eks_cluster.this.name}-critical"

  user_data = base64encode(<<-EOT
    [settings.kubernetes]
    api-server = "${aws_eks_cluster.this.endpoint}"
    cluster-certificate = "${aws_eks_cluster.this.certificate_authority[0].data}"
    cluster-dns-ip = "10.100.0.10"
    cluster-name = "${aws_eks_cluster.this.name}"

    [settings.host-containers.admin]
    enabled = false

    [settings.host-containers.control]
    enabled = false

    [settings.kernel]
    lockdown = "integrity"

    [settings.network]
    hostname = "${aws_eks_cluster.this.name}"

    [settings.boot]
    reboot-to-reconcile = true
  EOT
  )

  metadata_options {
    instance_metadata_tags = "disabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_size           = 20
      volume_type           = "gp3"
    }
  }

  block_device_mappings {
    device_name = "/dev/xvdb"
    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_size           = 15
      volume_type           = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Description"                                            = "Managed Node Group Bottlerocket EC2 Instance for the Karpenter and Cilium addon controllers"
      "Name"                                                   = "${aws_eks_cluster.this.name}-critical"
      "k8s.io/cluster-autoscaler/${aws_eks_cluster.this.name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"                      = true
      "kubernetes.io/cluster/${aws_eks_cluster.this.name}"     = "owned"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      "Description"                                            = "Managed Node Group Bottlerocket EBS Volume for the Karpenter and Cilium addon controllers"
      "Name"                                                   = "${aws_eks_cluster.this.name}-critical"
      "k8s.io/cluster-autoscaler/${aws_eks_cluster.this.name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"                      = true
      "kubernetes.io/cluster/${aws_eks_cluster.this.name}"     = "owned"
    }
  }

  tags = {
    "Description"                                        = "Managed Node Group Launch Template for the Karpenter and Cilium addon controllers"
    "Name"                                               = "${aws_eks_cluster.this.name}-critical"
    "kubernetes.io/cluster/${aws_eks_cluster.this.name}" = "owned"
  }
}
