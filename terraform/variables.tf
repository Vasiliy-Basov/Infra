variable "public_key" {
  type = string
  # Значение переменной
  # default = "id_rsa.pub"
}

variable "project" {
  # Описание переменной
  description = "Project ID"
  # default     = "infra-368512"
}

variable "region" {
  description = "Region"
  # Значение по умолчанию
  # default = "europe-west1"
}

variable "private_key" {
  # Значение
  type = string
  # default = "id_rsa"
}

variable "zone" {
  # zone location for google_compute_instance app
  description = "Zone location"
  # default     = "europe-west1-b"
}

variable "disk_image" {
  description = "Disk image"
}

variable "number_of_instances" {
  description = "Number of reddit-app instances (count)"
  default     = 1
}