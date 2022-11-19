# Basov Vasiliy

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
