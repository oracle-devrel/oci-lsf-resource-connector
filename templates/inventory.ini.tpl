[lsf]
${lsf_master_hostname} ansible_host=${lsf_master_private_ip}

[lsf:vars]
ansible_connection=ssh
lsf_master_servers="${lsf_master_hostname}"
lsfinstaller="${lsfinstaller}"
lsfbin="${lsfbin}"
lsfpatch="${lsfpatch}"
lsf_std_entitlement="${lsf_entitlement}"
lsf_owner="opc"
lsf_group="opc"
lsf_rc_host_prefix="lsf-rchost"
lsf_rc_instances_compartmentid="${lsf_rc_instances_compartmentid}"
lsf_rc_image="${lsf_rc_image}"
lsf_subnet_id="${lsf_subnet_id}"
lsf_subnet_domain="${lsf_subnet_domain}"
lsf_etcdir="/nfs/cluster/lsf/10.1/linux3.10-glibc2.17-x86_64/etc"

ansible_ssh_private_key_file="${ssh_private_key_path}"
ansible_user=opc
ansible_port=22
ansible_python_interpreter="/usr/bin/python3"
allowed_nfs_subnet="${lsf_subnet_cidr}"

# Below can be commented out if no bastion host is used.
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="${ssh_proxy_command}"'