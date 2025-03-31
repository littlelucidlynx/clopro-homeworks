# Сеть

resource "yandex_vpc_network" "network" {
  name = var.vpc_name
}