resource "yandex_vpc_subnet" "public" {
  name           = var.public_subnet
  zone           = var.default_zone
  network_id     = yandex_vpc_network.cloud-net.id
  v4_cidr_blocks = var.public_cidr
}