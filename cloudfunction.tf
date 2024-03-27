# Define Pub/Sub Topic
resource "google_pubsub_topic" "pubsub_topic" {
  name = var.topic_name
  project = var.project_id
}

# Define Pub/Sub Subscription
resource "google_pubsub_subscription" "pubsub_subscription" {
  project = var.project_id
  name   = var.topic_subscription
  topic  = google_pubsub_topic.pubsub_topic.name
  message_retention_duration = var.message_retention_duration
  retain_acked_messages      = var.retain_acked_messages
  ack_deadline_seconds = var.ack_deadline_seconds
  
}

# Define IAM Role for Publishing Messages to Pub/Sub Topic
resource "google_project_iam_binding" "pubsub_publisher_role_binding" {
  project = var.project_id
  role    = var.publisher_role
  members = [
    "serviceAccount:${google_service_account.WebappServiceAccount.email}"
  ]
  depends_on = [google_service_account.WebappServiceAccount]
}

# Define VPC Connector
resource "google_vpc_access_connector" "cloud_function_connector" {
  count = var.num_vpcs
  name    = var.vpc_connector_name
  network = google_compute_network.vpc[count.index].self_link
  ip_cidr_range = var.vpc_connector_cidr
  machine_type  = var.vpc_connector_machine_type
  min_instances = 2
  max_instances = 10
  region = var.region
}

# Define Cloud Function
# resource "google_cloudfunctions2_function" "verify_email_function" {
#   name        = "verify_email_function"
#   location = var.region
#   count    = var.num_vpcs
#   build_config{
#   runtime     = "nodejs20"
  # entry_point = "emailVerificationHandler"
  # environment_variables = {
  #   SQL_INSTANCE_CONNECTION_NAME = google_sql_database_instance.cloud_sql_instance[count.index].connection_name
  #   DATABASE_HOST                   = google_sql_database_instance.cloud_sql_instance[count.index].ip_address.0.ip_address,
  #   DATABASE_USER                      = google_sql_user.database_user[count.index].name
  #   DATABASE_PASSWORD                  = random_password.database_password.result
  #   DATABASE_NAME                      = var.database_name
  #   //webappLogs     = "/var/log/webapplication/csye6225.log"
  # }
  # source {
  #     storage_source {
  #       bucket = "cloudfunction1"
  #       object = "serverless1.zip"
  #     }
  #   }
  # }
  #   service_config {
  #   min_instance_count            = 1
  #   max_instance_count            = 2
  #   available_memory              = "256M"
  #   timeout_seconds               = 60
  #   #vpc_connector                 = google_vpc_access_connector.connector[count.index].self_link
  #   vpc_connector = google_vpc_access_connector.cloud_function_connector[count.index].self_link
  #   vpc_connector_egress_settings = "ALL_TRAFFIC"
  #   service_account_email         = google_service_account.WebappServiceAccount.email
  #   all_traffic_on_latest_revision = true
  # }

  # timeout     = "60"
  # available_memory_mb   = 256
  # vpc_connector = google_vpc_access_connector.cloud_function_connector.name

  # event_trigger {
  #   trigger_region = var.region
  #   event_type = "google.cloud.pubsub.topic.v1.messagePublished"
  #   pubsub_topic =   google_pubsub_topic.pubsub_topic.name
  #   retry_policy   = "RETRY_POLICY_RETRY"
  # }
# }
  # source_archive_bucket   = "bucketwebapp"
  # source_archive_object   = "serverless1.zip"

