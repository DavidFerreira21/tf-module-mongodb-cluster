output "cluster_id" {
  description = "ID do cluster no Atlas."
  value       = mongodbatlas_advanced_cluster.this.cluster_id
}

output "cluster_name" {
  description = "Nome do cluster."
  value       = mongodbatlas_advanced_cluster.this.name
}

output "project_id" {
  description = "ID do projeto MongoDB Atlas."
  value       = mongodbatlas_advanced_cluster.this.project_id
}

output "region_name" {
  description = "Regiao do cluster (Atlas Region)."
  value       = var.region_name
}

output "instance_size_name" {
  description = "Tamanho do cluster."
  value       = var.instance_size_name
}
