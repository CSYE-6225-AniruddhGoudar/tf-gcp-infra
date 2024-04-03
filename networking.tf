# Define provider configuration
provider "google" {
  credentials = file(var.service_account_path)
  project     = var.project_id
  region      = var.region
}

# Purpose: Create multiple VPCs for the project
resource "google_compute_network" "vpc" {
  for_each = {
    for idx in range(var.num_vpcs) : idx => {
      name                             = "vpc-${idx + 1}"
      auto_create_subnetworks          = var.auto_create_subnetworks
      routing_mode                     = var.routing_mode
      delete_default_routes_on_create = var.delete_default_routes_on_create
    }
  }

  name                             = each.value.name
  auto_create_subnetworks          = each.value.auto_create_subnetworks
  routing_mode                     = each.value.routing_mode
  delete_default_routes_on_create = each.value.delete_default_routes_on_create
}

# Create a subnet "webapp" for each VPC
resource "google_compute_subnetwork" "webapp" {
  #provider       = google // Check why
  count          = length(keys(google_compute_network.vpc))
  name           = var.num_vpcs > 1 ? (count.index == 0 ? var.webapp_subnet_name : "webapp-${count.index + 1}") : var.webapp_subnet_name
  ip_cidr_range  = var.num_vpcs > 1 ? (count.index == 0 ? var.webapp_subnet_cidr : "10.${count.index}.0.0/24") : var.webapp_subnet_cidr
  region         = var.region
  network        = google_compute_network.vpc[count.index].self_link
  //private_ip_google_access = true
}

# Create a "db" subnet for each VPC
resource "google_compute_subnetwork" "db" {
  #provider       = google // Check why
  count          = length(keys(google_compute_network.vpc))
  name           = var.num_vpcs > 1 ? (count.index == 0 ? var.db_subnet_name : "db-${count.index + 1}") : var.db_subnet_name
  ip_cidr_range  = var.num_vpcs > 1 ? (count.index == 0 ? var.db_subnet_cidr : "10.${count.index}.1.0/24") : var.db_subnet_cidr
  region         = var.region
  network        = google_compute_network.vpc[count.index].self_link
  private_ip_google_access = true //added
}


# Create a "loadbalancerSubnet" subnet for each VPC
resource "google_compute_subnetwork" "lb" {
  count          = length(keys(google_compute_network.vpc))
  name           = var.num_vpcs > 1 ? (count.index == 0 ? var.lb_subnet_name : "db-${count.index + 1}") : var.lb_subnet_name
  ip_cidr_range  = var.num_vpcs > 1 ? (count.index == 0 ? var.lb_subnet_cidr : "10.${count.index}.1.0/24") : var.lb_subnet_cidr
  region         = var.region
  network        = google_compute_network.vpc[count.index].self_link
  //private_ip_google_access = true //added
}

# Define routes for each VPC
resource "google_compute_route" "webapp_route" {
  count              = length(keys(google_compute_network.vpc))
  name               = var.num_vpcs > 1 ? (count.index == 0 ? "webapp-route" : "webapp-route-${count.index + 1}") : "webapp-route"
  network            = google_compute_network.vpc[count.index].self_link
  dest_range         = var.dest_range
  next_hop_gateway   = var.next_hop_gateway
  # Add other necessary attributes for the route
}

resource "google_dns_record_set" "webapp" {
  count        = var.num_vpcs  # Assuming you want to create a DNS record for each instance
  name         = var.dns_record_name
  type         = var.dns_record_type
  ttl          = var.dns_record_ttl
  managed_zone = var.dns_zone_name
  rrdatas      = [google_compute_global_address.forward_address[count.index].address]
  depends_on = [google_compute_global_address.forward_address, google_compute_global_address.internalIP]
}

resource "google_compute_firewall" "allow-webapp-firewall" {
  
  count = var.num_vpcs
  name    = "allow-firewall"
  network = google_compute_network.vpc[count.index].self_link
 
  allow {
    protocol = "tcp"
    ports = ["5432"]
  }

  source_ranges = ["10.2.0.0/28"]
  direction = "EGRESS"
  priority = 500
}