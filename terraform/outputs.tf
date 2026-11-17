
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.taskflow_server.id
}

output "public_ip" {
  description = "Public IP of TaskFlow server"
  value       = aws_instance.taskflow_server.public_ip
}

output "application_url" {
  description = "TaskFlow application URL"
  value       = "http://${aws_instance.taskflow_server.public_ip}:5000"
}

output "security_group_id" {
  description = "TaskFlow security group ID"
  value       = aws_security_group.taskflow_sg.id
}

output "public_subnet_id" {
  description = "TaskFlow public subnet ID"
  value       = aws_subnet.taskflow_public.id
}

output "route_table_id" {
  description = "TaskFlow public route table ID"
  value       = aws_route_table.taskflow_public_rt.id
}
