output "ip_address" {
  value       = "${linode_instance.vpn.ip_address}"
  description = "Public IP of the Linode"
}
