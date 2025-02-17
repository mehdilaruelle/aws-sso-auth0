output "arn" {
  value = one(data.aws_ssoadmin_instances.google.arns)
}

output "identity_store_id" {
  value = one(data.aws_ssoadmin_instances.google.identity_store_ids)
}

output "groups" {
  value = [for sso_group in var.sso_groups : sso_group["name"]]
}

output "users" {
  value = local.sso_users
}
