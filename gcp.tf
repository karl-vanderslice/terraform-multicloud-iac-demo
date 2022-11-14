resource "google_compute_instance" "hello-world" {
  name         = "hello-world-gcp"
  machine_type = var.gcp_instance_type
  zone         = var.gcp_zone

  labels = local.tags_underscore

  metadata = {
    ssh-keys  = "ubuntu:${var.public_key}"
    user-data = data.template_file.user_data_gcp.rendered
  }


  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.hello-world.id
    }
  }
}

data "google_compute_image" "hello-world" {
  name    = var.hello_world_image_name
  project = var.gcp_project_id
}

data "template_file" "user_data_gcp" {
  template = "${file("${path.module}/templates/gcp/user-data.tpl")}"

  vars = {
    special_message = var.special_message
  }
}

resource "google_compute_firewall" "hello-world" {
  name    = "hello-world"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

}