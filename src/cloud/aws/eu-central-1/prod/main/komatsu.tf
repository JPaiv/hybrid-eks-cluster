// -- Komatsu Docker images
module "komatsu" {
  source = "../../../modules/ecr"

  // -- Naming
  name = "komatsu"

  ecr_permission_statements = [
    {
      effect = "Allow"
      sid    = "KomatsuPullPermissions"
      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
      ]
      princip_type = "AWS"
      princip_identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/juhani.silvennoinen@unikie.com"
      ]
    },
    {
      effect = "Allow"
      sid    = "KomatsuAuthenticatePermissions"
      actions = [
        "ecr:GetAuthorizationToken"
      ]
      princip_type = "AWS"
      princip_identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/juhani.silvennoinen@unikie.com"
      ]
    }
  ]
}
