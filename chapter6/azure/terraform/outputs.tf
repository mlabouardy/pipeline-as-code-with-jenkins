output "bastion" {
    value = azurerm_public_ip.bastion_public_ip.ip_address
}

output "jenkins" {
    value = azurerm_public_ip.jenkins_lb_public_ip.ip_address
}