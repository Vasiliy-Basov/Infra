# Можем хранить terraform.tfstate файл в том же бакете который мы создаем этим терраформом
terraform {
  backend "gcs" {
    bucket = "prod-bucket-f1b000bd21bd4bbf" # имя нашего bucket
    prefix = "bucket"
  }
}
