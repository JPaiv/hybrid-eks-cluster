# ---------------------------------------------------------------------------------------------------------------------
# MODULE EXTERNAL PARAMETERS
# User input not expected
# ---------------------------------------------------------------------------------------------------------------------

# Default: eu-central-1 AZ's
data "aws_availability_zones" "current" {}

# Default: eu-central-1
data "aws_region" "current" {}

# Account ID
data "aws_caller_identity" "current" {}
