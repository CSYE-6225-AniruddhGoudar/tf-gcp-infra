# [START compute_internal_ip_private_access]
resource "google_compute_global_address" "internalIP" {
  count         = length(keys(google_compute_network.vpc))
  project       = var.project_id
  name          = var.internal_ip_name
  address_type  = var.internal_ip_address_type
  purpose       = var.internal_ip_purpose
  network       = google_compute_network.vpc[count.index].self_link
  prefix_length = 16  # Example value, replace with the correct prefix length for your subnet
}

# [END compute_internal_ip_private_access]

# [START compute_forwarding_rule_private_access]
# resource "google_compute_global_forwarding_rule" "rule" {
#   count                = length(keys(google_compute_network.vpc))
#   project              = var.project_id
#   name                 = var.rule_name
#   target               = var.rule_target
#   network              = google_compute_network.vpc[count.index].self_link
#   ip_address           = google_compute_global_address.internalIP[count.index].address  # Use the address attribute
#   load_balancing_scheme = ""  # Example value, replace with your desired load balancing scheme
# }

# [END compute_forwarding_rule_private_access]

# Establish private access connections for each VPC to Google Service Networking
resource "google_service_networking_connection" "private_connection" {
  count                  = length(keys(google_compute_network.vpc))
  network                = google_compute_network.vpc[count.index].self_link
  service                = var.connection_service
  reserved_peering_ranges = [google_compute_global_address.internalIP[count.index].name]
  depends_on             = [
    google_compute_global_address.internalIP,
    google_compute_network.vpc
  ]
}

resource "null_resource" "dependency_setter" {
  depends_on = [google_service_networking_connection.private_connection]
}