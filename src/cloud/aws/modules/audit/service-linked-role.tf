resource "aws_iam_service_linked_role" "this" {
  aws_service_name = "spot.amazonaws.com"
}
