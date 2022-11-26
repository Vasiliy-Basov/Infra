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

variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable "db_disk_image" {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable "source_ranges" {
  description = "The source ip address range for an environment"
}

variable "prod_or_stage" {
  description = "Production or Stage Instances"
  default     = "prod"
}

variable "ssh_user" {
  type = string
  # Значение переменной
  # default = "baggurd"
}