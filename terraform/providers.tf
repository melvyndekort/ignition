terraform {
  cloud {
    organization = "melvyndekort"

    workspaces {
      name = "ignition"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.0"
    }
  }
}
