
variable "namespace" {
  description = "Kubernetes namespace for Use Case 16"
  type        = string
  default     = "usecase16-lab"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "managed_by" {
  description = "Tool managing the infrastructure baseline"
  type        = string
  default     = "terraform"
}

variable "drift_detection_enabled" {
  description = "Whether configuration drift detection is enabled"
  type        = bool
  default     = true
}

