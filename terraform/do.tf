resource "digitalocean_droplet" "hello-world" {
  image              = data.digitalocean_droplet_snapshot.hello-world.id
  region             = var.do_region
  size               = var.do_instance_type
  private_networking = true
  backups            = false
  ipv6               = true
  name               = "hello-world"

  tags = [digitalocean_tag.service.id, digitalocean_tag.environmentname.id, digitalocean_tag.name.id, digitalocean_tag.application.id, digitalocean_tag.costcenter.id, digitalocean_tag.dataclassification.id, digitalocean_tag.taggingversion.id, digitalocean_tag.buildid.id]

  user_data = data.template_file.do_user_data.rendered

}

data "digitalocean_droplet_snapshot" "hello-world" {
  name_regex  = "^${var.hello_world_image_name}"
  region      = "${var.do_region}"
  most_recent = true
}

data "template_file" "do_user_data" {
  template = "${file("${path.module}/templates/do/user-data.tpl")}"

  vars = {
    public_key      = var.public_key
    special_message = var.special_message
  }
}

resource "digitalocean_tag" "service" {
  name = "${lower(var.orgname)}:_${lower(var.service)}"
}

resource "digitalocean_tag" "environmentname" {
  name = "${lower(var.orgname)}:environmentname_${lower(var.environment_name)}"
}

resource "digitalocean_tag" "name" {
  name = "name_${lower(var.orgname)}-${lower(var.service)}-${lower(var.environment_name)}-${lower(var.application)}-${lower(var.build_id)}"
}

resource "digitalocean_tag" "application" {
  name = "${lower(var.orgname)}:application_${lower(var.application)}"
}

resource "digitalocean_tag" "costcenter" {
  name = "${lower(var.orgname)}:costcenter_${lower(var.cost_center)}"
}

resource "digitalocean_tag" "dataclassification" {
  name = "${lower(var.orgname)}:dataclassification_${lower(var.data_classification)}"
}

resource "digitalocean_tag" "taggingversion" {
  name = "${lower(var.orgname)}:taggingversion_0-1-0"
}

resource "digitalocean_tag" "buildid" {
  name = "${lower(var.orgname)}:buildid_${lower(var.build_id)}"
}
