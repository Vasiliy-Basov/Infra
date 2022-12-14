# Создаем внешний ip адрес для нашего instance
resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

# Включение provisioner в зависимости от переменной: Не знаю как сделать для script
# https://www.puppeteers.net/blog/conditional-provisioner-blocks-in-terraform/
#locals {
#  provisioner_commands1 = ["echo '[Unit]\nDescription=Puma HTTP Server\nAfter=network.target\n\n[Service]\nType=simple\nUser=${var.ssh_user}\nWorkingDirectory=/home/${var.ssh_user}/reddit\nExecStart=/bin/bash -lc 'puma'\nRestart=always\n\n[Install]\nWantedBy=multi-user.target' >> /tmp/puma.service"]
#  provisioner_commands2 = ["${path.module}/files/deploy.sh"]
#  provisioner_commands3 = [
#      "echo 'export DATABASE_URL=${var.internal_ip_db}' >> ~/.profile",
#      "export DATABASE_URL=${var.internal_ip_db}",
#      "sudo systemctl restart puma.service"
#    ]
#}

resource "google_compute_instance" "app" {
  # Создание ресурса в зависимости от переменной:
  count = var.enable_provisioners ? 1 : 0
  # Количество инстансов которое мы будем создавать для балансировки нагрузки
  # count = var.number_of_instances
  # автоматически добавляем к каждому новому инстансу следующий номер
  name         = "reddit-app-${var.prod_or_stage}"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["reddit-app", "http-server"] # можем определить теги если определяем тег http-server то gcp автоматически открывает порт 80
  labels = {
    ansible_group = "app"  # можем определить labels
    env           = "${var.prod_or_stage}"
  }

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = var.app_disk_image # Также можно передать полное имя образа, например "reddit-base-1668709415"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network    = "default"
    network_ip = var.internal_ip_app
    # использовать ephemeral IP для доступа из Интернет
    # access_config = {}
    # Использовать настроенный нами внешний статический ip:
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }

  # Определяем параметры подключения провиженеров к VM перед определением провиженеров
  connection {
    type  = "ssh"
    user  = var.ssh_user
    agent = false
    #ip адрес хоста берется из файла terraform.tfstate также можно брать и другие переменные
    host = self.network_interface[0].access_config[0].nat_ip
    # путь до приватного ключа
    private_key = file(var.private_key)
  }
  # Копируем файл с нашей локальной машины на удаленную
  #  provisioner "file" {
  #    source      = "../../files/puma.service"
  #    destination = "/tmp/puma.service"
  #  }
  # Если хотим внести переменные в конфиг то заполняем наш конфиг построчно:
  provisioner "remote-exec" {
    inline = ["echo '[Unit]\nDescription=Puma HTTP Server\nAfter=network.target\n\n[Service]\nType=simple\nUser=${var.ssh_user}\nWorkingDirectory=/home/${var.ssh_user}/reddit\nExecStart=/bin/bash -lc 'puma'\nRestart=always\n\n[Install]\nWantedBy=multi-user.target' >> /tmp/puma.service"]
#     inline = concat(["echo Provisioning"], [for command in local.provisioner_commands1: command if var.enable_provisioners])
  }
  # Запускаем скрипт для деплоя нашего приложения а также копирование в папку etc/systemd/system/ нашего приложения чтобы оно работало как служба
  # ${path.module} - означает что наш путь до файла будет начинаться всегда из корня модуля, неважно где мы этот модуль запускаем
  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
#    script = [for command in local.provisioner_commands2: command if var.enable_provisioners]
  }
  # Приложение в процессе работы использует БД, указанную в переменной окружения DATABASE_URL, нам нужно создать эту переменную
  # Команда export создает переменную для текущей оболочки и всех дочерних процессов так же помещаем переменную в ~/.profile
  provisioner "remote-exec" {
    inline = [
      "echo 'export DATABASE_URL=${var.internal_ip_db}' >> ~/.profile",
      "export DATABASE_URL=${var.internal_ip_db}",
      "sudo systemctl restart puma.service"
    ]
#     inline = concat(["echo Provisioning"], [for command in local.provisioner_commands3: command if var.enable_provisioners])
  }
  #  metadata = {
  #    ssh-keys = "baggurd:${chomp(file(var.public_key))}"
  #  }
}

resource "google_compute_instance" "app_without_provisioning" {
  count        = var.enable_provisioners ? 0 : 1
  # Количество инстансов которое мы будем создавать для балансировки нагрузки
  # count = var.number_of_instances
  # автоматически добавляем к каждому новому инстансу следующий номер
  name         = "reddit-app-${var.prod_or_stage}"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["reddit-app", "http-server"] # можем определить теги если определяем тег http-server то gcp автоматически открывает порт 80
  labels       = {
    ansible_group = "app"  # можем определить labels, определяем для того чтобы собирать dynamic inventory в ansible через переменную ansible_group
    env           = "${var.prod_or_stage}" # делаем метку чтобы понимать наше окружение stage или prod для использования в ansible
  }

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = var.app_disk_image # Также можно передать полное имя образа, например "reddit-base-1668709415"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network    = "default"
    network_ip = var.internal_ip_app
    # использовать ephemeral IP для доступа из Интернет
    # access_config = {}
    # Использовать настроенный нами внешний статический ip:
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }

  # Определяем параметры подключения провиженеров к VM перед определением провиженеров
  connection {
    type        = "ssh"
    user        = var.ssh_user
    agent       = false
    #ip адрес хоста берется из файла terraform.tfstate также можно брать и другие переменные
    host        = self.network_interface[0].access_config[0].nat_ip
    # путь до приватного ключа
    private_key = file(var.private_key)
  }
}


# Добавляем правило Firewall для нашего приложения app
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  #Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тегами
  target_tags = ["reddit-app"]
}
