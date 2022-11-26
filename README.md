# Basov Vasiliy

Описано в файле GCP.docx

**ВЫПОЛНЕНО ДЗ №3**  

**Задача: Исследовать способ подключения к someinternalhost в одну команду из вашего рабочего устройства, проверить работоспособность найденного решения и внести его в README.md в вашем репозитории**  
Решение: 

Подключиться к нашему хосту через bastion то нужно:
На локальной машине добавить приватный ключ в ssh агент авторизации
```bash
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
```

```bash
bastion_IP=35.228.62.55
someinternalhost_IP=10.166.0.3
ssh -J baggurd@35.228.62.55 10.166.0.3
```
10.166.0.3 внутренний ip адрес машины к которой подключаемся

**Задача: Предложить вариант решения для подключения из консоли при помощи команды вида ssh someinternalhost из локальной консоли рабочего устройства, чтобы подключение выполнялось по алиасу someinternalhost и внести его в README.md в вашем репозитории**  
Решение: 

1. Если соединение нужно выполнить командой вида
```bash
ssh someinternalhost
```
то решение такое:
Чтобы подключаться по алиасу нужно в каталоге .ssh создать файл config и поместить туда информацию
```bash
### First jump host. Directly reachable
Host bastion
  HostName 35.228.62.55
 
### Host to jump to bastion
Host internal01
  HostName 10.166.0.3
  ProxyJump  bastion
```
2. если соединение нужно выполнить командой вида
```bash
someinternalhost
```
то решение такое через .bashrc:
```bash
echo "alias someinternalhost=\"ssh -J root@35.189.214.30 root@10.132.0.5\"" >> ~/.bashrc 
source ~/.bashrc
someinternalhost
```

** ДЗ №4**  

**Задача:**
1. Устанавливаем Google Cloud SDK
2. Создаем новый инстанс  
Решение:  
- Создается скриптом installGoogleSDK.sh
- Создается скриптом setupVM.sh

**Задача:**
Команды по настройке системы и деплоя приложения нужно завернуть в баш скрипты, чтобы не вбивать эти команды вручную:
- Скрипт install_ruby.sh должен содержать команды по установке Ruby;
- Скрипт install_mongodb.sh должен содержать команды по установке MongoDB;
- Скрипт deploy.sh должен содержать команды скачивания кода, установки зависимостей через bundler и запуск приложения.  
Решение:  
- создал скрипт install_ruby.sh
- создал скрипт install_mongodb.sh
- создал скрипт deploy.sh


