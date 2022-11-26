# Правило файрвола для ssh доступа которое применимо для всех инстансов нашей сети.
# Посмотреть существующие правила firewall: gcloud compute firewall-rules list
# Импортируем правило файрвола из GCP в наш state файл чтобы управлять им из terraform:
# $ terraform import google_compute_firewall.firewall_ssh default-allow-ssh
# Теперь наше правило импортировано в state файл и мы можем управлять им:

resource "google_compute_firewall" "firewall_ssh" {
  name        = "default-allow-ssh"
  network     = "default"
  priority    = 65534
  description = "Allow SSH from anywhere"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = var.source_ranges
}

# Добавляем ssh ключ для подключения к нашим VM сам ключ находится в variables.tf
resource "google_compute_project_metadata" "ssh_keys" {
  metadata = {
    # ssh-keys = "baggurd:${var.public_key} baggurd"
    # ssh-keys = "baggurd:${file(var.public_key)}\nappuser2:${file(var.public_key)}"
    # chomp removes newline characters at the end of a string.
    # This can be useful if, for example, the string was read from a file that has a newline character at the end.
    ssh-keys = "baggurd:${chomp(file(var.public_key))}"
  }
}
