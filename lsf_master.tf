## Copyright (c) 2023, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_instance" "lsf_master" {
  provider            = oci.target_region

  availability_domain = var.master_ad
  compartment_id      = var.parent_compartment_ocid
  shape               = var.master_shape
  agent_config {
    plugins_config {
        desired_state = "ENABLED"
        name          = "Bastion"
    }
     plugins_config {
        desired_state = "ENABLED"
        name          = "Management Agent"
    }
  }

  create_vnic_details {
    assign_public_ip = var.assign_public_ip
    freeform_tags    = var.freeform_tags
    defined_tags     = var.defined_tags
    hostname_label   = var.master_hostname
    subnet_id        = var.lsf_subnet
  }
  
  display_name    = var.master_hostname
    
  metadata        = {
    ssh_authorized_keys = var.ssh_public_key
  }

  shape_config {
    memory_in_gbs = var.master_memory_gbs
    ocpus         = var.master_ocpus
  }

  source_details {
    source_id   = var.master_image
    source_type = "image"
  }

  preserve_boot_volume = false
    
  freeform_tags = var.freeform_tags
  defined_tags  = merge(var.defined_tags, { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release })

  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"], 
      create_vnic_details[0].defined_tags["Oracle-Tags.CreatedBy"], create_vnic_details[0].defined_tags["Oracle-Tags.CreatedOn"]
    ]
  }
}


resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "oci_bastion_bastion" "bastion" {
  provider                     = oci.target_region

  bastion_type                 = "STANDARD"
  compartment_id               = var.parent_compartment_ocid
  target_subnet_id             = var.lsf_subnet
  name                         = "lsf-bastion"
  client_cidr_block_allow_list = ["0.0.0.0/0"]

  freeform_tags                = var.freeform_tags
  defined_tags                 = merge(var.defined_tags, { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release })

  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"]
    ]
  }
}

resource "null_resource" "wait_for_bastion_plugin" {
  depends_on = [ oci_core_instance.lsf_master ]

  provisioner "local-exec" {
    command = <<EOT
      timeout 20m bash -c -- 'while true; do [ ! $(oci instance-agent plugin get --instanceagent-id $INSTANCE_ID --compartment-id $COMPARTMENT_ID --plugin-name Bastion --query "data.status || 'NO_RESPONSE'" 2>/dev/null) == "RUNNING" ] && exit 0 ; echo "Waiting for bastion plugin to become active on lsf-master...";sleep 20; done;'
EOT
    interpreter = ["/bin/bash", "-c"]

    environment = {
      INSTANCE_ID    = oci_core_instance.lsf_master.id
      COMPARTMENT_ID = var.parent_compartment_ocid
    }
  }
}

resource "oci_bastion_session" "session" {
  depends_on  = [ null_resource.wait_for_bastion_plugin ]
  provider    = oci.target_region

  bastion_id  = oci_bastion_bastion.bastion.id
  key_type    ="PUB"
  key_details {
    public_key_content = tls_private_key.bastion_key.public_key_openssh
  }
  
  target_resource_details {
    session_type                               = "MANAGED_SSH"
    target_resource_id                         = oci_core_instance.lsf_master.id
    target_resource_operating_system_user_name = "opc"
  }

  display_name           = "lsf-bastion-session"
  session_ttl_in_seconds = 10800 
}

resource "null_resource" "setup_lsf" {
  depends_on = [oci_bastion_session.session]
  
  provisioner "local-exec" {
    command     = "ansible-playbook -i ansible_playbooks/inventory.ini ansible_playbooks/lsf_play.yml"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
}