**Задача:**
В качестве доп. задания используйте созданные ранее скрипты для создания , который будет запускаться при создании инстанса. Передавать startup скрипт необходимо как дополнительную опцию уже использованной ранее команде gcloud  
Ключевые моменты:
- startup-скрипты запускаются от root'а (https://cloud.google.com/compute/docs/startupscript#startup_script_execution), соответственно нужно держать в голове, что и от чьего имени мы хотим исполнить. Для исполнения команд от имени другого пользователя подойдет runuser или su (https://www.cyberciti.biz/open-source/command-line-hacks/linux-run-command-as-different-user/). Пример:
```
runuser -l appuser -c 'git clone -b monolith https://github.com/express42/reddit.git'
runuser -l appuser -c 'cd reddit && bundle install'
runuser -l appuser -c 'cd reddit && puma -d'
```
```
appuser@reddit-app:~$ ps aux | grep 9292
appuser   9434  1.0  1.5 513788 26876 ?        Sl   21:53   0:00 puma 3.10.0 (tcp://0.0.0.0:9292) [reddit]
appuser   9459  0.0  0.0  12916  1088 pts/0    S+   21:54   0:00 grep --color=auto 9292
```
- обработчик startup-скриптов не поддерживает не-ascii символы - в /var/log/syslog сыпалось множество ошибок, когда я в скрипте оставил комментарии на русском;
- отслеживать выполнение startup-скрипта можно в /var/log/syslog
```
tail -f /var/log/syslog
Mar 27 21:53:34 reddit-app systemd[1]: Started Session c3 of user appuser.
Mar 27 21:53:34 reddit-app startup-script: INFO startup-script:   Puma starting in single mode...
Mar 27 21:53:34 reddit-app startup-script: INFO startup-script: * Version 3.10.0 (ruby 2.3.1-p112), codename: Russell's Teapot
Mar 27 21:53:34 reddit-app startup-script: INFO startup-script: * Min threads: 0, max threads: 16
Mar 27 21:53:34 reddit-app startup-script: INFO startup-script: * Environment: development
Mar 27 21:53:34 reddit-app startup-script: INFO startup-script: * Daemonizing...
Mar 27 21:53:34 reddit-app startup-script: INFO startup-script: Return code 0.
Mar 27 21:53:34 reddit-app startup-script: INFO Finished running startup scripts.
Mar 27 21:53:34 reddit-app systemd[1]: Started Google Compute Engine Startup Scripts.
Mar 27 21:53:34 reddit-app systemd[1]: Startup finished in 2.857s (kernel) + 1min 31.747s (userspace) = 1min 34.605s.
```
- скрипт может храниться локально на машине с gcloud-клиентом (startup-script=), в bucket на Google Cloud Storage (startup-script-url=), в метаданных instance, а также может быть передан в виде текста. В качестве дополнительного параметра к gcloud также необходимо указать "--metadata-from-file".
```
gcloud compute instances create reddit-app --boot-disk-size=10GB --image-family ubuntu-1604-lts --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --metadata-from-file startup-script=install_all.sh

Решение:  
Создал скрипт startup_1604.sh, который запускается автоматически после запуска инстанса. В скрипт GCPInstanceeInstall1604.bat создания инстанса была добавлена команда: 
```bash
--metadata startup-script=”wget -O - https://raw.githubusercontent.com/Vasiliy-Basov/GCP/main/startup_1604.sh | bash”
```

**Задача:**
1. Удалите созданное через веб интерфейс правило для работы приложения default-puma-server.
2. Создайте аналогичное правило из консоли с помощью gcloud.  
Решение:  
- удалил
- создал в скрипте apply_firewall_rule.sh:   
```bash
gcloud compute firewall-rules create default-puma-server --allow=tcp:9292 --source-ranges=”0.0.0.0/0” --target-tags puma-server
```

**ВЫПОЛНЕНО ДЗ №5**
Созданы скрипты install_mongodb.sh и install_ruby.sh для установки mongodb и ruby соответственно.  
Создан packer скрипт ubuntu.json для создания базового образа VM.
packer build -var-file=variables.json ubuntu.json
Из него вручную создан инстанс VM с именем reddit-app и развернуто приложение puma

**Задача:**
1. Необходимо параметризировать созданный шаблон, используя
пользовательские переменные (см. лекцию и документацию).
Должны быть параметризированы:
• ID проекта (обязательно)
• source_image_family (обязательно)
• machine_type 
Решение:  
Выполнено в файле ubuntu.json за счет блока кода
```bash
{
   "variables":
        {
        "project_id": null,
        "source_image": null,
        "machine_type": null
        }
        ,
```
**Задача:**
2. Пользовательские переменные определяются в самом шаблоне, в файле variables.json задаются обязательные переменные, либо переопределяются
Решение:  
Создан файл variables.json  
**Задача:**
3. Исследовать другие опции builder для GCP (ссылка). Какие опции точно хотелось бы увидеть:
• Описание образа
• Размер и тип диска
• Название сети
• Теги
Файл с переменными variables.json, нужно внести в .gitignore, а в репозиторий добавить файл variables.json.example с примером заполнения, используя вымышленные значения, т.к. ваш репозиторий публичный.  
Решение:  
Сделано в файле ubuntu.json за счет блока кода
```bash
"builders": [
	{
        "image_description": "Reddit-app image for deploy puma app",
        "network": "default",
        "tags": "puma-server",
        "disk_type": "pd-standard",
        "disk_size": "10"
        }
    ],

```
Создан файл с переменными variables.json и внесен в .gitignore, а файл variables.json.example добавлен в коммит
**Задача: задание со звездочкой**
попробуйте “запечь” (bake) в образ VM все зависимости приложения и сам код приложения. Результат должен быть таким: запускаем инстанс из созданного образа и на нем сразу же имеем запущенное приложение. Созданный шаблон должен называться immutable.json и содержаться в директории packer, image_family у получившегося образа должен быть reddit-full. Дополнительные файлы можно положить в директорию packer/files. Для запуска приложения при старте инстанса необходимо использовать systemd unit. P.S. Этот образ можно строить "поверх" базового.  
Решение:  
Создан packer скрипт immutable.json, который создает образ семейства reddit-full. Приложение скачивается и устанавливается в сам образ скриптом packer/files/deploy_reddit.sh. Так же приложение добавляется в сервис для auto startup. Сам сервис лежит в packer/files/puma.service. 
**Задача: задание со звездочкой**
Создайте shell-скрипт с названием create-reddit-vm.bat. Запишите в него команду которая запустит виртуальную машину из образа подготовленного вами в рамках этого ДЗ, из семейства reddit-full  
Решение:  
Создан скрипт create-reddit-vm.bat, который выполняет создание инстанса VM на основе необходимого образа

**ВЫПОЛНЕНО ДЗ №6**

В данной работе мы настроили деплой нашего приложения посредством terraform. Структура конфигурации:
main.tf - виртуальная машина, правило firewall, provisioners, ssh-ключи;
variables.tf - переменные, используемые в main.tf;
terraform.tfvars - значения, подставляемые в переменные;
outputs.tf - переменные, значение у которых появляется уже после запуска машин (e.g. IP-адрес)

**Задача с одной звездочкой:**  
Опишите в коде терраформа добавление ssh ключа пользователя appuser1 в метаданные проекта. Выполните terraform apply и проверьте результат (публичный ключ можно брать пользователя appuser). Опишите в коде терраформа добавление ssh ключей нескольких пользователей в метаданные проекта (можно просто один и тот же публичный ключ, но с разными именами пользователей, например appuser1, appuser2 и т.д.). Выполните terraform apply и проверьте результат  
Решение:  
В файл main.tf добавлен ресурс для ключей пользователей appuser1 и appuser2:
```bash
resource "google_compute_project_metadata" "ssh_keys" {
  metadata = {
    # ssh-keys = "baggurd:${var.public_key} baggurd"
    # ssh-keys = "baggurd:${file(var.public_key)}\nappuser2:${file(var.public_key)}"
    # chomp removes newline characters at the end of a string.
    # This can be useful if, for example, the string was read from a file that has a newline character at the end.
    ssh-keys = "baggurd:${chomp(file(var.public_key))}"
  }
}
```
Это позволяет коннектиться к серверу двумя различными логинами.  
**Задача:**  
* Определите input переменную для приватного ключа, использующегося в определении подключения для провижинеров (connection);
* Определите input переменную для задания зоны в ресурсе "google_compute_instance" "app". У нее должно быть значение по умолчанию;
* Отформатируйте все конфигурационные файлы используя команду terraform fmt;
* Так как в репозиторий не попадет ваш terraform.tfvars, то нужно сделать рядом файл terraform.tfvars.example, в котором будут указаны переменные для образца
  
Решение:    
* определена переменная private_key_path
* определена переменная zone со значением по умолчанию "europe-west1-b"
* выполнено форматирование посредством terraform fmt
* создан файл terraform.tfvars.example и указаны переменные
  
**Задача с одной звездочкой:**  
Добавьте в веб интерфейсе ssh ключ пользователю appuser_web в метаданные проекта. Выполните terraform apply и проверьте результат Какие проблемы вы обнаружили?   
Решение:  
При выполнении terraform apply добавленные в web интерфейсы ключи слетают.
  
**Задача с двумя звездочками:**  
В данный момент у нас с помощью terraform создается один инстанс с запущенным приложением и правило для firewall.  
Задания:  
Создайте файл lb.tf и опишите в нем в коде terraform создание HTTP балансировщика, направляющего трафик на наше развернутое приложение на инстансе reddit-app. Проверьте доступность приложения по адресу балансировщика. Добавьте в output переменные адрес балансировщика.
  
Решение:    
Создан файд lb.tf, в котором заданы ресурсы:
```bash
resource "google_compute_address" "external_ip_address"
resource "google_compute_forwarding_rule" "loadbalancer" 
resource "google_compute_target_pool" "loadbalancer" 
resource "google_compute_http_health_check" "default" 
```
отвечающие за работу балансировщика.    
При вызове команды terraform refresh будет дополнительно выводиться адрес балансировщика в виде:
```bash
Outputs:

lb_external_ip = 34.77.232.88
```
в таком случае можно выполнить проверку доступности через балансировщик командой:
```bash
curl http://34.77.232.88:9292
```

**Задача с двумя звездочками:**  
Добавьте в код еще один terraform ресурс для нового инстанса приложения, например reddit-app2, добавьте его в балансировщик и проверьте, что при остановке на одном из инстансов приложения (например systemctl stop puma), приложение продолжает быть доступным по адресу балансировщика; Добавьте в output переменные адрес второго инстанса; Какие проблемы вы видите в такой конфигурации приложения? Добавьте описание в README.md.  
Решение:   
В файле main.tf добавлен копипастом кусок кода вида:
```bash
resource "google_compute_instance" "app2" {
  name         = "reddit-app2"
  machine_type = "g1-small"
```
Основаная проблема ткого подхода в том, что приходится делать избыточное копирование кусков кода, что загромождает код и логику и может приводить к ошибкам из-за сложной поддержки
  
**Задача с двумя звездочками:**  
Как мы видим, подход с созданием доп. инстанса копированием кода выглядит нерационально, т.к. копируется много кода. Удалите описание reddit-app2 и попробуйте подход с заданием количества инстансов через параметр ресурса count. Переменная count должна задаваться в параметрах и по умолчанию равна 1.  

### Задание с ** (стр. 55)
Задание:
Как мы видим, подход с созданием доп. инстанса копированием кода выглядит нерационально, т.к. копируется много кода. Удалите описание reddit-app2 и попробуйте подход с заданием количества инстансов через параметр ресурса count. Переменная count должна задаваться в параметрах и по умолчанию равна 1.

Решение:
main.tf
```
resource "google_compute_instance" "app" {
  count = var.number_of_instances
  name         = "reddit-app-${count.index}"
  [...]
}
```
=> Здесь основное отличие будет состоять в том, что мы будет к имени автоматически добавлять номер instance через ${count.index}

variables.tf
```
variable "number_of_instances" {
  description = "Number of reddit-app instances (count)"
  default     = 1
}
```

terraform.tfvars
```
number_of_instances = 2
```

outputs.tf
```
output "Global_Forwarding_Rule_IP" {
  value = google_compute_forwarding_rule.loadbalancer.ip_address
}
```
=> Чтобы output-переменные генерировались для каждого созданного instance, после указания имени ресурса terraform, необходимо добавить .*. (google_compute_instance.app.*.) и в секции instances google_compute_target_pool убрать [].

## HW 9 (terraform-2 - IaC in a team)

### Импорт ресурсов из GCP
Создаём копию уже определённого в GCP правила, разрешающего подключение по ssh:
```
resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"
  network = "default"
  priority = 65534
  description = "Allow SSH from anywhere"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = var.source_ranges
}
```
Т.к. в terraform state отсутствует информация о том, что правило уже применено, terraform apply завершится с ошибкой. Соответственно, нам необходимо вручную импортировать состояние:
$ terraform import google_compute_firewall.firewall_ssh default-allow-ssh

### Пример ссылки на атрибуты другого ресурса
```
resource "google_compute_address" "app_ip" {
  name   = "reddit-app-ip"
  region = var.region
}
```

```
  network_interface {
    //[...]
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }
```

### Разбиение конфигурации по файлам / на модули
```
$ tree modules/app/
modules/app/
├── files
│   ├── deploy.sh
│   ├── puma.service
│   └── set_env.sh
├── main.tf
├── outputs.tf
└── variables.tf
```

```
$ tree modules/db
modules/db
├── main.tf
├── outputs.tf
└── variables.tf
```

Интересные особенности:
1. В модуль можно передавать значения для переменных;
```
module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  zone            = var.zone
  db_disk_image   = var.db_disk_image
}
```

2. Модуль может возвращать значения переменных:
```
variable "database_url" {
  description = "database_url for reddit app"
  default     = "127.0.0.1:27017"
}
```
Соответственно, к ним можно обращаться извне:
```
database_url        = "${module.db.db_internal_ip}:27017"
```

После добавления конфигурации модуля, необходимо выполнить $ terraform get

### Самостоятельное задание (стр. 24)
Необходимо создать модуль vpc (+ параметризация).
```
resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"
  network = "default"
  priority = 65534
  description = "Allow SSH from anywhere"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  //  source_ranges = ["0.0.0.0/0"]
  source_ranges = var.source_ranges
}


