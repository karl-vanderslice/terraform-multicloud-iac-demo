resource "aws_instance" "hello-world" {
  ami           = data.aws_ami.hello-world.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.keypair.id

  vpc_security_group_ids = aws_security_group.default.*.id

  user_data = data.template_file.user_data_aws.rendered

  tags        = local.tags
  volume_tags = local.tags

}

resource "aws_key_pair" "keypair" {
  key_name   = "${var.orgname}-${var.service}-${var.environment_name}-${var.application}-${var.build_id}"
  public_key = var.public_key
  tags       = local.tags
}

resource "aws_security_group" "default" {
  count       = 1
  name        = "${var.orgname}-${var.service}-${var.environment_name}-${var.application}-${var.build_id}"
  vpc_id      = var.vpc_id
  description = "Instance default security group (only egress access is allowed)"
  tags        = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress" {
  count             = 1
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default[0].id
}

resource "aws_security_group_rule" "ingress_ssh" {
  count             = 1
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default[0].id
}

resource "aws_security_group_rule" "ingress_http" {
  count             = 1
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default[0].id
}

resource "aws_security_group_rule" "ingress_https" {
  count             = 1
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default[0].id
}

data "aws_ami" "hello-world" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["${var.hello_world_image_name}"]
  }
}

data "template_file" "user_data_aws" {
  template = "${file("${path.module}/templates/aws/user-data.tpl")}"

  vars = {
    instance_host_name = var.aws_instance_host_name
    instance_fqdn      = var.aws_instance_fqdn
    special_message    = var.special_message
  }
}