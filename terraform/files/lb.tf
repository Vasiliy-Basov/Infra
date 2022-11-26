# Creation of a Load Balancer
# https://www.terraform.io/docs/providers/google/r/compute_forwarding_rule.html
# https://debugthis.dev/k8s/thehardway/2021-05-12-k8s-thw-gcp-tf-network/

# Создаем внешний ip адрес для нашего балансировщика
resource "google_compute_address" "external_ip_address" {
  name = "external-public-address"
}

resource "google_compute_http_health_check" "default" {
  name = "default"
  #	request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port               = 9292
}

# Создаем Target Pool который ассоциируется со всеми нашими инстансами
resource "google_compute_target_pool" "loadbalancer" {
  name          = "loadbalancer"
  instances     = google_compute_instance.app.*.self_link
  health_checks = [google_compute_http_health_check.default.name]
}

# Создаем правило для балансировки нагрузки
resource "google_compute_forwarding_rule" "loadbalancer" {
  name       = "loadbalancer"
  target     = google_compute_target_pool.loadbalancer.self_link
  port_range = "9292"
  ip_address = google_compute_address.external_ip_address.address
}
