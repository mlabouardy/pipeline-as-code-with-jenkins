resource "google_compute_firewall" "allow_ssl_to_bastion" {
  project = var.project
  name    = "allow-ssl-to-bastion"
  network = google_compute_network.management.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  source_tags = ["bastion"]
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}

resource "google_compute_instance" "bastion" {
  project      = var.project
  name         = "bastion"
  machine_type = var.bastion_machine_type
  zone         = var.zone

  tags = ["bastion"]

  boot_disk {
    initialize_params {
      image = var.bastion_machine_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnets[0].self_link 

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key)}"
  }
}