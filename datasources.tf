## Copyright (c) 2023, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Gets home and target regions (key/name)

data "oci_identity_tenancy" "tenant_details" {
  provider   = oci.target_region
  
  tenancy_id = var.tenancy_ocid
}

data "oci_identity_regions" "home_region" {
  provider = oci.target_region

  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenant_details.home_region_key]
  }
}

data "oci_identity_regions" "current_region" {
  provider = oci.target_region

  filter {
    name   = "name"
    values = [var.region]
  }
}

data "template_file" "ansible_inventory" {
  template = "${file("${path.root}/templates/inventory.ini.tpl")}"
  vars = {
    lsf_master_hostname            = "${oci_core_instance.lsf_master.display_name}"
    lsf_master_private_ip          = "${oci_core_instance.lsf_master.private_ip}"
    lsfinstaller                   = var.lsfinstaller
    lsfbin                         = var.lsfbin
    lsfpatch                       = var.lsfpatch
    lsf_entitlement                = var.lsf_entitlement
    ssh_private_key_path           = local.ssh_private_key_path
    ssh_proxy_command              = replace(local.ssh_proxy_command, "<privateKey>", "${local.ssh_private_key_path} -o StrictHostKeyChecking=no")
    lsf_rc_instances_compartmentid = var.parent_compartment_ocid
    lsf_rc_image                   = var.master_image
    lsf_subnet_id                  = var.lsf_subnet
    lsf_subnet_domain              = data.oci_core_subnet.lsf_subnet.subnet_domain_name
    lsf_subnet_cidr                = data.oci_core_subnet.lsf_subnet.cidr_block
  }
}

data "oci_core_subnet" "lsf_subnet" {
    subnet_id = var.lsf_subnet
}

