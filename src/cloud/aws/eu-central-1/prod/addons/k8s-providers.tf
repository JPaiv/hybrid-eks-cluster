data "aws_eks_cluster" "cluster" {
  name = "ums-ec1-prod-core"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "ums-ec1-prod-core"
}

provider "helm" {
  kubernetes = {
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    host                   = data.aws_eks_cluster.cluster.endpoint
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", "ums-ec1-prod-core"]
      command     = "aws"
    }
  }
}

provider "kubectl" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}
