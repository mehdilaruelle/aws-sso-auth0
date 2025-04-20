resource "auth0_client" "aws_sso" {
  name        = "AWS SSO"
  description = "AWS SSO connection with Auth0"
  app_type    = "regular_web"
  callbacks   = [var.aws_acs_callback_url]

  grant_types = [
    "authorization_code",
    "implicit",
    "refresh_token",
    "client_credentials",
  ]

  addons {
    samlp {
      destination = var.aws_acs_callback_url
      mappings = {
        email    = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
        nickname = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"
      }
      create_upn_claim                   = false
      passthrough_claims_with_no_mapping = false
      map_unknown_claims_as_is           = false
      map_identities                     = false
      name_identifier_format             = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
      name_identifier_probes = [
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
      ]
      lifetime_in_seconds           = 3600
      typed_attributes              = true
      signature_algorithm           = "rsa-sha1"
      digest_algorithm              = "sha1"
      include_attribute_name_format = true
    }
  }
}

data "http" "idp_metadata" {
  url = "https://${var.auth0_domain}/samlp/metadata/${auth0_client.aws_sso.client_id}"
}

resource "auth0_user" "user" {
  for_each = var.auth0_connection_name == null ? {} : local.users_info

  connection_name = var.auth0_connection_name
  family_name     = try(upper(split(".", each.value)[1]), "UNDIFINED")
  given_name      = title(element(split(".", each.value), 0))
  name            = "${title(element(split(".", each.value), 0))} ${try(upper(split(".", each.value)[1]), "UNDIFINED")}"
  email           = each.key
  email_verified  = true
}
