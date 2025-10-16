# ---------------------------------------------------------------------------------------------------------------------
# ACM DNS CERTS
# unikiemarshalling.com subdomain
# ---------------------------------------------------------------------------------------------------------------------

module "acm" {
  source = "../../../modules/acm"

  cert_domains = {
    argocd = {
      name = "argocd"
    }
    auth = {
      name = "auth"
    }
    loki = {
      name = "loki"
    }
    grafana = {
      name = "grafana"
    }
  }
}
