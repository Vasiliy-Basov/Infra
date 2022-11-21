terraform {
  # Версия terraform
  # required_version = "1.3.5"
  required_providers {
    google = {
      source = "hashicorp/google"  # Указываем провайдера терраформ
      # version = "~> 4.43.1"    # можем также указать версию провайдера
    }
  }
}

provider "google" {               # Указываем провайдера
  # ID проекта
  project = var.project
  region  = var.region
}

# Добавляем ssh ключ для подключения к нашим VM сам ключ находится в variables.tf
resource "google_compute_project_metadata" "ssh_keys" {
  metadata = {
    ssh-keys = "baggurd:${var.public_key} baggurd"
  }
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = var.zone
  tags = ["reddit-app"]  # можем определить теги

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "reddit-base"  # Также можно передать полное имя образа, например "reddit-base-1668709415"
      #  labels = {
      #    my_label = "value"  # можем определить labels
      #  }
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }
  # Определяем параметры подключения провиженеров к VM перед определением провиженеров
  connection {
    type = "ssh"
    user = "baggurd"
    agent = false
    #ip адрес хоста берется из файла terraform.tfstate также можно брать и другие переменные
    host = google_compute_instance.app.network_interface[0].access_config[0].nat_ip
    # путь до приватного ключа
    private_key = var.private_key
  }

  # Копируем файл с нашей локальной машины на удаленную
  provisioner "file" {
    source = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  # Запускаем скрипт для деплоя нашего приложения а также копирование в папку etc/systemd/system/ нашего приложения чтобы оно работало как служба
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

# Добавляем правило Firewall для нашего приложения
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  #Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}
