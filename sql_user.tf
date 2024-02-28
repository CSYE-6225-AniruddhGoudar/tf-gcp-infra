resource "google_sql_user" "database_user" {
  count            = length(keys(google_compute_network.vpc))
  name     = var.database_user
  instance =  google_sql_database_instance.cloud_sql_instance[count.index].name //check for instance to be db 
  password = random_password.database_password.result
}

resource "random_password" "database_password" {
  length  = 10
  special = true
}