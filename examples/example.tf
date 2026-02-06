module "atlas_cluster" {
  source = "git::https://github.com/cbssdigital/tf-module-mongodb-cluster.git?ref=1.0.0"

  project_id         = "<atlas-project-id>"
  cluster_name       = "app-prod"
  instance_size_name = "M10"
  region_name        = "US_EAST_1"
  provider_name      = "AWS"
  autoscaling = {
    compute_enabled            = false
    compute_min_instance_size  = "M10"
    compute_max_instance_size  = "M10"
    compute_scale_down_enabled = true
    disk_gb_enabled               = false
  }

  backup_policy = {
    reference_hour_of_day    = 2
    reference_minute_of_hour = 0
    restore_window_days      = 7

    policy_item_daily = {
      frequency_interval = 1
      retention_unit     = "days"
      retention_value    = 7
    }

    policy_item_weekly = {
      frequency_interval = 1
      retention_unit     = "weeks"
      retention_value    = 4
    }
  }


  tags = {
  }
}
