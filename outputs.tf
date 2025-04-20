output "arn" {
  value = one(data.aws_ssoadmin_instances.idp.arns)
}

output "identity_store_id" {
  value = one(data.aws_ssoadmin_instances.idp.identity_store_ids)
}

output "groups" {
  value = [for sso_group in var.sso_groups : sso_group["name"]]
}

output "users" {
  value = local.sso_users
}

output "aws_sso_idp_metadata" {
  value = data.http.idp_metadata.response_body
}
