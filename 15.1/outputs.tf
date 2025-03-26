output "ip_for_ssh_connection" {
  value = {
    public-ic_ip    = yandex_compute_instance.public-ci.network_interface[0].nat_ip_address
    private-ic_ip = yandex_compute_instance.private-ci.network_interface[0].ip_address
  }
}