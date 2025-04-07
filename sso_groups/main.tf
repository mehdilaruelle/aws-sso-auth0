resource "aws_identitystore_group" "sso" {
  display_name      = var.group_name
  description       = var.group_description
  identity_store_id = one(data.aws_ssoadmin_instances.idp.identity_store_ids)
}

resource "aws_ssoadmin_permission_set" "sso" {
  name             = var.group_name
  description      = format("%s group access for the Organization.", var.group_name)
  instance_arn     = one(data.aws_ssoadmin_instances.idp.arns)
  session_duration = "PT12H" #12hours
}

resource "aws_ssoadmin_managed_policy_attachment" "sso" {
  count              = length(var.group_policies)
  instance_arn       = one(data.aws_ssoadmin_instances.idp.arns)
  managed_policy_arn = var.group_policies[count.index]
  permission_set_arn = aws_ssoadmin_permission_set.sso.arn
}

resource "aws_ssoadmin_account_assignment" "sso" {
  count              = length(var.group_accounts)
  instance_arn       = one(data.aws_ssoadmin_instances.idp.arns)
  permission_set_arn = aws_ssoadmin_permission_set.sso.arn

  principal_id   = aws_identitystore_group.sso.group_id
  principal_type = "GROUP"

  target_id   = var.group_accounts[count.index]
  target_type = "AWS_ACCOUNT"
}