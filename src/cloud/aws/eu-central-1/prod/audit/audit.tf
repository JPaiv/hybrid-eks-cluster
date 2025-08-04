// -- Cloudtrail audit and security monitoring
module "audit" {
  source = "../../../modules/audit"

  id_label = module.id_label.id
}
