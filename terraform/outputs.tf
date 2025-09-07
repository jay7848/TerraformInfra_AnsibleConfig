output "web_public_ip" {
  description = "Public IP of the web/app server"
  value       = aws_instance.web.public_ip
}

output "web_public_dns" {
  value = aws_instance.web.public_dns
}

output "db_private_ip" {
  value = aws_instance.db.private_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}
