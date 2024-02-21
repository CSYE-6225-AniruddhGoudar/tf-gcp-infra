resource "google_compute_firewall" "allow_ssh" {
  count   = var.num_vpcs
  name    = "allow-ssh-${count.index}"
  network = google_compute_network.vpc[count.index].name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["webapp"]
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
 tags         = ["webapp"]
 depends_on = [google_compute_subnetwork.webapp, google_compute_firewall.allow_ssh]
}
