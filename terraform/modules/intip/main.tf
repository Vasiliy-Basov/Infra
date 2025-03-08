resource "google_compute_address" "internal_ip_db" {
  name         = "internalipdb"
  address_type = "INTERNAL"
}

resource "google_compute_address" "internal_ip_app" {
  name         = "internalipapp"
  address_type = "INTERNAL"
}