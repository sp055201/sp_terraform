resource "aws_instance" "web1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.prod-subnet-public-1.id
  vpc_security_group_ids = [aws_security_group.ssh-allowed-prod.id]
  key_name               = aws_key_pair.tfm_ec2_key.id

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    password    = ""
    private_key = local_file.tfm_ec2_key.content
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo sh /tmp/script.sh"

    ]
  }
}


resource "aws_instance" "web2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.dev-subnet-public-1.id
  vpc_security_group_ids = [aws_security_group.ssh-allowed-dev.id]
  key_name               = aws_key_pair.tfm_ec2_key.id

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    password    = ""
    private_key = local_file.tfm_ec2_key.content
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo sh /tmp/script.sh"

    ]
  }
}

