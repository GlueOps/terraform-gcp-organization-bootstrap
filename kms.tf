resource "google_kms_key_ring" "keyring" {
  for_each = local.environments
  project  = each.value.project_id
  name     = each.value.labels.environment
  location = "global"
}

resource "google_kms_crypto_key" "key" {
  #for_each = local.environments
  name     = "encrypt_decrypt-${each.value.labels.environment}"
  key_ring = google_kms_key_ring.keyring["development"].id
  purpose  = "ENCRYPT_DECRYPT"
  labels   = {}

  destroy_scheduled_duration = 4320

  lifecycle {
    prevent_destroy = true
  }
}

