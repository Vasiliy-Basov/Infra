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
