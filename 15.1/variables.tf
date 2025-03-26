###cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

#Путь к публичному ключу для подключения к yandex cloud
variable "yc_ssh_key_path" {
  description = "Путь к открытому ключу SSH для подключения к облаку"
  type        = string
  default     = "~/.authorized_key.json"
}

#Имя пользователя в виртуальной машине вместо стандартного
variable "vm_username" {
  type        = string
  default     = "eurus-cloud"
  description = "Username for vm in Cloud init"
}

#Путь к публичному ключу для передачи в виртуальную машину
variable vms_ssh_key_path {
  type    = string
  default = "~/.ssh/service-cloud-ssh.pub"
}

#Список пакетов для установки через Cloud init
variable packages {
  type    = list
  default = ["mc"]
}

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "cloud-network"
  description = "VPC network"
}

variable "public_subnet" {
  type        = string
  default     = "public"
  description = "subnet name"
}

variable "private_subnet" {
  type        = string
  default     = "private"
  description = "subnet name"
}

variable "public_compute_instance" {
  type = list(object({
    vm_name       = string
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    disk_type     = string
    preemptible   = bool
    nat           = bool
    default_zone  = string
    platform_id   = string
    image_family  = string
  }))
  default = [{
      vm_name       = "public-ci"
      cores         = 2
      memory        = 1
      core_fraction = 20
      disk_size     = 10
      disk_type     = "network-hdd"
      preemptible   = true
      nat           = true
      default_zone  = "ru-central1-a"
      platform_id   = "standard-v3"
      image_family  = "ubuntu-2204-lts"
            }]
  }

variable "private_compute_instance" {
  type = list(object({
    vm_name       = string
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    disk_type     = string
    preemptible   = bool
    nat           = bool
    default_zone  = string
    platform_id   = string
    image_family  = string
  }))
  default = [{
      vm_name       = "private-ci"
      cores         = 2
      memory        = 1
      core_fraction = 20
      disk_size     = 10
      disk_type     = "network-hdd"
      preemptible   = true
      nat           = false
      default_zone  = "ru-central1-a"
      platform_id   = "standard-v3"
      image_family  = "ubuntu-2204-lts"
            }]
  }

variable "nat_compute_instance" {
  type = list(object({
    vm_name       = string
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    disk_type     = string
    preemptible   = bool
    nat           = bool
    default_zone  = string
    platform_id   = string
    image_id      = string
    ip_address    = string
  }))
  default = [{
      vm_name       = "nat-ci"
      cores         = 2
      memory        = 2
      core_fraction = 20
      disk_size     = 10
      disk_type     = "network-hdd"
      preemptible   = true
      nat           = true
      default_zone  = "ru-central1-a"
      platform_id   = "standard-v3"
      image_id      = "fd80mrhj8fl2oe87o4e1"
      ip_address    = "192.168.10.254"
            }]
  }