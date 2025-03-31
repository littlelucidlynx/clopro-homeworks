# Выходные данные
output "Network_Load_Balancer_Address" {
  value = yandex_lb_network_load_balancer.nlb.listener[*].external_address_spec[*].address
  description = "Адрес сетевого балансировщика"
}