variable "terratowns_endpoint" {
 type = string
}

variable "terratowns_access_token" {
 type = string
}

variable "teacherseat_user_uuid" {
  type        = string
}

variable "fall" {
  type = object({
    public_path = string
    content_version = number
  })
}

variable "kpop" {
  type = object({
    public_path = string
    content_version = number
  })
}

variable "bike" {
  type = object({
    public_path = string
    content_version = number
  })
}