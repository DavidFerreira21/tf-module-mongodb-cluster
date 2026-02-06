# terraform-mongodbatlas-cluster

Modulo Terraform opinionated para criacao de clusters MongoDB Atlas (Replica Set), com governanca e padroes corporativos. Ele remove opcoes perigosas por design e garante backup sempre habilitado.

## Objetivo

- Forcar backup habilitado.
- Restringir tamanhos de instancia.
- Restringir regioes por cloud (AWS/Azure) com allowlist.
- Evitar que decisoes criticas fiquem com o consumidor.
- Manter uma interface simples e dificil de usar errado.

## O que este modulo faz

- Cria um cluster MongoDB Atlas (Replica Set).
- Backup sempre habilitado.
- Restringe cloud provider a Azure ou AWS.
- Controla instance size (M10, M20, M30).
- Aplica tags padrao do modulo e permite tags adicionais.
- Exponde apenas outputs essenciais.

## Uso basico

```hcl
module "atlas_cluster" {
  source = "./terraform-mongodbatlas-cluster"

  project_id         = "<atlas-project-id>"
  cluster_name       = "app-prod"
  instance_size_name = "M20"
  provider_name      = "AWS"
  region_name        = "US_EAST_1"
}
```

## Politica de backup (default)

Se `backup_policy` nao for informado, o modulo aplica a politica minima HML:

- Daily 1x por dia
- Retencao de 7 dias
- Restore window de 7 dias
- Execucao as 02:00

```hcl
backup_policy = {
  reference_hour_of_day    = 2
  reference_minute_of_hour = 0
  restore_window_days      = 7

  policy_item_daily = {
    frequency_interval = 1
    retention_unit     = "days"
    retention_value    = 7
  }
}
```

## Politica de backup (custom)

Voce pode sobrescrever a politica padrao informando `backup_policy`.

```hcl
module "atlas_cluster" {
  source = "./terraform-mongodbatlas-cluster"

  project_id         = "<atlas-project-id>"
  cluster_name       = "app-prod"
  instance_size_name = "M20"
  provider_name      = "AWS"
  region_name        = "US_EAST_1"

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
}
```

## Auto-scaling (opcional)

O auto-scaling e desabilitado por padrao e so e configurado se `autoscaling` for informado.

```hcl
module "atlas_cluster" {
  source = "./terraform-mongodbatlas-cluster"

  project_id         = "<atlas-project-id>"
  cluster_name       = "app-prod"
  instance_size_name = "M20"
  provider_name      = "AWS"
  region_name        = "US_EAST_1"

  autoscaling = {
    compute_enabled            = true
    compute_min_instance_size  = "M10"
    compute_max_instance_size  = "M30"
    compute_scale_down_enabled = true
  }
}
```

## Resources

| Nome | Tipo | Descricao |
|---|---|---|
| `mongodbatlas_advanced_cluster.this` | Resource | Cluster MongoDB Atlas (Replica Set). |
| `mongodbatlas_cloud_backup_schedule.this` | Resource | Politica de backup do cluster (sempre aplicada). |

## Variaveis

| Nome | Tipo | Obrigatorio | Default | Descricao |
|---|---|---|---|---|
| `project_id` | `string` | Nao | `null` | ID do projeto MongoDB Atlas. Se informado, sobrescreve o local por cloud/ambiente. |
| `environment` | `string` | Nao | `hml` | Ambiente do cluster. Valores permitidos: `prd`, `hml` ou `dev`. |
| `cluster_name` | `string` | Sim | - | Nome do cluster. |
| `instance_size_name` | `string` | Sim | - | Tamanho do cluster. Valores permitidos: `M10`, `M20`, `M30`. |
| `provider_name` | `string` | Nao | `AWS` | Cloud provider do Atlas. Valores permitidos: `AZURE` ou `AWS`. |
| `region_name` | `string` | Sim | - | Atlas Region para o provider. O modulo valida contra a lista permitida em `locals.tf`. |
| `disk_size_gb` | `number` | Nao | `10` | Tamanho do disco (GB) por regiao do cluster. |
| `autoscaling` | `object` | Nao | `null` | Configuracoes de auto-scaling. |
| `backup_policy` | `object` | Nao | Politica HML | Politica de backup. Se omitido, aplica a politica minima HML. |
| `use_local_project_id` | `bool` | Nao | `true` | Quando `project_id` estiver null, usa o local `project_ids_by_provider_env`. |
| `tags` | `map(string)` | Nao | `{}` | Tags adicionais para o cluster. O modulo adiciona tags padrao automaticamente. |

## Projetos por cloud/ambiente

Se preferir nao informar `project_id` no modulo, preencha os IDs em `locals.tf` na chave `project_ids_by_provider_env` e informe `provider_name` e `environment`.

## Regioes permitidas

Allowlist atual em `locals.tf`:

- AWS: `US_EAST_1`, `SA_EAST_1`
- AZURE: `EAST_US_2`, `BRAZIL_SOUTH`

## Outputs

- `cluster_id`: ID do cluster.
- `cluster_name`: Nome do cluster.
- `project_id`: ID do projeto.
- `region_name`: Regiao do cluster.
- `instance_size_name`: Tamanho do cluster.

## Exemplos

Veja `examples`
