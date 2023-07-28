data "aws_ami" "centos" {
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
  owners      = ["973714476881"]
}

data "aws_security_group" "allow-all" {
  name = "allow-all"
}


resource "aws_instance" "instance" {
  for_each               = var.components
  ami                    = data.aws_ami.centos.image_id
  instance_type          = each.value[ "instance_type" ]
  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]

  tags = {
    Name = each.value[ "name" ]
  }
}

resource "aws_route53_record" "records" {
  for_each = var.components
  zone_id = "Z02476638DMPBR5KR64H"
  name    = "${each.value["name"]}-dev.akrdevopsb72.online"
  type    = "A"
  ttl     = "30"
  records = [aws_instance.instance[each.value["name"]].private_ip]
}

