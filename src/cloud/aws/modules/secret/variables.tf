# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# --------------------------§-------------------------------------------------------------------------------------------

variable "description" {
  description = "Human-readable description of the secret"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "vault_name" {
  description = "Fully qualified name of the secret"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "abac_tags" {
  description = "Map of attribute-based access control (ABAC) tags to apply, where the key is the tag name and the value is an object of tag details."
  default     = null
  nullable    = true
  sensitive   = false
  type        = map(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# SECRET PARAMS
#
# Example:
# {
#   secr_1 = {
#     name           = "db_user1"
#     password_length    = 48
#     exclude_characters = "\"/\\"
#     require_each_type  = true
#   }
# }
# ---------------------------------------------------------------------------------------------------------------------

variable "secrets" {
  description = "Map of secret JSON object keys and values"
  type = map(object(
    {
      name                = string
      password_length     = optional(number)
      exclude_characters  = optional(string)
      exclude_punctuation = optional(bool)
      require_each_type   = optional(bool)
    }
  ))

  default = {
    password = {
      name                = "password"
      password_length     = 50
      exclude_characters  = null
      exclude_punctuation = false
      require_each_type   = false
    }
  }
}
