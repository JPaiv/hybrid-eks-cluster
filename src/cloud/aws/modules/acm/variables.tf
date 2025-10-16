variable "cert_domains" {
  description = "unikiemarshalling.com DNS certs for the AWS Load Balancer Controller"
  nullable    = false
  sensitive   = false
  type = map(
    map(string)
  )
}
