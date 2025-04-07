output "permission_set_arn" {
  description = "The permission set ARN associate to the group."
  value       = aws_ssoadmin_permission_set.sso.arn
}

output "identity_store_id" {
  description = "The identity store ID used to create all the ressources."
  value       = one(data.aws_ssoadmin_instances.idp.identity_store_ids)
}

output "account_assignments" {
  description = "The list of assignement accounts to set the permissions (contains principal_id, type, target_id, etc)."
  value       = [for assignment in aws_ssoadmin_account_assignment.sso : assignment.id]
}

output "account_ids" {
  description = "The list of AWS account IDs."
  value       = var.group_accounts
}

output "iam_policies" {
  description = "The list of IAM policies to be set into the permission set."
  value       = var.group_policies
}

output "group_name" {
  description = "The group name to create."
  value       = var.group_name
}

output "group_id" {
  description = "The group ID."
  value       = aws_identitystore_group.sso.group_id
}