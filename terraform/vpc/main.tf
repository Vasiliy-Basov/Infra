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


module "vpc" {
  source        = "../modules/vpc"
  public_key    = var.public_key
  source_ranges = var.source_ranges
}


