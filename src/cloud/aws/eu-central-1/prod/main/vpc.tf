module "vpc" {
  source = "../../../modules/vpc"

  // -- Naming
  id_label = module.id_label.id

  // -- One private subnet cidr block for each eu-central-1 AZ
  private_subnet_cidrs = [
    "192.168.64.0/20",
    "192.168.80.0/20",
    "192.168.96.0/20",
  ]

  // -- One public subnet cidr block for each eu-central-1 AZ
  public_subnet_cidrs = [
    "192.168.16.0/20",
    "192.168.32.0/20",
    "192.168.48.0/20",
  ]

  // -- Ingress and egress rules are a map of objects
  sg_ingress_rules = {
    "allow_tls" = {
      cidr_ipv4   = "0.0.0.0/0",
      description = "Allow all imbound traffic"
      from_port   = -1,
      ip_protocol = "-1",
      to_port     = -1
    }
  }

  sg_egress_rules = {
    "allow_all" = {
      cidr_ipv4   = "0.0.0.0/0",
      description = "Allow all outgoing traffic"
      from_port   = -1,
      ip_protocol = "-1",
      to_port     = -1
    }
  }

  // -- VPC CIDR Block
  vpc_cidr = "192.168.0.0/16"
}
