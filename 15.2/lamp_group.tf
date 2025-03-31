# Instance Group с LAMP

# Создание группы
resource "yandex_compute_instance_group" "lamp_group" {
  name               = "lamp-group"
  service_account_id = var.service_account_id

  # Конфигурация шаблона ВМ
  instance_template {
    platform_id = var.lamp_group_compute_instance[0].platform_id
    resources {
      cores  = var.lamp_group_compute_instance[0].cores
      core_fraction = var.lamp_group_compute_instance[0].core_fraction
      memory = var.lamp_group_compute_instance[0].memory
    }
   
    # Использование LAMP образа
    boot_disk {
      initialize_params {
        image_id = var.lamp_group_compute_instance[0].image_id
      }
    }
    
    # Настройка сети
    network_interface {
      network_id         = yandex_vpc_network.network.id
      subnet_ids         = [yandex_vpc_subnet.public.id]
      security_group_ids = [yandex_vpc_security_group.sg.id]
      nat                = true
    }

    # Метаданные с пользовательским скриптом
    metadata = {
      serial-port-enable = true
      ssh-keys = "${var.vm_username}:${file(var.vms_ssh_key_path)}"
      user-data = <<-EOT
        #!/bin/bash
        echo '<html><head><title>November lynx</title></head> <body><h1>Very sad november lynx</h1><img src="https://storage.yandexcloud.net/${yandex_storage_bucket.clopro-bucket.bucket}/${yandex_storage_object.image.key}"></body></html>' > /var/www/html/index.html
        EOT
    }
  }

  # Настройки масштабирования
  scale_policy {
    fixed_scale {
      size = var.scale_count
    }
  }

  # Зоны доступности для размещения ресурсов
  allocation_policy {
    zones = [var.default_zone]
  }

  # Стратегия развертывания, обновления и масштабирования ресурсов
  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  # Проверка состояния ВМ
  health_check {
    interval = 30
    timeout  = 5
    http_options {
      port = 80
      path = "/"
    }
  }
    load_balancer {
        target_group_name = "lamp-group"
    }
}