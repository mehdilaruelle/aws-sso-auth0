<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_identitystore_group.sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group) | resource |
| [aws_ssoadmin_account_assignment.sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_managed_policy_attachment.sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment) | resource |
| [aws_ssoadmin_permission_set.sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_instances.idp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_group_accounts"></a> [group\_accounts](#input\_group\_accounts) | The list of the AWS accounts to give access with the permission into the AWS SSO Group. | `list(string)` | `[]` | no |
| <a name="input_group_description"></a> [group\_description](#input\_group\_description) | The AWS SSO Group description. | `string` | `""` | no |
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | The AWS SSO Group name. | `any` | n/a | yes |
| <a name="input_group_policies"></a> [group\_policies](#input\_group\_policies) | The List of AWS IAM policies ARNs to give access to the AWS SSO Group. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_assignments"></a> [account\_assignments](#output\_account\_assignments) | The list of assignement accounts to set the permissions (contains principal\_id, type, target\_id, etc). |
| <a name="output_account_ids"></a> [account\_ids](#output\_account\_ids) | The list of AWS account IDs. |
| <a name="output_group_id"></a> [group\_id](#output\_group\_id) | The group ID. |
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | The group name to create. |
| <a name="output_iam_policies"></a> [iam\_policies](#output\_iam\_policies) | The list of IAM policies to be set into the permission set. |
| <a name="output_identity_store_id"></a> [identity\_store\_id](#output\_identity\_store\_id) | The identity store ID used to create all the ressources. |
| <a name="output_permission_set_arn"></a> [permission\_set\_arn](#output\_permission\_set\_arn) | The permission set ARN associate to the group. |
<!-- END_TF_DOCS -->