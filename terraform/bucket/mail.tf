# Это плагин который генерирует random id:
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name          = "prod-bucket-${random_id.bucket_prefix.hex}"
  force_destroy = false      # не даст удалить bucket пока не удалим все внутренние объекты
  location      = "EU"       # https://cloud.google.com/storage/docs/locations
  storage_class = "STANDARD" # Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE
  project       = "infra-368512"
  versioning { # При изменении объекта старые версии сохраняются
    enabled = true
  }
}