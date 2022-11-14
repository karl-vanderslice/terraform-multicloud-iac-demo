data "aws_route53_zone" "main" {
  name         = "${var.route53_domain_name}."
  private_zone = false
}

resource "aws_route53_record" "aws" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "aws.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.hello-world.public_ip}"]
}

resource "aws_route53_record" "azure" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "azure.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "300"
  records = ["${azurerm_linux_virtual_machine.hello-world.public_ip_address}"]
}

resource "aws_route53_record" "gcp" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "gcp.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "300"
  records = ["${google_compute_instance.hello-world.network_interface.0.access_config.0.nat_ip}"]
}

resource "aws_route53_record" "do" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "do.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "300"
  records = ["${digitalocean_droplet.hello-world.ipv4_address}"]
}