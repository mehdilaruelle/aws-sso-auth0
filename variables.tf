variable "region" {
  description = "The region in which the resources will be created."
  type        = string
}

variable "auth0_domain" {
  description = "The Auth0 domain."
  type        = string
}

variable "aws_acs_callback_url" {
  description = "The AWS IAM Identity Center Assertion Consumer (ACS) Service URL. It used as a callback by Auth0."
  type        = string
}

variable "tags" {
  description = "A map of key/value to tags resources deploy by the stack."
  type        = map(string)
  default     = {}
}

variable "sso_groups" {
  type = list(object({
    name        = string,
    description = optional(string),
    policy_arns = list(string),
    members     = optional(list(string), []),
    account_ids = optional(list(string), []),
  }))
  description = "The list of group to create in AWS SSO including: members, policy ARN & account IDs."
}

variable "auth0_connection_name" {
  description = "If this variable is used, it will create Auth0 users in the Connection name specify."
  type        = string
  default     = null
}
