resource "aws_instance" "web1" {
  ami           = data.aws_ami.al2.id
  instance_type = var.web_ec2_type
  subnet_id     = aws_subnet.pub_sbn_a.id
  vpc_security_group_ids = [aws_security_group.all_sg.id]
  associate_public_ip_address = true
  key_name      = var.ec2_key
  tags = {
    Name = "${var.prefix}-web1"
  } 
}

resource "aws_instance" "web2" {
  ami           = data.aws_ami.al2.id
  instance_type = var.web_ec2_type
  subnet_id     = aws_subnet.pub_sbn_c.id
  vpc_security_group_ids = [aws_security_group.all_sg.id]
  associate_public_ip_address = true
  key_name      = var.ec2_key
  tags = {
    Name = "${var.prefix}-web2"
  } 
}