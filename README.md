# SSO project

In this project, we will create [AWS IAM Identity Center (previously AWS SSO)](https://aws.amazon.com/fr/iam/identity-center/).
This AWS service can be only used and manage in the Management account of an [AWS Organization](https://aws.amazon.com/fr/organizations/).


Each Identity is a member of a group where [permission set](https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html) policy are defined.
Each [permission set](https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html) let our Identity group to have permissions to **1 or many
AWS accounts**.

## Create group, users & policies

To set a group, you need to set the Terraform variable `sso_groups`.
An example of the variable (keep in mind, this is a list of group):
```hcl
sso_groups = [
  {
    name = "DevOps"
    description = "The DevOps team",
    policy_arns = [
      "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
    ],
    account_ids = [
      "123456789012", # Fact AWS account
    ]
    members = [
      "contact@mehdilaruelle.com",
    ],
  },
]
```

In the previous example, we define:
- **name**: Who is the name of the group.
- **description**: A description of the group (always good to provide one).
- **account_ids**: The list of account IDs.
- **policy_arns**: A list of [AWS managed policies](https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetcustom.html#permissionsetsampconcept). There is a limit of
  10 policies per group. You can 'bypass' this limit via an [inline policy](https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetcustom.html#permissionsetsinlineconcept).
  **WARNING:** The AWS managed policies should exist to the target AWS account IDs or an error will raise. Prefer always to use the AWS managed policies who are present to all
  AWS Account instead of [Customer managed policies](https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetcustom.html#permissionsetscmpconcept).
- **members**: A list of Identity. You should use the email address used by the user to login to authorize him, if you provide a bad email the user will NOT be able to login.


### Inline policies

If you reach the limit of 10 managed policy for a group OR you need to create a custom policy, you can create an [inline policy](https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetcustom.html#permissionsetsinlineconcept) instead of [Customer managed policies](https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetcustom.html#permissionsetscmpconcept).

An example of creating a policy and attach this policy for the `billing` groups:
```hcl
# Billing for prod account permission
data "aws_iam_policy_document" "billing" {
  statement {
    sid = "billing"

    actions = [
      "cur:*",
      "ce:*",
      "consolidatedbilling:*",
      "freetier:*",
      "tax:*",
      "account:GetAccountInformation"
    ]
    resources = ["*"]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "billing" {
  instance_arn       = one(data.aws_ssoadmin_instances.idp.arns)
  permission_set_arn = module.main["billing"].permission_set_arn
  inline_policy      = data.aws_iam_policy_document.billing.json
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_auth0"></a> [auth0](#requirement\_auth0) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.94.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_main"></a> [main](#module\_main) | ./sso_groups | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_identitystore_group_membership.idp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group_membership) | resource |
| [aws_identitystore_user.idp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_user) | resource |
| [aws_ssoadmin_instances.idp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auth0_domain"></a> [auth0\_domain](#input\_auth0\_domain) | The Auth0 domain. | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region in which the resources will be created. | `any` | n/a | yes |
| <a name="input_sso_groups"></a> [sso\_groups](#input\_sso\_groups) | The list of group to create in AWS SSO including: members, policy ARN & account IDs. | <pre>list(object({<br/>    name        = string,<br/>    description = optional(string),<br/>    policy_arns = list(string),<br/>    members     = optional(list(string), []),<br/>    account_ids = optional(list(string), []),<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key/value to tags resources deploy by the stack. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_groups"></a> [groups](#output\_groups) | n/a |
| <a name="output_identity_store_id"></a> [identity\_store\_id](#output\_identity\_store\_id) | n/a |
| <a name="output_users"></a> [users](#output\_users) | n/a |
<!-- END_TF_DOCS -->