#create route table for internet gateway
resource "aws_route_table" "project_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "project_rt"
  }
}

#associate public subnet with route table
resource "aws_route_table_association" "public_route_1" {
  subnet_id = aws_subnet.public-1.id
  route_table_id = aws_route_table.project_rt.id
}
resource "aws_route_table_association" "public_route_2" {
  subnet_id = aws_subnet.public-2.id
  route_table_id = aws_route_table.project_rt.id
}




#creating sg 

resource "aws_security_group" "public_sg" {
  name = "public-sg"
  description = "Allow web tier and sub traffic"
  vpc_id = aws_vpc.vpc.id

  ingress  {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress{
    from_port = 22
    to_port = 22
    protocol ="tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#security group for private subnet


resource "aws_security_group" "private_sg" {
  name = "private-sg"
  description = "Allow web tier and web traffic"
  vpc_id = aws_vpc.vpc.id

  ingress  {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    security_groups = [aws_security_group.public_sg.id]

  }

  ingress{
    from_port = 22
    to_port = 22
    protocol ="tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}