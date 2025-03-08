output "internal_ip_app" {
  value = google_compute_address.internal_ip_app.address
}

output "internal_ip_db" {
  value = google_compute_address.internal_ip_db.address
}