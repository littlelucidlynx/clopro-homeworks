# Группа безопасности

# Создание группы безопасности
resource "yandex_vpc_security_group" "sg" {
  name       = "web-security-group"
  network_id = yandex_vpc_network.network.id
  folder_id  = var.folder_id

  # Динамические входящие правила
  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      protocol       = lookup(ingress.value, "protocol", null)
      description    = lookup(ingress.value, "description", null)
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks = lookup(ingress.value, "v4_cidr_blocks", null)
    }
  }

  # Динамические исходящие правила
  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      protocol       = lookup(egress.value, "protocol", null)
      description    = lookup(egress.value, "description", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}