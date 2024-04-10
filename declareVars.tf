
# Define input variables
variable "num_vpcs" {
  description = "Number of VPCs to create"
  type        = number
}

variable "auto_create_subnetworks" {
  description = "Auto-create subnetworks in the VPC"
  type        = bool
}

variable "routing_mode" {
  description = "Mode for the VPC"
  type        = string
}

variable "delete_default_routes_on_create" {
  description = "Delete default routes on VPC creation"
  type        = bool
}

variable "webapp_subnet_cidr" {
  description = "Range for the webapp subnet CIDR"
  type        = string
}

variable "db_subnet_cidr" {
  description = "Range for the db subnet CIDR"
  type        = string
}

variable "dest_range" {
  description = "Destination IP route"
  type        = string
}

variable "next_hop_gateway" {
  description = "Next hop gateway for the route"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
}

variable "service_account_path" {
  description = "Key path for service account"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "webapp_subnet_name" {
  description = "Webapp subnet name to be created"
  type        = string
}

variable "db_subnet_name" {
  description = "db subnet name to be created"
  type        = string
}

variable "machine_type" {
  description = "machine type details"
  type        = string
}

variable "hostname" {
  description = "hostname of a VM "
  type        = string
}

variable "allow_stopping_for_update" {
  description = "Update allow "
  type        = bool
}

variable "image" {
  description = "image name here"
  type        = string
}

variable "type"{
  description = "image type"
  type        = string
}

variable "size"{
  description = "image disk size"
  type        = number
}

variable "protocol"{
  description = "protocol"
  type        = string
}

variable "allow_tcp_port"{
  description = "allow_tcp_port"
  type        = list(number)
}

variable "deny_ssh_port"{
  description = "deny_ssh_port"
  type        = list(number)
}

variable "source_ranges"{
  description = "source_ranges"
  type        = list(string)
}

variable "target_tags"{
  description = "target_tags"
  type        = list(string)
}

variable "database_name" {
  description = "The Cloud SQL database name"
  type        = string
}
variable "database_user" {
  description = "The Cloud SQL user name"
  type        = string
}

variable "sql_name" {
  description = "The Cloud SQL instance name with timestamp"
  type        = string
  
}
variable "private_path" {
  description = "The Cloud SQL instance private path "
  type        = bool
  
}
locals {
  current_timestamp = formatdate("YYYYMMDDHHMMSS", timestamp())
}
variable "root_password" {
  description = "The root password for the Cloud SQL instance"
  type        = string
}
variable "database_version" {
  description = "The database version for the Cloud SQL instance"
  type        = string
}
variable "deletion_protection" {
  description = "Whether deletion protection is enabled for the Cloud SQL instance"
  type        = bool
}

variable "availability_type" {
  description = "The availability type for the Cloud SQL instance"
  type        = string
}

variable "disk_type" {
  description = "The disk type for the Cloud SQL instance"
  type        = string
}

variable "disk_size" {
  description = "The disk size for the Cloud SQL instance"
  type        = number
}

variable "ipv4_enabled" {
  description = "Whether IPv4 is enabled for the Cloud SQL instance"
  type        = bool
}

variable "allow_tcp_port_priority" {
  description = "allow_tcp_port_priority"
  type        = number
}

variable "deny_ssh_port_priority" {
  description = "deny_ssh_port_priority"
  type        = number
}

variable "vm_name" {
  description = "vm_name"
  type        = string
}

variable "internal_ip_name" {
  description = "internal_ip_name"
  type        = string
}

variable "rule_name" {
  description = "rule_name"
  type        = string
}

variable "internal_ip_address_type" {
  description = "internal_ip_address_type"
  type        = string
}

variable "internal_ip_purpose" {
  description = "internal_ip_purpose"
  type        = string
}

variable "rule_target" {
  description = "rule_target"
  type        = string
}

variable "connection_service" {
  description = "connection_service"
  type        = string
}

variable "instance_tier" {
  description = "instance_tier"
  type        = string
}

variable "dns_zone_name" {
  description = "dns-zone-name"
  type = string
}

variable "dns_record_name" {
  description = "dns_record_name"
  type = string
}

variable "dns_record_type" {
  description = "dns_record_type"
  type = string
}

variable "dns_record_ttl" {
  description = "dns_record_ttl"
  type = number
}

variable "account_id" {
  description = "account_id"
  type = string
}

variable "loggingAdminRole" {
  description = "loggingAdminRole"
  type = string
}

variable "monitoringMetricWriterRole" {
  description = "monitoringMetricWriterRole"
  type = string
}

variable "display_name" {
  description = "display_name"
  type = string
}

variable "topic_name" {
  description = "topic_name"
  type = string
}

variable "node_env_name" {
  description = "node_env_name"
  type = string
}

variable "topic_subscription" {
  description = "topic_subscription"
  type = string
  
}

variable "message_retention_duration" {
  description = "message_retention_duration"
  type = string
}

variable "retain_acked_messages" {
  description = "retain_acked_messages"
  type = bool
}

variable "ack_deadline_seconds" {
  description = "ack_deadline_seconds"
  type = number
}

variable "publisher_role" {
  description = "publisher_role"
  type = string
  
}

variable "vpc_connector_name" {
  description = "publisher_role"
  type = string
}

variable "vpc_connector_cidr"{
  description = "vpc_connector_cidr"
  type = string
}

variable "vpc_connector_machine_type"{
  description = "vpc_connector_machine_type"
  type = string
}

variable "cloudsql_client_role" {
  description = "The Cloud SQL client role to assign"
  type        = string
}

variable "cloudsql_admin_role" {
  description = "The Cloud SQL admin role to assign"
  type        = string
}

variable "iam_service_account_token_creator_role" {
  description = "The IAM Service Account Token Creator role to assign"
  type        = string
}

variable "cloudsql_editor_role" {
  description = "The Cloud SQL editor role to assign"
  type        = string
 
}

variable "artifact_registry_writer_role" {
  description = "The Artifact Registry writer role to assign"
  type        = string
}

variable "cloudfunctions_developer_role" {
  description = "The Cloud Functions developer role to assign"
  type        = string
 
}

variable "logging_admin_role" {
  description = "The Logging admin role to assign"
  type        = string
 
}

variable "storage_object_admin_role" {
  description = "The Storage object admin role to assign"
  type        = string
 
}

variable "cloud_run_invoker_role" {
  description = "The Cloud Run invoker role to assign"
  type        = string
  
}

variable "logging_log_writer_role" {
  description = "The Logging log writer role to assign"
  type        = string
  
}

variable "entry_point"{
  description = "entry_point"
  type = string
}

variable "nodejs_version" {
  description = "nodejs_version"
  type = string
}

variable "cloud_function_name" {
  description = "cloud_function_name"
  type = string
}

variable "source_archive_bucket" {
  description = "source_archive_bucket"
  type = string
}

variable "source_archive_object" {
  description = "source_archive_object"
  type = string
}

variable "template_name"{
  description = "template_name"
  type = string
}

variable "lb_subnet_name"{
  description = "lb_subnet_name"
  type = string
}

variable "lb_subnet_cidr"{
  description = "lb_subnet_cidr"
  type = string
}

variable "can_ip_forward"{
  description = "can_ip_forward"
  type = bool
}
/////////////////////////////////////////////

variable "disk_auto_delete"{
  description = "disk_auto_delete"
  type = bool
}

variable "disk_boot"{
  description = "disk_boot"
  type = bool
}

variable "disk_size_gb"{
  description = "disk_size_gb"
  type = number
}

variable "reservation_affinity_type"{
  description = "reservation_affinity_type"
  type = string
}

variable "scheduling_preemptible"{
  description = "scheduling_preemptible"
  type = bool
}

variable "scheduling_automatic_restart"{
  description = "scheduling_preemptible"
  type = bool
}

variable "gce-service-proxy"{
  description = "gce-service-proxy"
  type = string
}

variable "mig_name"{
  description = "mig_name"
  type = string
}



variable "distribution_policy_target_shape"{
  description = "scheduling_preemptible"
  type = string
}

variable "distribution_policy_zones"{
  description = "gce-service-proxy"
  type = list(string)
}

variable "base_instance_name"{
  description = "base_instance_name"
  type = string
}


variable "named_port_name"{
  description = "named_port_name"
  type = string
}

variable "named_port"{
  description = "gce-service-proxy"
  type = number
}

variable "initial_delay_sec"{
  description = "mig_name"
  type = number
}



# variable "create_before_destroy"{
#   description = "named_port_name"
#   type = bool
# }

variable "webapp_autoscaler_name"{
  description = "gce-service-proxy"
  type = string
}

variable "max_replicas"{
  description = "mig_name"
  type = number
}


variable "min_replicas"{
  description = "named_port_name"
  type = number
}

variable "cooldown_period"{
  description = "gce-service-proxy"
  type = number
}

variable "cpu_utilization_target"{
  description = "mig_name"
  type = number
}


variable "health_check_name"{
  description = "named_port_name"
  type = string
}

variable "health_check_interval_sec"{
  description = ""
  type = number
}

variable "heath_timeout_sec"{
  description = "mig_name"
  type = number
}

variable "healthy_threshold"{
  description = "named_port_name"
  type = number
}

variable "unhealthy_threshold"{
  description = "gce-service-proxy"
  type = number
}

variable "http_health_check_port_name"{
  description = "mig_name"
  type = string
}


variable "http_health_check_request_path"{
  description = "named_port_name"
  type = string
}

variable "http_health_check_port"{
  description = "gce-service-proxy"
  type = number
}

variable "healthz_firewall_name"{
  description = "mig_name"
  type = string
}


variable "healthz_firewall_direction"{
  description = "mig_name"
  type = string
}


variable "healthz_firewall_source_ranges"{
  description = "named_port_name"
  type = list(string)
}

variable "healthz_allow_protocol"{
  description = "gce-service-proxy"
  type = string
}

variable "healthz_allow_ports"{
  description = "mig_name"
  type = list(string)
}


variable "instance_forward_rule_name"{
  description = "mig_name"
  type = string
}


variable "fwd_rule_ip_protocol"{
  description = "named_port_name"
  type = string
}

variable "fwd_rule_load_balancing_scheme"{
  description = "gce-service-proxy"
  type = string
}

variable "fwd_rule_port_range"{
  description = "mig_name"
  type = number
}

variable "webapp_ssl_name"{
  description = ""
  type = string
}


variable "managed_domains"{
  description = "named_port_name"
  type = list(string)
}

variable "webapp_target_proxy_name"{
  description = ""
  type = string
}

variable "instance_url_name"{
  description = "mig_name"
  type = string
}



variable "lb_backend_service_name"{
  description = "named_port_name"
  type = string
}

variable "lb_backend_service_protocol"{
  description = "gce-service-proxy"
  type = string
}

variable "lb_backend_service_port_name"{
  description = "mig_name"
  type = string
}


variable "load_balancing_scheme"{
  description = "named_port_name"
  type = string
}

variable "lb_timeout_sec"{
  description = "gce-service-proxy"
  type = number
}

variable "lb_enable_cdn"{
  description = "mig_name"
  type = bool
}

variable "balancing_mode"{
  description = "balancing_mode"
  type = string
}

variable "capacity_scaler"{
  description = "mig_name"
  type = number
}

variable "MAILGUN_API_KEY"{
  description = "mig_name"
  type = string
}


variable "DOMAIN_NAME"{
  description = "balancing_mode"
  type = string
}

variable "MAILGUN_FROM_EMAIL"{
  description = "mig_name"
  type = string
}

variable "VERIFICATION_LINK"{
  description = "mig_name"
  type = string
}


variable "allow_ssh_port_priority"{
  description = "allow_ssh_port_priority"
  type = number
}

variable "key_ring_name"{
  description = "key_ring_name"
  type = string
}

variable "vm_crypto_key"{
  description = "vm_crypto_key"
  type = string
}


variable "cloudsql_crypto_key"{
  description = "cloudsql_crypto_key"
  type = string
}


variable "storage_crypto_key"{
  description = "storage_crypto_key"
  type = string
}

variable "rotation_period"{
  description = "rotation_period"
  type = string
}

variable "bucket_name"{
  description = "bucket_name"
  type = string
}

variable "object_source_path"{
  description = "object_source_path"
  type = string
}

variable "object_name"{
  description = "object_name"
  type = string
}

variable "service"{
  description = "service"
  type = string
}

variable "cloudSqlRole"{
  description = "cloudSqlRole"
  type = string
}

variable "bindingrole"{
  description = "bindingrole"
  type = string
}

