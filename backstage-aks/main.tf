resource "azurerm_resource_group" "aks" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "${var.prefix}-aks"
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  default_node_pool {
    name                        = "system"
    node_count                  = var.node_count
    vm_size                     = var.node_vm_size
    os_disk_size_gb             = var.node_os_disk_size_gb
    type                        = "VirtualMachineScaleSets"
    temporary_name_for_rotation = "sysrot"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }
}

resource "kubernetes_namespace" "backstage" {
  metadata {
    name = var.backstage_namespace
    labels = {
      app = "backstage"
    }
  }
}

resource "random_password" "backstage_backend_secret" {
  length  = 48
  special = false
}

resource "random_password" "postgresql_password" {
  length  = 32
  special = false
}

resource "helm_release" "backstage" {
  name             = var.backstage_release_name
  repository       = "https://backstage.github.io/charts"
  chart            = "backstage"
  version          = var.backstage_chart_version
  namespace        = kubernetes_namespace.backstage.metadata[0].name
  create_namespace = false
  wait             = true
  timeout          = var.helm_timeout_seconds

  values = [
    yamlencode({
      service = {
        type                     = var.backstage_service_type
        loadBalancerSourceRanges = var.backstage_load_balancer_source_ranges
      }

      ingress = {
        enabled = false
      }

      postgresql = {
        enabled = true
        auth = {
          username = var.postgresql_username
          password = random_password.postgresql_password.result
        }
      }

      backstage = {
        replicas  = var.backstage_replicas
        resources = var.backstage_resources

        extraEnvVars = [
          {
            name  = "BACKEND_SECRET"
            value = random_password.backstage_backend_secret.result
          }
        ]

        appConfig = {
          app = {
            title   = var.backstage_app_title
            baseUrl = var.backstage_base_url
          }

          backend = {
            baseUrl = var.backstage_base_url
            listen = {
              host = "0.0.0.0"
              port = 7007
            }
            cors = {
              origin      = var.backstage_base_url
              methods     = ["GET", "HEAD", "PATCH", "POST", "PUT", "DELETE"]
              credentials = true
            }
          }
        }
      }
    })
  ]
}
