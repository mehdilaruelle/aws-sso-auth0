provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
}

provider "auth0" {
  domain = var.auth0_domain
}

provider "http" {}
