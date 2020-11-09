

output "igw" {
  value = aws_internet_gateway.main.id
}

output "public_subnet1" {
  value = aws_subnet.public_subnet1.id
}

output "public_subnet2" {
  value = aws_subnet.public_subnet2.id
}

output "private_subnet1" {
  value = aws_subnet.private_subnet1.id
}

output "private_subnet2" {
  value = aws_subnet.private_subnet2.id
}

output "eip" {
  value = aws_eip.main.public_ip
}

output "security_group" {
  value = aws_security_group.main.id
}