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

variable "source_ranges" {
  description = "The source ip address range for an environment"
}