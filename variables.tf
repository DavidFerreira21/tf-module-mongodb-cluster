variable "project_id" {
  type        = string
  description = "ID do projeto MongoDB Atlas. Se informado, sobrescreve o local por cloud/ambiente."
  default     = null

  validation {
    condition = var.project_id != null || (
      var.use_local_project_id &&
      try(local.project_ids_by_provider_env[var.provider_name][var.environment], "") != ""
    )
    error_message = "project_id deve ser informado ou existir no local project_ids_by_provider_env para o provider/ambiente."
  }
}

variable "environment" {
  type        = string
  description = "Ambiente do cluster (prd ou hml)."
  default     = "hml"

  validation {
    condition     = contains(["prd", "hml"], var.environment)
    error_message = "environment deve ser prd ou hml."
  }
}

variable "cluster_name" {
  type        = string
  description = "Nome do cluster."
}

variable "instance_size_name" {
  type        = string
  description = "Tamanho do cluster (somente M10, M20, M30)."

  validation {
    condition     = contains(local.allowed_instance_sizes, var.instance_size_name)
    error_message = "instance_size_name deve ser um dos seguintes valores: M10, M20, M30."
  }
}

variable "region_name" {
  type        = string
  description = "Regiao do cluster (Atlas Region para o provider selecionado)."

  validation {
    condition     = contains(local.allowed_regions_by_provider[var.provider_name], var.region_name)
    error_message = "region_name deve ser um Atlas Region permitido para o provider selecionado."
  }
}

variable "provider_name" {
  type        = string
  description = "Cloud provider do Atlas. Valores permitidos: AZURE ou AWS."
  default     = "AZURE"

  validation {
    condition     = contains(local.allowed_providers, var.provider_name)
    error_message = "provider_name deve ser AZURE ou AWS."
  }
}

variable "use_local_project_id" {
  type        = bool
  description = "Quando true e project_id estiver null, usa o local project_ids_by_provider_env."
  default     = true
}

variable "autoscaling" {
  type = object({
    compute_enabled            = bool
    compute_min_instance_size  = optional(string)
    compute_max_instance_size  = optional(string)
    compute_scale_down_enabled = optional(bool)
  })
  default     = null
  description = "Configura auto-scaling. Quando null, o modulo nao configura auto-scaling."
}

variable "backup_policy" {
  type = object({
    reference_hour_of_day    = number
    reference_minute_of_hour = number
    restore_window_days      = number
    policy_item_hourly = optional(object({
      frequency_interval = number
      retention_unit     = string
      retention_value    = number
    }))
    policy_item_daily = optional(object({
      frequency_interval = number
      retention_unit     = string
      retention_value    = number
    }))
    policy_item_weekly = optional(object({
      frequency_interval = number
      retention_unit     = string
      retention_value    = number
    }))
    policy_item_monthly = optional(object({
      frequency_interval = number
      retention_unit     = string
      retention_value    = number
    }))
  })
  default = {
    reference_hour_of_day    = 2
    reference_minute_of_hour = 0
    restore_window_days      = 7
    policy_item_daily = {
      frequency_interval = 1
      retention_unit     = "days"
      retention_value    = 7
    }
  }
  description = "Politica de backup. Se nao informado, aplica a politica minima HML (daily por 7 dias)."
}
