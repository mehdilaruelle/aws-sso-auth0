variable "region" {
  description = "The region in which the resources will be created."
}

variable "auth0_domain" {
  description = "The Auth0 domain."
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