resource "google_cloudfunctions_function" "verify_email_function" {
  name        = "verify_email_function"
  runtime     = "nodejs20"
  count    = var.num_vpcs
  source_archive_bucket = "bucketwebapp"
  source_archive_object = "serverless1.zip"
  entry_point = "handleEmailVerification"
  timeout     = "60"
  available_memory_mb   = 256
  service_account_email         = google_service_account.WebappServiceAccount.email
  event_trigger {
    
    event_type = "google.pubsub.topic.publish"
    resource=    google_pubsub_topic.pubsub_topic.name
  }
    vpc_connector = google_vpc_access_connector.cloud_function_connector[count.index].name


  environment_variables = {
    SQL_INSTANCE_CONNECTION_NAME = google_sql_database_instance.cloud_sql_instance[count.index].connection_name
    DATABASE_HOST                   = google_sql_database_instance.cloud_sql_instance[count.index].ip_address.0.ip_address,
    DATABASE_USER                      = google_sql_user.database_user[count.index].name
    DATABASE_PASSWORD                  = random_password.database_password.result
    DATABASE_NAME                      = var.database_name
  }
}


# # Define IAM Binding for Cloud Function
# resource "google_cloudfunctions_function_iam_binding" "verify_email_function_binding" {
#   count       = var.num_vpcs
#   project     = var.project_id
#   region    = var.region
#   cloud_function = google_cloudfunctions2_function.verify_email_function[count.index].name
#   role        = "roles/cloudfunctions.invoker"
#   members     = [
#     "serviceAccount:${google_service_account.WebappServiceAccount.email}"
#   ]
# }

# resource "google_cloud_run_service_iam_binding" "verify_email_function_binding" {
#   project = google_pubsub_topic.pubsub_topic.project
#   count    = var.num_vpcs
#   location =  var.region
  
#   service = google_cloudfunctions_function.verify_email_function[count.index].name
#    role        = "roles/cloudfunctions.invoker"
#   members     = [
#     "serviceAccount:${google_service_account.WebappServiceAccount.email}"
#   ]
#    depends_on = [google_service_account.WebappServiceAccount, google_pubsub_topic.pubsub_topic]

# }
resource "google_project_iam_binding" "cloud_sql_role_binding" {
  project = var.project_id
  role    = var.cloudsql_client_role
  members = ["serviceAccount:${google_service_account.WebappServiceAccount.email}"]
}

resource "google_project_iam_binding" "cloud_sql_admin_role_binding" {
  project = var.project_id
  role    = var.cloudsql_admin_role
  members = ["serviceAccount:${google_service_account.WebappServiceAccount.email}"]
}

resource "google_project_iam_binding" "creatorBinding" {
  project = var.project_id
  role    = var.iam_service_account_token_creator_role
  members = ["serviceAccount:${google_service_account.WebappServiceAccount.email}"]
}

resource "google_project_iam_member" "roleBinding" {
  project = var.project_id
  role    = var.cloudsql_editor_role
  member  =  "serviceAccount:${google_service_account.WebappServiceAccount.email}"
}

resource "google_project_iam_binding" "artifact_registry_binding" {
  project = var.project_id
  role    = var.artifact_registry_writer_role
  members = ["serviceAccount:${google_service_account.WebappServiceAccount.email}"]
}

resource "google_project_iam_binding" "cloud_functions_binding" {
  project = var.project_id
  role    = var.cloudfunctions_developer_role
  members = ["serviceAccount:${google_service_account.WebappServiceAccount.email}"]
}

resource "google_project_iam_binding" "logging_binding" {
  project = var.project_id
  role    = var.logging_admin_role
  members = ["serviceAccount:${google_service_account.WebappServiceAccount.email}"]
}

resource "google_project_iam_binding" "storage_binding" {
  project = var.project_id
  role    = var.storage_object_admin_role
  members = ["serviceAccount:${google_service_account.WebappServiceAccount.email}"]
}

resource "google_project_iam_binding" "cloud_run_binding" {
  project = var.project_id
  role    = var.cloud_run_invoker_role
  members = ["serviceAccount:${google_service_account.WebappServiceAccount.email}"]
}

resource "google_project_iam_binding" "logs_writer_binding" {
  project = var.project_id
  role    = var.logging_log_writer_role
  members = ["serviceAccount:${google_service_account.WebappServiceAccount.email}"]
}