module "atlas_cluster" {
  source = "../../"

  project_id         = "<atlas-project-id>"
  cluster_name       = "app-prod"
  instance_size_name = "M20"
  region_name        = "BRAZIL_SOUTH"
}
