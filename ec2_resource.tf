resource "aws_instance" "web1" {
    ami = "ami-0287awsf0ef0e3f9a"
  instance_type = "t2.micro"
  key_name = "two-tier-key-pair"
  availability_zone = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id = aws_subnet.public-1.id
  associate_public_ip_address = true
  tags = {
    Name = "web1"
  }
 
}

resource "aws_instance" "web2" {
    ami = "ami-0287awsf0ef0e3f9a"
  instance_type = "t2.micro"
  key_name = "two-tier-key-pair"
  availability_zone = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id = aws_subnet.public-2.id
  associate_public_ip_address = true
  tags = {
    Name = "web2"
  }
 
}