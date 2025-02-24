resource "aws_instance" "sandbox" {
  count         = 2
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "sandbox_server-${count.index+1}"
  }
}
