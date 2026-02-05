locals {
  allowed_instance_sizes = [
    "M10",
    "M20",
    "M30",
  ]

  allowed_providers = [
    "AZURE",
    "AWS",
  ]

  allowed_regions_by_provider = {
    AZURE = [
      "us-east1",
      "sa-east-1",
    ]
    AWS = [
      "us-east1",
      "sa-east-1",
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
