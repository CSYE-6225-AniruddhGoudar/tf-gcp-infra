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
  count          = length(keys(google_compute_network.vpc))
  name           = var.num_vpcs > 1 ? (count.index == 0 ? var.webapp_subnet_name : "webapp-${count.index + 1}") : var.webapp_subnet_name
  ip_cidr_range  = var.num_vpcs > 1 ? (count.index == 0 ? var.webapp_subnet_cidr : "10.${count.index}.0.0/24") : var.webapp_subnet_cidr
  region         = var.region
  network        = google_compute_network.vpc[count.index].self_link
}

# Create a "db" subnet for each VPC
resource "google_compute_subnetwork" "db" {
  count          = length(keys(google_compute_network.vpc))
  name           = var.num_vpcs > 1 ? (count.index == 0 ? var.db_subnet_name : "db-${count.index + 1}") : var.db_subnet_name
  ip_cidr_range  = var.num_vpcs > 1 ? (count.index == 0 ? var.db_subnet_cidr : "10.${count.index}.1.0/24") : var.db_subnet_cidr
  region         = var.region
  network        = google_compute_network.vpc[count.index].self_link
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

