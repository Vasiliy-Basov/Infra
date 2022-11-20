# Определим внешний ip нашего инстанса из файла terraform.tfstate и поместим его в выходную переменную
output "app_eternal_ip" {
  value = google_compute_instance.app.network_interface[0].access_config[0].nat_ip
}