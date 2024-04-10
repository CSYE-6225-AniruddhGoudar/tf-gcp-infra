resource "google_sql_database_instance" "cloud_sql_instance" {
  count               = length(keys(google_compute_network.vpc))
  name                = "${var.sql_name}-${formatdate("YYYYMMDDHHMM00", timestamp())}"
  region              = var.region
  database_version    = var.database_version
  root_password       = var.root_password
  deletion_protection = var.deletion_protection
    

  

  settings {
    tier              = var.instance_tier
    availability_type = var.availability_type
    disk_type         = var.disk_type
    disk_size         = var.disk_size
    
  

    ip_configuration {
      ipv4_enabled                                  = var.ipv4_enabled
      private_network                               = google_compute_network.vpc[count.index].self_link
      enable_private_path_for_google_cloud_services = var.private_path
    }
  }
  encryption_key_name = google_kms_crypto_key.cloudsql_crypto_key.id
  
  
  depends_on = [google_compute_network.vpc, google_service_networking_connection.private_connection ]
}
