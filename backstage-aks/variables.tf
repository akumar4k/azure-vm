variable "prefix" {
  description = "Name prefix for the AKS and Backstage resources."
  type        = string
  default     = "backstage"
}

variable "location" {
  description = "Azure region for AKS."
  type        = string
  default     = "eastus"
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version. Null lets Azure choose the default supported version."
  type        = string
  default     = null
}

variable "node_count" {
  description = "Number of nodes in the AKS system node pool."
  type        = number
  default     = 2
}

variable "node_vm_size" {
  description = "VM size for AKS nodes."
  type        = string
  default     = "Standard_B2s"
}

variable "node_os_disk_size_gb" {
  description = "OS disk size in GiB for AKS nodes."
  type        = number
  default     = 64
}

variable "backstage_namespace" {
  description = "Kubernetes namespace for Backstage."
  type        = string
  default     = "backstage"
}

variable "backstage_release_name" {
  description = "Helm release name for Backstage."
  type        = string
  default     = "backstage"
}

variable "backstage_chart_version" {
  description = "Backstage Helm chart version."
  type        = string
  default     = "2.8.2"
}

variable "backstage_app_title" {
  description = "Backstage app title shown in the UI."
  type        = string
  default     = "Backstage"
}

variable "backstage_base_url" {
  description = "External base URL for Backstage. Update after assigning DNS to the LoadBalancer IP."
  type        = string
  default     = "http://localhost:7007"
}

variable "backstage_replicas" {
  description = "Number of Backstage pod replicas."
  type        = number
  default     = 1
}

variable "backstage_resources" {
  description = "CPU and memory requests/limits for the Backstage pod."
  type        = any
  default = {
    requests = {
      cpu    = "250m"
      memory = "512Mi"
    }
    limits = {
      cpu    = "1000m"
      memory = "1Gi"
    }
  }
}

variable "backstage_service_type" {
  description = "Kubernetes Service type for Backstage. Use LoadBalancer for direct AKS exposure or ClusterIP behind ingress."
  type        = string
  default     = "LoadBalancer"

  validation {
    condition     = contains(["ClusterIP", "LoadBalancer", "NodePort"], var.backstage_service_type)
    error_message = "backstage_service_type must be ClusterIP, LoadBalancer, or NodePort."
  }
}

variable "backstage_load_balancer_source_ranges" {
  description = "CIDRs allowed to reach the Backstage LoadBalancer. Empty allows all sources."
  type        = list(string)
  default     = []
}

variable "postgresql_username" {
  description = "PostgreSQL username created by the Backstage chart."
  type        = string
  default     = "bn_backstage"
}

variable "helm_timeout_seconds" {
  description = "Timeout for the Backstage Helm release install or upgrade."
  type        = number
  default     = 600
}

variable "tags" {
  description = "Tags applied to Azure resources."
  type        = map(string)
  default = {
    managed_by = "terraform"
    app        = "backstage"
  }
}
