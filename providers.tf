provider "aws" {
  region = var.region
  default_tags {
    tags = local.tags
  }
}

provider "auth0" {
  domain = var.auth0_domain
}
