data "yandex_compute_image" "private-ci" {
  family = var.private_compute_instance[0].image_family
}

resource "yandex_compute_instance" "private-ci" {
  name            = var.private_compute_instance[0].vm_name
  platform_id     = var.private_compute_instance[0].platform_id
  hostname        = var.private_compute_instance[0].vm_name

  resources {
    cores         = var.private_compute_instance[0].cores
    memory        = var.private_compute_instance[0].memory
    core_fraction = var.private_compute_instance[0].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.private-ci.image_id
      type     = var.private_compute_instance[0].disk_type
      size     = var.private_compute_instance[0].disk_size
    }
  }

  metadata = {
    user-data  = data.template_file.private-cloudinit.rendered
    serial-port-enable = true
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.private.id
    nat        = var.private_compute_instance[0].nat
  }
  scheduling_policy {
    preemptible = var.private_compute_instance[0].preemptible
  }
}

data "template_file" "private-cloudinit" {
 template = file("./cloud-init.yaml")
	vars = {
		username           = var.vm_username
		ssh_public_key     = file(var.vms_ssh_key_path)
		packages           = jsonencode(var.packages)
	}
}