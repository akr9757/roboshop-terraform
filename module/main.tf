resource "aws_instance" "instance" {
  ami                         = data.aws_ami.centos.image_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [data.aws_security_group.allow-all.id]

  tags = {
    Name = var.component_name
  }
}

resource "null_resource" "provisioner" {
 depends_on = [aws_instance.instance, aws_route53_record.records]

 provisioner "remote-exec" {

   connection {
     type     = "ssh"
     user     = "centos"
     password = "DevOps321"
     host     = aws_instance.instance.private_ip
   }
   inline = [
    "rm -rf roboshop1-shell",
    "git clone https://github.com/akr9757/roboshop1-shell.git",
    "cd roboshop1-shell",
    "sudo bash ${var.component_name}.sh ${var.password}"

    ]
  }
}

resource "aws_route53_record" "records" {
  zone_id = "Z02476638DMPBR5KR64H"
  name    = "${var.components_name}-dev.akrdevopsb72.online"
  type    = "A"
  ttl     = "30"
  records = [aws_instance.instance.private_ip]
}