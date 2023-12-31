terraform {
  cloud {
    organization = "Sksanth"

    workspaces {
      name = "terra-house-1"
    }
  }

  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid 
  token = var.terratowns_access_token
}

module "home_kpop_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.kpop.public_path
  content_version = var.kpop.content_version
}

resource "terratowns_home" "home_kpop" {
  name = "K-Pop"
  description = <<DESCRIPTION
Korean popular music, is a form of popular music originating in South Korea as part of South Korean culture.
DESCRIPTION
  domain_name = module.home_kpop_hosting.domain_name
  town = "melomaniac-mansion"
  content_version = var.kpop.content_version
}

module "home_bike_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.bike.public_path
  content_version = var.bike.content_version
}

resource "terratowns_home" "home_bike" {
  name = "Bikers"
  description = <<DESCRIPTION
Bicycling, also referred to as biking or cycling, is a form of transportation and a popular leisure-time physical activity. 
Health benefits include improved cardiovascular fitness, stronger muscles, greater coordination and general mobility, and reduced body fat.
DESCRIPTION
  domain_name = module.home_bike_hosting.domain_name
  town = "the-nomad-pad"
  content_version = var.bike.content_version
}
