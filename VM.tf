resource "google_compute_firewall" "allow_tcp" {
  count   = var.num_vpcs
  name    = "allow-tcp-${count.index}"
  network = google_compute_network.vpc[count.index].name

  allow {
    protocol = var.protocol
    ports    = var.allow_tcp_port
  }

  source_ranges = var.source_ranges
  target_tags = var.target_tags
}

resource "google_compute_firewall" "deny_ssh" {
  count   = var.num_vpcs
  name    = "deny-ssh-${count.index}"
  network = google_compute_network.vpc[count.index].name

  deny {
    protocol = var.protocol
    ports    = var.deny_ssh_port
  }

  source_ranges = var.source_ranges
  target_tags = var.target_tags
}

resource "google_compute_instance" "myvm01" {
   count   = var.num_vpcs
  name         = "vm-webapp-${count.index}"
  machine_type = var.machine_type
  hostname     = var.hostname

  zone         = "${var.region}-b"
  allow_stopping_for_update = var.allow_stopping_for_update

  boot_disk {
    initialize_params {
      image = var.image
      type = var.type
      size = var.size
    }
  }

  network_interface {
    
    network = google_compute_network.vpc[count.index].self_link
    subnetwork = google_compute_subnetwork.webapp[count.index].self_link

    access_config {
      // Ephemeral public IP
    }
  }
 tags         = var.target_tags
 depends_on = [google_compute_subnetwork.webapp, google_compute_firewall.allow_tcp, google_compute_firewall.deny_ssh]
}
