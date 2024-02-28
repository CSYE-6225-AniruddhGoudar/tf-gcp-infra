resource "google_compute_firewall" "allow_tcp" {
  count   = var.num_vpcs
  name    = "allow-tcp-${count.index}"
  network = google_compute_network.vpc[count.index].name
  priority = var.allow_tcp_port_priority 

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
  priority = var.deny_ssh_port_priority 

  deny {
    protocol = var.protocol
    ports    = var.deny_ssh_port
  }

  source_ranges = var.source_ranges
  target_tags = var.target_tags
}

resource "google_compute_instance" "myvm01" {
   count   = var.num_vpcs
  name         = "${var.vm_name}-${count.index}"
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
 depends_on = [google_compute_subnetwork.webapp, 
 google_compute_firewall.allow_tcp, google_compute_firewall.deny_ssh, 
 google_sql_database_instance.cloud_sql_instance]


metadata_startup_script = <<-EOF
#!/bin/bash
cd /opt/csye6225/webapp
if [ ! -f .env ]; then
  touch .env
fi

# Database configuration
echo "DATABASE_HOST=${google_sql_database_instance.cloud_sql_instance[count.index].ip_address.0.ip_address}" >> .env
echo "DATABASE_USER=${google_sql_user.database_user[count.index].name}" >> .env
echo "DATABASE_PASSWORD=${random_password.database_password.result}" >> .env
echo "DATABASE_NAME=${var.database_name}" >> .env

# Reload systemctl daemon
sudo systemctl daemon-reload
EOF
}