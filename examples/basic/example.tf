module "atlas_cluster" {
  source = "git::https://github.com/cbssdigital/tf-module-mongodb-cluster.git?ref=dev"

  project_id         = "<atlas-project-id>"
  cluster_name       = "app-prod"
  instance_size_name = "M10"
  region_name        = "sa-east-1"
  provider_name      = "AWS"
  tags = {
  }
}
