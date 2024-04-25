resource "tls_private_key" "tfm_ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "tfm_ec2_key" {
  filename        = "tfm_ec2_key.pem"
  content         = tls_private_key.tfm_ec2_key.private_key_pem
  file_permission = "400"
}
resource "aws_key_pair" "tfm_ec2_key" {
  key_name   = "tfm_ec2_key"
  public_key = tls_private_key.tfm_ec2_key.public_key_openssh
}
