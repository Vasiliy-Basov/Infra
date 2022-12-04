variable "public_key" {
  type = string
  # Значение переменной
  # default = "id_rsa.pub"
}

variable "private_key" {
  type = string
  # Значение переменной
  # default = "id_rsa.pub"
}
variable "zone" {
  # zone location for google_compute_instance app
  description = "Zone location"
  # default     = "europe-west1-b"
}

variable "db_disk_image" {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable "prod_or_stage" {
  description = "Production or Stage Instances"
  default     = "stage"
}

variable "ssh_user" {
  type = string
  # Значение переменной
  # default = "baggurd"
}

variable "internal_ip_app" {
  description = "Application Internal ip Address"
  default     = "0.0.0.0"
}

variable "internal_ip_db" {
  description = "Db Internal ip Address"
  default     = "0.0.0.0"
}

variable "enable_provisioners" {
  description = "If set to true, enable provisionigs"
  type = bool
  default = true
}
