resource "google_sql_database" "database" {
  count            = length(keys(google_compute_network.vpc))
  name     = var.database_name
  instance =  google_sql_database_instance.cloud_sql_instance[count.index].name
}