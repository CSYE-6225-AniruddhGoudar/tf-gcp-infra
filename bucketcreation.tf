resource "google_storage_bucket" "auto-expire" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true

  public_access_prevention = "enforced"
  encryption {
    default_kms_key_name = google_kms_crypto_key.storage_crypto_key.id
  }
  depends_on = [ google_kms_crypto_key.storage_crypto_key ,
  google_kms_crypto_key_iam_binding.storage_binding]
}

resource "google_storage_bucket_object" "object" {
  name   = var.bucket_name
  bucket = google_storage_bucket.auto-expire.name
  source = var.object_source_path
}