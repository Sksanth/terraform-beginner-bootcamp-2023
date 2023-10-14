## Terrahome AWS

```tf
module "home_bike_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.bike.public_path
  content_version = var.bike.content_version
}
```

The public directory expects the following:
- index.html
- error.html
- assets

ALl top level files in assets will be copied, but not any subdirectories.

### TerraTowns

Terratowns should not be in **Missingo**, this is the test town

![Terratowns](https://github.com/Sksanth/aws-bc/assets/102387885/ece3bb37-c4aa-4727-9efa-25f4537788aa)