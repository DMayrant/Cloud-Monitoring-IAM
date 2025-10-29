resource "tls_private_key" "instance_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

}
# Create an AWS key pair using the generated public key
resource "aws_key_pair" "instance_key" {
  key_name   = "SSH-prod"
  public_key = tls_private_key.instance_key.public_key_openssh

}

