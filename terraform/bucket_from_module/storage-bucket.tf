# Создание Bucket ов из готового модуля который опубликован
# https://registry.terraform.io/modules/SweetOps/storage-bucket/google/latest

terraform {
  # Версия terraform
  # required_version = "1.3.5"
  required_providers {
    google = {
      source  = "hashicorp/google" # Указываем провайдера терраформ
      version = "~> 4.43.1"        # можем также указать версию провайдера
    }
  }
}

# Указываем провайдера
provider "google" {
  # ID проекта
  project = var.project
  region  = var.region
}

# Модуль storage-bucket позволяет создавать бакеты в хранилище GCP
# https://registry.terraform.io/modules/SweetOps/storage-bucket/google/latest

module "storage-bucket" {
  source             = "git::https://github.com/SweetOps/terraform-google-storage-bucket.git?ref=master"
  name               = "bucket-one"
  location           = "europe-west1"
  stage              = "stage"
  enabled            = true
  versioning_enabled = true
}

output "storage-bucket_url" {
  value = module.storage-bucket.url
}
