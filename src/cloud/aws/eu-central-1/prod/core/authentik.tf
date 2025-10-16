# ---------------------------------------------------------------------------------------------------------------------
# AUTHENTIK RDS POSTGRES
# RDS passwords vault with ABAC tags
# RDS Postgres
# ---------------------------------------------------------------------------------------------------------------------

module "vault_rds_authentik" {
  source = "../../../modules/secret"

  description = "Authentik RDS password"
  vault_name  = "${module.id_label.id}-vault-authentik-rds"

  abac_tags = {
    "ABAC-Vault" = "rds-authentik"
  }

  secrets = {
    password = {
      exclude_characters = "!@#$%^&*()_+-=[]{}|;:',.<>/?`~\"\\"
      name               = "password"
      password_length    = 50
    }
  }
}

module "rds_authentik" {
  source = "../../../modules/rds"

  db_name         = "authentik"
  db_username     = "authentik"
  id_label        = module.id_label.id
  priv_subnet_ids = module.vpc.private_subnet_ids
  vault_name      = "${module.id_label.id}-vault-authentik-rds"
  vpc_id          = module.vpc.vpc_id

  depends_on = [
    module.vault_rds_authentik
  ]
}
