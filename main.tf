terraform {
  # cloud {
  #   organization = "Sksanth"

  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }

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

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  bucket_name = var.bucket_name
  user_uuid = var.teacherseat_user_uuid
  index_html_filepath = "${path.root}${var.index_html_filepath}"
  error_html_filepath = "${path.root}${var.error_html_filepath}"
  content_version = var.content_version
  assets_path = "${path.root}${var.assets_path}" 
}

resource "terratowns_home" "home" {
  name = "October 2023"
  description = <<DESCRIPTION
Autumn is generally regarded as the end of the growing season. 
In the autumn season, the daylight grows shorter, and animals prepare for the long, cold months ahead. 
The temperature starts becoming cooler during autumn. 
Leaves on the trees will turn yellow, orange, red and brown during autumn.
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  town = "missingo"
  content_version = 1
}

