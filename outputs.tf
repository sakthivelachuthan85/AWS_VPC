output "my_web_server_ip" {
  value = aws_instance.web_server.public_ip
  
}
output "my_web_server_private_ip" {
  value = aws_instance.web_server.private_ip
}

output "my_db_server_ip" {
  value = aws_instance.db_server.private_ip
}
