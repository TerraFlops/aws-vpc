output "network_interface" {
  value = aws_network_interface.network_interface
}

output "eip" {
  value = aws_eip.nat_instance
}

output "launch_template" {
  value = aws_launch_template.nat_instance
}