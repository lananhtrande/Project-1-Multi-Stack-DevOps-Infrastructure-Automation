output "frontend_public_ip" {
  value = aws_instance.frontend[*].private_ip
}

output "backend_private_ip" {
  value = aws_instance.backend[*].private_ip
}

output "db_private_ip" {
  value = aws_instance.database[*].private_ip
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}