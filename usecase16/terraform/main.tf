
resource "kubernetes_config_map_v1" "drift_baseline" {
  metadata {
    name      = "usecase16-drift-baseline"
    namespace = var.namespace

    labels = {
      app        = "usecase16"
      environment = var.environment
      managed-by  = var.managed_by
    }

    annotations = {
      "drift-detection-enabled" = tostring(var.drift_detection_enabled)
    }
  }

  data = {
    environment          = var.environment
    desired_backend_replicas  = "2"
    desired_frontend_replicas = "2"
    desired_postgres_replicas = "1"
    configuration_owner      = "terraform"
  }
}

