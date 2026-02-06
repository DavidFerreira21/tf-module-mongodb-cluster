

resource "mongodbatlas_advanced_cluster" "this" {
  project_id   = local.project_id_effective
  name         = var.cluster_name
  cluster_type = "REPLICASET"
  tags = local.merged_tags

  # Backup sempre habilitado.
  backup_enabled = true

  replication_specs = [
    {
      zone_name = "Zone 1"

      region_configs = [
        {
          provider_name = var.provider_name
          region_name   = var.region_name
          priority      = 7
          disk_size_gb  = var.disk_size_gb 

          electable_specs = {
            instance_size = var.instance_size_name
            node_count    = 3
          }

          auto_scaling = var.autoscaling == null ? null : {
            compute_enabled            = var.autoscaling.compute_enabled
            compute_min_instance_size  = try(var.autoscaling.compute_min_instance_size, null)
            compute_max_instance_size  = try(var.autoscaling.compute_max_instance_size, null)
            compute_scale_down_enabled = try(var.autoscaling.compute_scale_down_enabled, null)
            disk_gb_enabled            = try(var.autoscaling.disk_gb_enabled, null)

          }
        }
      ]
    }
  ]
}

resource "mongodbatlas_cloud_backup_schedule" "this" {
  project_id               = mongodbatlas_advanced_cluster.this.project_id
  cluster_name             = mongodbatlas_advanced_cluster.this.name
  reference_hour_of_day    = var.backup_policy.reference_hour_of_day
  reference_minute_of_hour = var.backup_policy.reference_minute_of_hour
  restore_window_days      = var.backup_policy.restore_window_days
  

  dynamic "policy_item_hourly" {
    for_each = var.backup_policy.policy_item_hourly == null ? [] : [var.backup_policy.policy_item_hourly]
    content {
      frequency_interval = policy_item_hourly.value.frequency_interval
      retention_unit     = policy_item_hourly.value.retention_unit
      retention_value    = policy_item_hourly.value.retention_value
    }
  }

  dynamic "policy_item_daily" {
    for_each = var.backup_policy.policy_item_daily == null ? [] : [var.backup_policy.policy_item_daily]
    content {
      frequency_interval = policy_item_daily.value.frequency_interval
      retention_unit     = policy_item_daily.value.retention_unit
      retention_value    = policy_item_daily.value.retention_value
    }
  }

  dynamic "policy_item_weekly" {
    for_each = var.backup_policy.policy_item_weekly == null ? [] : [var.backup_policy.policy_item_weekly]
    content {
      frequency_interval = policy_item_weekly.value.frequency_interval
      retention_unit     = policy_item_weekly.value.retention_unit
      retention_value    = policy_item_weekly.value.retention_value
    }
  }

  dynamic "policy_item_monthly" {
    for_each = var.backup_policy.policy_item_monthly == null ? [] : [var.backup_policy.policy_item_monthly]
    content {
      frequency_interval = policy_item_monthly.value.frequency_interval
      retention_unit     = policy_item_monthly.value.retention_unit
      retention_value    = policy_item_monthly.value.retention_value
    }
  }
}
