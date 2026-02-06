locals {
  project_id_from_local = try(local.project_ids_by_provider_env[var.provider_name][var.environment], "")
  project_id_effective  = var.project_id != null ? var.project_id : (var.use_local_project_id ? local.project_id_from_local : "")
  module_tags = {
    module = "tf-module-mongodb-cluster"
    terraform = "true"
  }
  merged_tags = merge(local.module_tags, coalesce(var.tags, {}))
  allowed_instance_sizes = [
    "M10",
    "M20",
    "M30",
  ]

  allowed_providers = [
    "AZURE",
    "AWS",
    "shared"
    
  ]

  allowed_regions_by_provider = {
    AWS = [
      "US_EAST_1",
      "SA_EAST_1",
    ]
    AZURE = [
      "EAST_US_2",
      "BRAZIL_SOUTH",
    ]
  }

  # Preencha conforme seus projetos por cloud e ambiente.
  project_ids_by_provider_env = {
    AZURE = {
      prd = ""
      hml = ""
    }
    AWS = {
      prd = ""
      hml = ""
    }
  }
}
