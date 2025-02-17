data "aws_ssoadmin_instances" "idp" {}

locals {
  sso_users = distinct(compact(flatten([for sso_group in var.sso_groups : sso_group.members]))) # Get all users for each groups as a global user
  sso_groups = {
    for sso_group in var.sso_groups : sso_group["name"] => sso_group # Only to fetch module by group name: module["group_name"]
  }
}

resource "aws_identitystore_group" "sso" {
  for_each = local.sso_groups

  display_name      = each.value["name"]
  description       = each.value["description"]
  identity_store_id = one(data.aws_ssoadmin_instances.idp.identity_store_ids)
}

resource "aws_ssoadmin_permission_set" "sso" {
  for_each = local.sso_groups

  name             = each.value["name"]
  description      = format("%s group access for the Organization.", each.value["name"])
  instance_arn     = one(data.aws_ssoadmin_instances.idp.arns)
  session_duration = "PT12H" #12hours
}

resource "aws_ssoadmin_managed_policy_attachment" "sso" {
  for_each = local.sso_groups # group_accounts    = each.value["account_ids"]

  count              = length(var.group_policies)
  instance_arn       = one(data.aws_ssoadmin_instances.idp.arns)
  managed_policy_arn = var.group_policies[count.index]
  permission_set_arn = aws_ssoadmin_permission_set.sso.arn
}

resource "aws_ssoadmin_account_assignment" "sso" {
  for_each = local.sso_groups # group_policies    = each.value["policy_arns"]

  count              = length(var.group_accounts)
  instance_arn       = one(data.aws_ssoadmin_instances.idp.arns)
  permission_set_arn = aws_ssoadmin_permission_set.sso.arn

  principal_id   = aws_identitystore_group.sso.group_id
  principal_type = "GROUP"

  target_id   = var.group_accounts[count.index]
  target_type = "AWS_ACCOUNT"
}

resource "aws_identitystore_user" "idp" {
  for_each = {
    for sso_user in local.sso_users :
    sso_user => one(regex("([^@]+)", sso_user)) # email => firstname.lastname (if lastname exist)
  }

  identity_store_id = one(data.aws_ssoadmin_instances.idp.identity_store_ids)

  display_name = title(replace(each.value, ".", " "))
  user_name    = each.key

  name {
    given_name  = title(element(split(".", each.value), 0))
    family_name = try(upper(split(".", each.value)[1]), "UNDIFINED")
  }

  emails {
    value = each.key
  }
}

resource "aws_identitystore_group_membership" "idp" {
  # Double FOR to fetch ALL members (2nd FOR) for ALL groups (1th FOR).
  # We make the association like this: { unique_id_association = {group = group_id, user = user_id} }
  # unique_id_association: is the "member_name-group_name" used by the for_each to have an unique value
  for_each = merge([
    for sso_group in var.sso_groups :
    {
      for member in sso_group.members :
      format("%s-%s", member, sso_group.name) => {
        group = aws_identitystore_group.sso[sso_group.name].group_id,
        user  = aws_identitystore_user.idp[member].user_id
      }
    }
  ]...)

  identity_store_id = one(data.aws_ssoadmin_instances.idp.identity_store_ids)
  group_id          = each.value["group"]
  member_id         = each.value["user"]
}
