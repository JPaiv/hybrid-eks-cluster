resource "aws_accessanalyzer_analyzer" "account" {
  analyzer_name = "${var.id_label}-account"
  type          = "ACCOUNT"

  tags = {
    "Description" = "Identify IAM User Activity"
    "Name"        = "${var.id_label}-account"
  }
}

resource "aws_accessanalyzer_analyzer" "unsed_access" {
  analyzer_name = "${var.id_label}-unsed-access"
  type          = "ACCOUNT_UNUSED_ACCESS"

  configuration {
    unused_access {
      unused_access_age = 90 # 3 months
    }
  }

  tags = {
    "Description" = "Identify All Unused Activity in the Last Three Months"
    "Name"        = "${var.id_label}-unsed-access"
  }
}
