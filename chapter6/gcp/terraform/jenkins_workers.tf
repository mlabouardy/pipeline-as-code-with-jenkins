resource "google_compute_firewall" "allow_ssh_to_worker" {
  project = var.project
  name    = "allow-ssh-to-worker"
  network = google_compute_network.management.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["bastion", "jenkins-ssh", "jenkins-worker"]
}

// Jenkins workers startup script
data "template_file" "jenkins_worker_startup_script" {
  template = "${file("scripts/join-cluster.tpl")}"

  vars = {
    jenkins_url            = "http://${google_compute_forwarding_rule.jenkins_master_forwarding_rule.ip_address}:8080"
    jenkins_username       = var.jenkins_username
    jenkins_password       = var.jenkins_password
    jenkins_credentials_id = var.jenkins_credentials_id
  }
}

resource "google_compute_instance_template" "jenkins-worker-template" {
  name_prefix = "jenkins-worker"
  description = "Jenkins workers instances template"
  region       = var.region

  tags = ["jenkins-worker"]
  machine_type         = var.jenkins_worker_machine_type
  metadata_startup_script = data.template_file.jenkins_worker_startup_script.rendered

  disk {
    source_image = var.jenkins_worker_machine_image
    disk_size_gb = 50
  }

  network_interface {
    network = google_compute_network.management.self_link 
    subnetwork = google_compute_subnetwork.private_subnets[0].self_link 
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key)}"
  }
}

resource "google_compute_instance_group_manager" "jenkins-workers-group" {
  provider = google-beta
  name = "jenkins-workers"
  base_instance_name = "jenkins-worker"
  zone               = var.zone

  depends_on = [google_compute_instance.jenkins_master]

  version {
    instance_template  = google_compute_instance_template.jenkins-worker-template.self_link
  }

  target_pools = [google_compute_target_pool.jenkins-workers-pool.id]
  target_size = 2
}

resource "google_compute_target_pool" "jenkins-workers-pool" {
  provider = google-beta
  name = "jenkins-workers-pool"
}

resource "google_compute_autoscaler" "jenkins-workers-autoscaler" {
  name   = "jenkins-workers-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.jenkins-workers-group.id

  autoscaling_policy {
    max_replicas    = 6
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}