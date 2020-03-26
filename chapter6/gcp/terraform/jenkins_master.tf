resource "google_compute_firewall" "allow_ssh_to_jenkins" {
  project = var.project
  name    = "allow-ssh-to-jenkins"
  network = google_compute_network.management.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["bastion", "jenkins-ssh"]
}

resource "google_compute_firewall" "allow_access_to_ui" {
  project = var.project
  name    = "allow-access-to-jenkins-web"
  network = google_compute_network.management.self_link

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]

  source_tags = ["jenkins-web"]
}

resource "google_compute_instance" "jenkins_master" {
  project      = var.project
  name         = "jenkins-master"
  machine_type = var.jenkins_master_machine_type
  zone         = var.zone

  tags = ["jenkins-ssh", "jenkins-web"]

  depends_on = [google_compute_instance.bastion]

  boot_disk {
    initialize_params {
      image = var.jenkins_master_machine_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private_subnets[0].self_link 
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key)}"
  }
}


resource "google_compute_target_pool" "jenkins-master-target-pool" {
    name             = "jenkins-master-target-pool"
    session_affinity = "NONE"
    region           = var.region

    instances = [
        google_compute_instance.jenkins_master.self_link
    ]

    health_checks = [
        google_compute_http_health_check.jenkins_master_health_check.name
    ]
}

resource "google_compute_http_health_check" "jenkins_master_health_check" {
  name         = "jenkins-master-health-check"
  request_path = "/"
  port = "8080"
  timeout_sec        = 4
  check_interval_sec = 5
}

resource "google_compute_forwarding_rule" "jenkins_master_forwarding_rule" {
  name   = "jenkins-master-forwarding-rule"
  region = var.region
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_pool.jenkins-master-target-pool.self_link
  port_range            = "8080"
  ip_protocol           = "TCP"
}