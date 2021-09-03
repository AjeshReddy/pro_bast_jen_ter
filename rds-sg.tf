resource "aws_security_group" "rds-sg" {
  name   = "my-rds-sg"
  vpc_id = aws_vpc.vpc.id

}

# Ingress Security Port 3306
resource "aws_security_group_rule" "mysql_inbound_access" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = "${aws_security_group.rds-sg.id}"
  to_port           = 3306
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
ingress {
    description = "allow Bastain"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_bastion_host.id]
  }