output "resource_group_name" {
  description = "Azure resource group containing the AKS cluster."
  value       = azurerm_resource_group.aks.name
}

output "aks_cluster_name" {
  description = "AKS cluster name."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "backstage_namespace" {
  description = "Kubernetes namespace where Backstage is installed."
  value       = kubernetes_namespace.backstage.metadata[0].name
}

output "backstage_release_name" {
  description = "Helm release name for Backstage."
  value       = helm_release.backstage.name
}

output "backstage_service_name" {
  description = "Kubernetes Service name created by the Backstage chart."
  value       = var.backstage_release_name
}

output "kube_config" {
  description = "Raw kubeconfig for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "kubectl_get_service_command" {
  description = "Command to fetch the Backstage service and external IP after apply."
  value       = "kubectl -n ${var.backstage_namespace} get service ${var.backstage_release_name}"
}
