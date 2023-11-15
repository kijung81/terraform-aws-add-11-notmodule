resource "aws_instance" "was1" {
  ami           = data.aws_ami.al2.id
  instance_type = var.was_ec2_type
  subnet_id     = aws_subnet.pri_sbn_a.id
  vpc_security_group_ids = [aws_security_group.all_sg.id]
  associate_public_ip_address = true
  key_name      = var.ec2_key
  tags = {
    Name = "${var.prefix}-was1"
  } 
}

resource "aws_instance" "was2" {
  ami           = data.aws_ami.al2.id
  instance_type = var.was_ec2_type
  subnet_id     = aws_subnet.pri_sbn_a.id
  vpc_security_group_ids = [aws_security_group.all_sg.id]
  associate_public_ip_address = true
  key_name      = var.ec2_key
  tags = {
    Name = "${var.prefix}-was2"
  } 
}