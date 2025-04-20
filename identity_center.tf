data "aws_ssoadmin_instances" "idp" {}

##### GROUP #####

module "main" {
  for_each = {
    for sso_group in var.sso_groups : sso_group["name"] => sso_group # Only to fetch module by group name: module["group_name"]
  }

  source            = "./sso_groups"
  group_name        = each.value["name"]
  group_description = each.value["description"]
  group_accounts    = each.value["account_ids"]
  group_policies    = each.value["policy_arns"]
}

locals {
  sso_users = distinct(compact(flatten([for sso_group in var.sso_groups : sso_group.members]))) # Get all users for each groups as a global user
  users_info = {
    for sso_user in local.sso_users :
    sso_user => one(regex("([^@]+)", sso_user)) # email => firstname.lastname (if lastname exist, if not set UNDEFINED)
  }
}

resource "aws_identitystore_user" "idp" {
  for_each = local.users_info

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
        group = module.main[sso_group.name].group_id,
        user  = aws_identitystore_user.idp[member].user_id
      }
    }
  ]...)

  identity_store_id = one(data.aws_ssoadmin_instances.idp.identity_store_ids)
  group_id          = each.value["group"]
  member_id         = each.value["user"]
}
