resource "google_compute_global_address" "forward_address" {
   count       = var.num_vpcs
 project       = var.project_id
  name         = "fwd-address"
}


resource "google_compute_region_instance_template" "VMtemplate" {
  count          = var.num_vpcs
  name           = var.template_name
  machine_type   = var.machine_type
  can_ip_forward = var.can_ip_forward
  region         = var.region
  tags           = var.target_tags

disk {
    source_image = var.image
    auto_delete  = var.disk_auto_delete
    boot         = var.disk_boot
    disk_size_gb =var.disk_size_gb
    disk_type = var.disk_type
  
  }
  reservation_affinity{
    type = var.reservation_affinity_type
  }

  network_interface {
    network = google_compute_network.vpc[count.index].self_link
    subnetwork = google_compute_subnetwork.lb[count.index].self_link
    access_config {
    }
  }


  scheduling {
    preemptible       = var.scheduling_preemptible
    automatic_restart = var.scheduling_automatic_restart
  } //do not need verify

   metadata = {
    startup-script = <<-EOF
    #!/bin/bash
    cd /opt/csye6225/webapp
    if [ ! -f .env ]; then
    touch .env

    # Database configuration
    echo "DATABASE_HOST=${google_sql_database_instance.cloud_sql_instance[count.index].ip_address.0.ip_address}" >> .env
    echo "DATABASE_USER=${google_sql_user.database_user[count.index].name}" >> .env
    echo "DATABASE_PASSWORD=${random_password.database_password.result}" >> .env
    echo "DATABASE_NAME=${var.database_name}" >> .env
    echo "WEBAPP_LOG_PATH=/var/log/webapplication/webapp.log" >> .env
    echo "TOPIC=${var.topic_name}" >> .env
    echo "NODE_ENV=${var.node_env_name}" >> .env

    else
        echo ".env file exists"
    fi

    # Reload systemctl daemon
    sudo systemctl daemon-reload
    EOF
  }


  service_account {
    email  = google_service_account.WebappServiceAccount.email
    scopes =  ["logging-write", "monitoring-write", "pubsub", "userinfo-email", "storage-ro", "compute-ro", "cloud-platform"]
  }

  labels = {
    gce-service-proxy = var.gce-service-proxy
  }
  depends_on = [google_compute_subnetwork.webapp, google_pubsub_topic.pubsub_topic, google_sql_database_instance.cloud_sql_instance]
}
resource "google_compute_region_instance_group_manager" "VMtemplate_mig1" {
  count                            = var.num_vpcs
  name                             = var.mig_name
  base_instance_name               = var.base_instance_name
  region                           = var.region
  distribution_policy_zones        = var.distribution_policy_zones
  distribution_policy_target_shape = var.distribution_policy_target_shape // not required; try even
  //target_pools       =  google_compute_target_pool.instance_group_target_pool[*].id

  version {
    instance_template = google_compute_region_instance_template.VMtemplate[0].self_link
  }

  named_port {
    name = var.named_port_name
    port = var.named_port
  }

  instance_lifecycle_policy {
     // 
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.webapp_health.self_link // check with id or self link
    initial_delay_sec = var.initial_delay_sec
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    google_compute_region_instance_template.VMtemplate,
    google_compute_health_check.webapp_health
  ]

}
resource "google_compute_region_autoscaler" "webapp_autoscaler" {
  count     = var.num_vpcs
  name   = var.webapp_autoscaler_name
  region = var.region
  target = google_compute_region_instance_group_manager.VMtemplate_mig1[count.index].id

  autoscaling_policy {
    //mode = "On: add and remove instances to the group"
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = var.cooldown_period

    cpu_utilization {
      target = var.cpu_utilization_target
    }
  }

}

resource "google_compute_health_check" "webapp_health" {
  name                = var.health_check_name
  check_interval_sec  = var.health_check_interval_sec
  timeout_sec         = var.heath_timeout_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  http_health_check {
    port_name = var.http_health_check_port_name
    request_path = var.http_health_check_request_path
    port         = var.http_health_check_port
  }
}

resource "google_compute_firewall" "healthz_firewall" {
  count     = var.num_vpcs
  name          = var.healthz_firewall_name
  direction     = var.healthz_firewall_direction
  network       = google_compute_network.vpc[count.index].self_link
  priority = var.allow_tcp_port_priority 
  source_ranges = var.healthz_firewall_source_ranges
  allow {
    protocol = var.healthz_allow_protocol
    ports = var.healthz_allow_ports
  }
  target_tags = var.target_tags
}


# forwarding rule
resource "google_compute_global_forwarding_rule" "instance_forward_rule" {
  count                 = var.num_vpcs
  name                  = var.instance_forward_rule_name
  ip_protocol           = var.fwd_rule_ip_protocol
  load_balancing_scheme = var.fwd_rule_load_balancing_scheme
  port_range            = var.fwd_rule_port_range
  target                = google_compute_target_https_proxy.instance_https[count.index].self_link
  ip_address            = google_compute_global_address.forward_address[count.index].id
  depends_on = [ google_compute_target_https_proxy.instance_https, google_compute_global_address.forward_address]

}

resource "google_compute_managed_ssl_certificate" "webapp_ssl" {
  name     = var.webapp_ssl_name

  managed {
    domains = var.managed_domains
  }
}



resource "google_compute_target_https_proxy" "instance_https" {
  count     = var.num_vpcs
  name     = var.webapp_target_proxy_name
  url_map  = google_compute_url_map.instance_url[count.index].id
  ssl_certificates = [
  google_compute_managed_ssl_certificate.webapp_ssl.self_link
  ]
  depends_on = [ google_compute_url_map.instance_url ]

}

# url map
resource "google_compute_url_map" "instance_url" {
  count     = var.num_vpcs
  name            = var.instance_url_name
  default_service = google_compute_backend_service.webapp_loadbalancer[count.index].self_link
}

# backend service with custom request and response headers
resource "google_compute_backend_service" "webapp_loadbalancer" {
  count     = var.num_vpcs
  name                    = var.lb_backend_service_name
  protocol                = var.lb_backend_service_protocol       
  port_name               = var.lb_backend_service_port_name 
  load_balancing_scheme   = var.load_balancing_scheme
  timeout_sec             = var.lb_timeout_sec 
  enable_cdn              = var.lb_enable_cdn
  health_checks           = [google_compute_health_check.webapp_health.self_link] 
  backend {
    group           = google_compute_region_instance_group_manager.VMtemplate_mig1[count.index].instance_group
    balancing_mode  = var.balancing_mode
    capacity_scaler = var.capacity_scaler
  }
}
