data "yandex_compute_image" "public-ci" {
  family = var.public_compute_instance[0].image_family
}

resource "yandex_compute_instance" "public-ci" {
  name            = var.public_compute_instance[0].vm_name
  platform_id     = var.public_compute_instance[0].platform_id
  hostname        = var.public_compute_instance[0].vm_name

  resources {
    cores         = var.public_compute_instance[0].cores
    memory        = var.public_compute_instance[0].memory
    core_fraction = var.public_compute_instance[0].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.public-ci.image_id
      type     = var.public_compute_instance[0].disk_type
      size     = var.public_compute_instance[0].disk_size
    }
  }

  metadata = {
    user-data  = data.template_file.public-cloudinit.rendered
    serial-port-enable = true
  }

# Копирование ключа и настройка прав
  provisioner "file" {
    source      = "~/.ssh/service-cloud-ssh"
    destination = "/home/eurus-cloud/.ssh/id_ed25519"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/eurus-cloud/.ssh/id_ed25519"
    ]
  }

  connection {
    type        = "ssh"
    user        = var.vm_username
    private_key = file("~/.ssh/service-cloud-ssh")
    host        = self.network_interface[0].nat_ip_address
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    nat        = var.public_compute_instance[0].nat
  }
  scheduling_policy {
    preemptible = var.public_compute_instance[0].preemptible
  }
}

data "template_file" "public-cloudinit" {
 template = file("./cloud-init.yaml")
	vars = {
		username           = var.vm_username
		ssh_public_key     = file(var.vms_ssh_key_path)
		packages           = jsonencode(var.packages)
	}
}