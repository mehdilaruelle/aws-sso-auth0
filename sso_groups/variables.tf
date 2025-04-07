variable "group_name" {
  description = "The AWS SSO Group name."
}

variable "group_description" {
  description = "The AWS SSO Group description."
  default     = ""
}

variable "group_accounts" {
  description = "The list of the AWS accounts to give access with the permission into the AWS SSO Group."
  type        = list(string)
  default     = []
}

variable "group_policies" {
  description = "The List of AWS IAM policies ARNs to give access to the AWS SSO Group."
  type        = list(string)
  default     = []
}