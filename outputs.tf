output "resource_group_name" {
  description = "Resource group containing the VM resources."
  value       = azurerm_resource_group.vm.name
}

output "vm_id" {
  description = "Azure resource ID of the virtual machine."
  value       = azurerm_linux_virtual_machine.vm.id
}

output "private_ip_address" {
  description = "Private IP assigned to the virtual machine."
  value       = azurerm_network_interface.vm.private_ip_address
}
