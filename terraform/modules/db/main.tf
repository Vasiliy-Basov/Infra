resource "google_compute_instance" "db" {
  # Создание ресурса в зависимости от переменной:
  count = var.enable_provisioners ? 1 : 0
  name         = "reddit-db-${var.prod_or_stage}"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["reddit-db"]
  labels = {
    ansible_group = "db"  # можем определить labels
  }
  boot_disk {
    initialize_params {
      image = var.db_disk_image
    }
  }
  network_interface {
    network    = "default"
    network_ip = var.internal_ip_db
    access_config {} # Если не хотим получать внешний ip то просто комментируем access_config
  }

  connection {
    type  = "ssh"
    user  = var.ssh_user
    agent = false
    #ip адрес хоста берется из файла terraform.tfstate также можно брать и другие переменные
    host = self.network_interface[0].access_config[0].nat_ip
    # путь до приватного ключа
    private_key = file(var.private_key)
  }
  # По умолчанию, MongoDB слушает порт 27017 только на 127.0.0.1, Конфигурация базы лежит в etc/monog.conf
  # Замена конфигурации в файле делаем с помощью редактора sed:
  # -i - означает что мы заменяем исходный файл
  # s в кавычках означает что мы производим замену тескта 127.0.0.1 на 0.0.0.0
  # g в кавычках означает что sed заменит все совпадения в файле
  # Мы должны заменить на адрес network adapter-а сервера db
  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's/127.0.0.1/${var.internal_ip_db}/g' /etc/mongod.conf",
      "sudo systemctl restart mongod.service",
    ]
  }


  #  metadata = {
  #    ssh-keys = "baggurd:${chomp(file(var.public_key))}"
  #  }
}

resource "google_compute_instance" "db_without_provisioning" {
  # Создание ресурса в зависимости от переменной:
  count        = var.enable_provisioners ? 0 : 1
  name         = "reddit-db-${var.prod_or_stage}"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["reddit-db"]
  labels       = {
    ansible_group = "db"  # можем определить labels
  }
  boot_disk {
    initialize_params {
      image = var.db_disk_image
    }
  }
  network_interface {
    network    = "default"
    network_ip = var.internal_ip_db
    access_config {}
    # Если не хотим получать внешний ip то просто комментируем access_config
  }
}

# Правило firewall для db
resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}
