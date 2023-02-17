
output "private_key_bastion" {
  sensitive = true
  value     = tls_private_key.bastion_key.private_key_openssh
}


output "LSF_Master_hostname" {
  value = oci_core_instance.lsf_master.display_name
   
}

output "LSF_Master_private_ip" {
  value = oci_core_instance.lsf_master.private_ip
}


output "LSF_Master_public_ip" {
  value = var.assign_public_ip ? oci_core_instance.lsf_master.public_ip : "n/a"
}

output "LSF_bastion_connection" {
  value       = oci_bastion_session.session.ssh_metadata["command"]
  description = <<-EOT
  The Bastion session terminates automatically in 3 hours after creation.
  For required private_key check private_key_bastion output.
  EOT
}