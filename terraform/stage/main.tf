terraform {
  # Версия terraform
  # required_version = "1.3.5"
  required_providers {
    google = {
      source  = "hashicorp/google" # Указываем провайдера терраформ
      version = "~> 4.43.1"        # можем также указать версию провайдера
    }
  }
}

# Указываем провайдера
provider "google" {
  # ID проекта
  project = var.project
  region  = var.region
}
# Если есть переменные в каталоге modules/.../variables.tf мы их должны тут прописывать или определять их значение через default
# в каталоге modules/.../variables.tf
# Мы можем явно задавать здесь значения этих переменных и они будут передаваться при вызове модуля
module "app" {
  source          = "../modules/app"
  zone            = var.zone
  app_disk_image  = var.app_disk_image
  public_key      = var.public_key
  prod_or_stage   = var.prod_or_stage
  private_key     = var.private_key
  ssh_user        = var.ssh_user
  internal_ip_db  = module.intip.internal_ip_db
  internal_ip_app = module.intip.internal_ip_app
  enable_provisioners = var.enable_provisioners
}

module "db" {
  source         = "../modules/db"
  public_key     = var.public_key
  zone           = var.zone
  db_disk_image  = var.db_disk_image
  prod_or_stage  = var.prod_or_stage
  private_key    = var.private_key
  ssh_user       = var.ssh_user
  internal_ip_db = module.intip.internal_ip_db
  enable_provisioners = var.enable_provisioners
}


module "vpc" {
  source        = "../modules/vpc"
  public_key    = var.public_key
  source_ranges = var.source_ranges
}

module "intip" {
  source = "../modules/intip"
}

# Добавляем ssh ключ для подключения к нашим VM сам ключ находится в variables.tf
#resource "google_compute_project_metadata" "ssh_keys" {
#  metadata = {
# ssh-keys = "baggurd:${var.public_key} baggurd"
# ssh-keys = "baggurd:${file(var.public_key)}\nappuser2:${file(var.public_key)}"
# chomp removes newline characters at the end of a string.
# This can be useful if, for example, the string was read from a file that has a newline character at the end.
#    ssh-keys = "baggurd:${chomp(file(var.public_key))}"
#  }
#}



#  # Определяем параметры подключения провиженеров к VM перед определением провиженеров
#  connection {
#    type  = "ssh"
#    user  = "baggurd"
#    agent = false
#    #ip адрес хоста берется из файла terraform.tfstate11 также можно брать и другие переменные
#    host = self.network_interface[0].access_config[0].nat_ip
#    # путь до приватного ключа
#    private_key = file(var.private_key)
#  }
#
#  # Копируем файл с нашей локальной машины на удаленную
#  provisioner "file" {
#    source      = "files/puma.service"
#    destination = "/tmp/puma.service"
#  }
#  # Запускаем скрипт для деплоя нашего приложения а также копирование в папку etc/systemd/system/ нашего приложения чтобы оно работало как служба
#  provisioner "remote-exec" {
#    script = "files/deploy.sh"
#  }
#}