resource "google_compute_project_metadata_item" "default" {
  key = "ssh-keys"
  value = "baggurd:${chomp(file(var.public_key))}"
}
```

Настройте хранение стейт файла в удаленном бекенде (remote
backends) для окружений stage и prod, используя Google Cloud
Storage в качестве бекенда. Описание бекенда нужно вынести в
отдельный файл backend.tf
https://cloud.google.com/docs/terraform/resource-management/store-state
https://developer.hashicorp.com/terraform/language/settings/backends/configuration

Enable the Cloud Storage API:
gcloud services enable storage.googleapis.com

Создаем Bucket: (либо через модуль bucket-from-module)
```
# Это плагин который генерирует random id:
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name          = "prod-bucket-${random_id.bucket_prefix.hex}"
  force_destroy = false # не даст удалить bucket пока не удалим все внутренние объекты
  location      = "EU" # https://cloud.google.com/storage/docs/locations
  storage_class = "STANDARD" # Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE
  project = "infra-368512"
  versioning {      # При изменении объекта старые версии сохраняются
    enabled = true
  }
}

```

И создаем файл backend.tf 
```
# Указываем путь где мы будем хранить наш stage file
terraform {
 backend "gcs" {
   bucket  = "prod-bucket-f1b000bd21bd4bbf" # имя нашего bucket
   prefix  = "stage"
 }
}
```

Все, stage будет храниться в GCP Bucket

При запуске terraform apply из двух разных директорий получаем Lock:

<details>
  <summary>state lock</summary>

```bash
│ Error: Error acquiring the state lock
│
│ Error message: writing "gs://prod-bucket-f1b000bd21bd4bbf/prod/default.tflock" failed: googleapi: Error 412: At least
│ one of the pre-conditions you specified did not hold., conditionNotMet
│ Lock Info:
│   ID:        1669400526851245
│   Path:      gs://prod-bucket-f1b000bd21bd4bbf/prod/default.tflock
│   Operation: OperationTypeApply
│   Who:       I5-2500K\baggu@i5-2500k
│   Version:   1.3.5
│   Created:   2022-11-25 18:23:59.7938099 +0000 UTC
│   Info:
│
│
│ Terraform acquires a state lock to protect the state from being written
│ by multiple users at the same time. Please resolve the issue above and try
│ again. For most commands, you can disable locking with the "-lock=false"
│ flag, but this is not recommended.
```
</details>

<details>
  <summary>Задание с двумя звездочками:</summary>

```bash
В процессе перехода от конфигурации, созданной в
предыдущем ДЗ к модулям мы перестали использовать provisioner
для деплоя приложения. Соответственно, инстансы поднимаются
без приложения.
1. Добавьте необходимые provisioner в модули для деплоя и
работы приложения. Файлы, используемые в provisioner, должны
находится в директории модуля.
2. Опционально можете реализовать отключение provisioner в
зависимости от значения переменной
3. Добавьте описание в README.md
P.S. Приложение получает адрес БД из переменной
окружения DATABASE_URL.
```
</details>

1. По умолчанию, MongoDB слушает порт 27017 только на 127.0.0.1.
Конфигурация базы лежит в etc/monog.conf

Замена конфигурации в файле делаем с помощью редактора sed:
```
-i - означает что мы заменяем исходный файл 
s в кавычках означает что мы производим замену тескта 127.0.0.1 на 0.0.0.0
g в кавычках означает что sed заменит все совпадения в файле
```

```
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
```

Приложение в процессе работы использует БД, указанную в переменной окружения DATABASE_URL, нам нужно создать эту переменную в app instance
Команда export создает переменную для текущей оболочки и всех дочерних процессов так же помещаем переменную в ~/.profile
```
  provisioner "remote-exec" {
  inline = [
    "echo 'export DATABASE_URL=${var.db_internal_address}' >> ~/.profile", # 
    "export DATABASE_URL=${var.db_internal_address}",
    "sudo systemctl restart puma.service"
    ]
}
```
Если мы используем ip адреса одного модуля в другом и наоборот, то если адреса получать непосредственно из модулей то выдаст ошибку зацикленности
Нужно сначала создать ip адреса и только потом инстансы. Можно сделать для этого новый модуль. Например intip

