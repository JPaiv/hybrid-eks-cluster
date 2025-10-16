# ---------------------------------------------------------------------------------------------------------------------
# VPC FOR THE CORE EKS CLUSTER, SHARED ELASTICACHE AND RDS POSTGRES
# ---------------------------------------------------------------------------------------------------------------------

module "vpc" {
  source = "../../../modules/vpc"

  # Naming
  id_label = module.id_label.id

  # VPC
  vpc_cidr = "192.168.0.0/16"

  # One private subnet for each AZ
  private_subnet_cidrs = [
    "192.168.64.0/20",
    "192.168.80.0/20",
    "192.168.96.0/20",
  ]

  # One public subnet for each AZ
  public_subnet_cidrs = [
    "192.168.16.0/20",
    "192.168.32.0/20",
    "192.168.48.0/20",
  ]

  # Ingress and egress rules are a map of objects
  sg_ingress_rules = {
    "allow_tls" = {
      cidr_ipv4   = "0.0.0.0/0",
      name        = "${module.id_label.id}-https-only",
      description = "Allow only HTTPS inbound traffic",
      from_port   = 443,
      ip_protocol = "tcp",
      to_port     = 443
    }
    "allow_ssh" = {
      cidr_ipv4   = "0.0.0.0/0",
      name        = "${module.id_label.id}-ssh-only",
      description = "Allow only inbound SSH",
      from_port   = 22,
      ip_protocol = "tcp",
      to_port     = 22
    }
  }
  # Allow all outbound traffic
  sg_egress_rules = {
    "allow_all" = {
      cidr_ipv4   = "0.0.0.0/0",
      description = "Allow all outgoing traffic",
      name        = "${module.id_label.id}-all-egress",
      from_port   = -1,
      ip_protocol = "-1",
      to_port     = -1
    }
  }
}
