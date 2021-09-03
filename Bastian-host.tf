# bastion host security group
resource "aws_security_group" "sg_bastion_host" {
  depends_on = [
    aws_vpc.vpc,
  ]
  name        = "sg bastion host"
  description = "bastion host security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# bastion host ec2 instance
resource "aws_instance" "bastion_host" {
  depends_on = [
    aws_security_group.sg_bastion_host,
  ]
  ami = var.amiid
  instance_type = var.instancetype
  key_name = var.keyname
  vpc_security_group_ids = [aws_security_group.sg_bastion_host.id]
  subnet_id = aws_subnet.public_subnet.id
  tags = {
      Name = "bastion host"
  }
  provisioner "file" {
    source      = "F:/Rajesh/Downloads/playbook/Devops/Terraform2908/rajesh-nvirgina.pem"
    destination = "/home/ec2-user/rajesh-nvirginia.pem"
  connection {
  type = "ssh"
  user = "ec2-user"
  private_key = file("rajesh-nvirginia.pem")
  host = aws_instance.bastion_host.public_ip
  }
  }  
}