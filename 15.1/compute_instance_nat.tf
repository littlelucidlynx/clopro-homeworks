resource "yandex_compute_instance" "nat-ci" {
  name            = var.nat_compute_instance[0].vm_name
  platform_id     = var.nat_compute_instance[0].platform_id
  hostname        = var.nat_compute_instance[0].vm_name

  resources {
    cores         = var.nat_compute_instance[0].cores
    memory        = var.nat_compute_instance[0].memory
    core_fraction = var.nat_compute_instance[0].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_compute_instance[0].image_id
      type     = var.nat_compute_instance[0].disk_type
      size     = var.nat_compute_instance[0].disk_size
    }
  }

  metadata = {
    user-data  = data.template_file.nat-cloudinit.rendered
    serial-port-enable = true
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    nat        = var.nat_compute_instance[0].nat
    ip_address = var.nat_compute_instance[0].ip_address
  }
  scheduling_policy {
    preemptible = var.nat_compute_instance[0].preemptible
  }
}

data "template_file" "nat-cloudinit" {
 template = file("./cloud-init.yaml")
	vars = {
		username           = var.vm_username
		ssh_public_key     = file(var.vms_ssh_key_path)
		packages           = jsonencode(var.packages)
	}
}