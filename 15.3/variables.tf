# Переменные

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

variable "service_account_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
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

###

# Имя сети
variable "vpc_name" {
  type        = string
  default     = "cloud-network"
  description = "VPC network"
}

# Имя подсети
variable "public_subnet" {
  type        = string
  default     = "public"
  description = "subnet name"
}

# CIDR подсети
variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

# Описание входящих правил группы безопасности
variable "security_group_ingress" {
  description = "secrules ingress"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "разрешить входящий ssh"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 22
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий  http"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 80
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий https"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 443
    },
  ]
}

# Описание исходящих правил группы безопасности
variable "security_group_egress" {
  description = "secrules egress"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    { 
      protocol       = "TCP"
      description    = "разрешить весь исходящий трафик"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65365
    }
  ]
}

###

# Параметры шаблона для группы ВМ
variable "lamp_group_compute_instance" {
  type = list(object({
    name          = string
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
  }))
  default = [{
      name          = "lamp-group"
      cores         = 2
      memory        = 1
      core_fraction = 20
      disk_size     = 10
      disk_type     = "network-hdd"
      preemptible   = true
      nat           = true
      default_zone  = "ru-central1-a"
      platform_id   = "standard-v3"
      image_id      = "fd827b91d99psvq5fjit"
            }]
  }

# Параметр для масштабирования
variable "scale_count" {
  type = number
  default = 3
  description = "Scale count"
}