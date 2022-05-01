resource "google_kms_key_ring" "keyring" {
  for_each = local.projects_data
  project  = each.value.project_id
  name     = each.value.labels.environment
  location = "global"
}

resource "google_kms_crypto_key" "key" {
  for_each = local.projects_data
  name     = "encrypt_decrypt-${each.value.labels.environment}"
  key_ring = google_kms_key_ring.keyring[each.value.labels.environment].id
  purpose  = "ENCRYPT_DECRYPT"
  labels   = {}

  #destroy_scheduled_duration = "10368000s" # 120 days
  destroy_scheduled_duration = "5s" # 120 days

  lifecycle {
    #prevent_destroy = true
    prevent_destroy = false
  }
}

