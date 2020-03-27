data "digitalocean_image" "jenkins_worker_image" {
  name = var.jenkins_worker_image
}

data "template_file" "jenkins_worker_startup_script" {
  template = "${file("scripts/join-cluster.tpl")}"

  vars = {
    jenkins_url            = "http://${digitalocean_droplet.jenkins_master.ipv4_address}:8080"
    jenkins_username       = var.jenkins_username
    jenkins_password       = var.jenkins_password
    jenkins_credentials_id = var.jenkins_credentials_id
  }
}

resource "digitalocean_droplet" "jenkins_workers" {
  count = var.jenkins_workers_count
  name   = "jenkins-worker"
  image  = data.digitalocean_image.jenkins_worker_image.id
  region = var.region
  size   = "s-1vcpu-2gb"
  ssh_keys = [var.ssh_fingerprint]
  user_data = data.template_file.jenkins_worker_startup_script.rendered
  depends_on = [digitalocean_droplet.jenkins_master]
}

resource "digitalocean_firewall" "jenkins_workers_firewall" {
  name = "jenkins-workers-firewall"

  droplet_ids = [for worker in digitalocean_droplet.jenkins_workers : worker.id   ]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_droplet_ids = [digitalocean_droplet.jenkins_master.id]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}