# Сетевой балансировщик

# Создание сетевого балансировщика
resource "yandex_lb_network_load_balancer" "nlb" {
  name = "network-lb"

  # Что слушает
  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Связанная целевая группа
  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp_group.load_balancer[0].target_group_id

    # Проверка жизнеспособности сервиса
    healthcheck {
      name = "http"
      interval = 2
      timeout = 1
      unhealthy_threshold = 2
      healthy_threshold = 5
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}