output "bastion" {
    value = "${google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip }"
}

output "jenkins" {
    value = google_compute_forwarding_rule.jenkins_master_forwarding_rule.ip_address
}