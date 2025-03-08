# Определим внешний ip нашего инстанса из файла terraform.tfstate11 и поместим его в выходную переменную

#output "app_external_ip" {
#  value = google_compute_instance.app[*].network_interface[0].access_config[0].nat_ip
#}

#output "Global_Forwarding_Rule_IP" {
#  value = google_compute_forwarding_rule.loadbalancer.ip_address
#}

#output "db_external_ip" {
#  value = google_compute_instance.db[*].network_interface[0].access_config[0].nat_ip
#}

output "app_external_ip" {
  value = module.app.app_external_ip
}

output "db_external_ip" {
  value = module.db.db_external_ip
}

output "internal_ip_db" {
  value = module.intip.internal_ip_db
}

output "internal_ip_app" {
  value = module.intip.internal_ip_app
}

output "app_without_provisioning_external_ip" {
  value = module.app.app_without_provisioning_external_ip
}

output "db_without_provisioning_external_ip" {
  value = module.db.db_without_provisioning_external_ip
}
