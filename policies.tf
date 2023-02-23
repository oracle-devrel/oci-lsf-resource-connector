## Copyright (c) 2023, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


resource "oci_identity_dynamic_group" "lsf-master-dg" {
  count          = var.create_rc_policies ? 1 : 0

  provider       = oci.home_region

  name           = "lsf-master-dg-${random_id.tag.hex}"
  description    = "Dynamic group for LSF master node"
  compartment_id = var.tenancy_ocid
  matching_rule  = "All {instance.compartment.id = '${var.parent_compartment_ocid}', tag.${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}.value='${var.release}'}"

  freeform_tags  = var.freeform_tags
  defined_tags   = merge(var.defined_tags, { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release })

  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"]
    ]
  }
}

resource "oci_identity_policy" "lsf_rc_compute" {
  count          = var.create_rc_policies ? 1 : 0
  
  provider       = oci.home_region
  name           = "lsf-resource-connector-compute-${random_id.tag.hex}"
  description    = "Policies to allow LSF resource connector access to compute resources"
  compartment_id = var.parent_compartment_ocid

  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.lsf-master-dg[0].name} to manage instance-family in compartment id ${var.parent_compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.lsf-master-dg[0].name} to use volume-family in compartment id ${var.parent_compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.lsf-master-dg[0].name} to use virtual-network-family in compartment id ${var.parent_compartment_ocid}"
  ]
  
  freeform_tags  = var.freeform_tags
  defined_tags   = merge(var.defined_tags, { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release })

  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"]
    ]
  }
}

resource "oci_identity_policy" "lsf_rc_network" {
  count          = var.create_rc_policies ? 1 : 0

  provider       = oci.home_region
  name           = "lsf-resource-connector-network-${random_id.tag.hex}"
  description    = "Policies to allow LSF resource connector access to network resources"
  compartment_id = data.oci_core_subnet.lsf_subnet.compartment_id

  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.lsf-master-dg[0].name} to use virtual-network-family in compartment id ${data.oci_core_subnet.lsf_subnet.compartment_id}"
  ]
  
  freeform_tags  = var.freeform_tags
  defined_tags   = merge(var.defined_tags, { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release })

  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"]
    ]
  }
}