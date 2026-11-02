
output "namespace" {
  description = "Kubernetes namespace used by Use Case 16"
  value       = var.namespace
}

output "drift_baseline_configmap" {
  description = "Name of the Terraform-managed drift baseline ConfigMap"
  value       = kubernetes_config_map_v1.drift_baseline.metadata[0].name
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "drift_detection_enabled" {
  description = "Drift detection setting"
  value       = var.drift_detection_enabled
}

