## Copyright (c) 2023, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "region" {}

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
# variable "user_ocid" {}
# variable "fingerprint" {}
# variable "private_key_path" {}

# LSF master variables
variable "parent_compartment_ocid" {
  description = "Parent compartment of LSF master node."
}
variable "master_ad" {
  description = "Availability Domain where to deploy LSF master node."
}
variable "master_shape" {
  description = "Compute shape of the LSF master node."
}
variable "master_image" {
  description = "OS image to use for LSF master node. It's recommended to go with Oracle Linux 8.x."
}
variable "master_bootv_size_gbs" {
  description = "LSF master node boot volume size in GBs."
  type        = number
  default     = 50
}
variable "master_ocpus" {
  description = "Number of OCPUs for LSF master node."
  type        = number
  default     = 2
}
variable "master_memory_gbs" {
  description = "Amount of RAM in GBs for LSF master node."
  type        = number
  default     = 8
}
variable "master_hostname" {
  description = "Hostname for LSF Master node."
  default     = "lsf-master-1"
}
variable "assign_public_ip" {
  description = "Either to assign public IP or not to LSF master node."
  default     = false
  type        = bool
}
variable "lsf_subnet" {
  description = "Subnet to use for LSF deployment."
}
variable "ssh_public_key" {
  description = "SSH Public key to use for LSF master node."
}

variable "freeform_tags" {
  type    = map(string)
  default = {}
}
variable "defined_tags" {
  type    = map(string)
  default = {}
}

# LSF installation files
variable "lsfinstaller" {
  description = "URL for LSFinstaller file (lsf10.1_lsfinstall.tar.Z)"
}
variable "lsfbin" {
  description = "URL for LSFbin file. (lsf10.1_lnx310-lib217-x86_64.tar.Z)"
}
variable "lsfpatch" {
  description = "URL for LSF Patch  file. (lsf10.1_lnx310-lib217-x86_64-601088.tar.Z)"
}
variable "lsf_entitlement" {
  description = "URL for LSF license file. (lsf_entitlement.dat)"
}

variable "release" {
  default = "v1.0"
}

variable "create_rc_policies" {
  default = true
}