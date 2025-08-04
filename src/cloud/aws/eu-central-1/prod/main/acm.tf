// -- ACM DNS Certs for unikiemarshalling.com subdomains
module "acm" {
  source = "../../../modules/acm"

  cert_domains = {
    alertmanager = {
      name = "alertmanager"
    }
    argocd = {
      name = "argocd"
    }
    auth = {
      name = "auth"
    }
    gateway_loki = {
      name = "gateway.loki"
    }
    grafana = {
      name = "grafana"
    }
    prometheus = {
      name = "prometheus"
    }
    komatsu = {
      name = "komatsu"
    }
  }
}
