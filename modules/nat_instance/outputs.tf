output "network_interface" {
  value = aws_network_interface.network_interface
}

output "eip" {
  value = aws_eip.nat_gateway
}
