resource "aws_instance" "db1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.prod-subnet-private-1.id
  vpc_security_group_ids = [aws_security_group.ssh-allowed-prod.id]
  key_name               = aws_key_pair.tfm_ec2_key.id
   user_data = <<-EOF
                #!/bin/bash
                yum install -y mysql56-server
              EOF
}

resource "aws_instance" "db2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.dev-subnet-private-1.id
  vpc_security_group_ids = [aws_security_group.ssh-allowed-dev.id]
  key_name               = aws_key_pair.tfm_ec2_key.id
   user_data = <<-EOF
                #!/bin/bash
                yum install -y mysql56-server
              EOF
}
