variable "public_key" {
  type = string
  # Значение переменной
  # default = "id_rsa.pub"
}

variable "source_ranges" {
  description = "Allowed IP addresses"
  #default = ["0.0.0.0/0"]
}
