resource "google_kms_key_ring" "key_ring" {
  project = var.project_id
  name = var.key_ring_name
  location = var.region
  lifecycle {
    prevent_destroy = false
  }  
}

resource "google_kms_crypto_key" "vm_crypto_key" {
  name = var.vm_crypto_key
  key_ring = google_kms_key_ring.key_ring.id
  //key_ring = "webapp-key-ring4"
  rotation_period = var.rotation_period
  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key" "cloudsql_crypto_key" {
  name = var.cloudsql_crypto_key
  key_ring = google_kms_key_ring.key_ring.id
//key_ring = "webapp-key-ring4"
  rotation_period = var.rotation_period
  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key" "storage_crypto_key" {
    name = var.storage_crypto_key
    key_ring        = google_kms_key_ring.key_ring.id
    rotation_period = var.rotation_period
    lifecycle {
    prevent_destroy = false
  }
  
}

