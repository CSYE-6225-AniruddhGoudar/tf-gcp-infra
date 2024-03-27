
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
