
output "server_public_ip" {
  value       = ncloud_public_ip.public-ip.*.public_ip
  description = "The public IP of the Instance"
}
output "subnet_public_private_ip" {
  value       = ncloud_network_interface.create_nic_pub.*.private_ip
  description = "The private IP of the Instance"
}
output "loadbalancer_public_dns" {
  value       = ncloud_lb.create_lb.domain
  description = "The lb DNS of the Instance"
}

