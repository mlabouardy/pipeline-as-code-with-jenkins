data "digitalocean_image" "jenkins_master_image" {
  name = var.jenkins_master_image
}

resource "digitalocean_droplet" "jenkins_master" {
  name   = "jenkins-master"
  image  = data.digitalocean_image.jenkins_master_image.id
  region = var.region
  size   = "s-1vcpu-2gb"
  ssh_keys = [var.ssh_fingerprint]
}

resource "digitalocean_firewall" "jenkins_master_firewall" {
  name = "jenkins-master-firewall"

  droplet_ids = [digitalocean_droplet.jenkins_master.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["0.0.0.0/0", "::/0"]
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