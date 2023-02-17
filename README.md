# oci-lsf-resource-connector

[![License: UPL](https://img.shields.io/badge/license-UPL-green)](https://img.shields.io/badge/license-UPL-green) <!-- [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=robo-cap_oci-lsf-resource-connector)](https://sonarcloud.io/dashboard?id=robo-cap_oci-lsf-resource-connector) -->

## Introduction

[IBM Spectrum LSF](https://www.ibm.com/products/hpc-workload-management) (Load Sharing Facility) is a workload management platform used for distributed computing environments. It allows users to manage and schedule computer jobs across a network of computers or compute clusters, ensuring that jobs are completed efficiently and without disruption.

The [resource connector](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=connnector-lsf-resource-connector-overview) for IBM Spectrum LSF feature (previously referred to as host factory) enables LSF clusters to borrow resources from supported resource providers.

This is an example project that will deploy LSF 10.1 and configure Resource Connector to allocate compute resources in OCI.

## Prerequisite

All communication should be permitted **inside** the selected subnet.

## Getting Started

Store LSF required installation files in a bucket and generate [PARs](https://docs.oracle.com/en-us/iaas/Content/Object/Tasks/usingpreauthenticatedrequests.htm) (pre-authenticated requests) for each of below files:
 - `lsf10.1_lsfinstall.tar.Z`
 - `lsf10.1_lnx310-lib217-x86_64.tar.Z`
 - `lsf10.1_lnx310-lib217-x86_64-601088.tar.Z`
 - `lsf_entitlement.dat`

## Automated deployment

Click below button, fill-in required values and `Apply`.

[![Deploy to OCI](https://docs.oracle.com/en-us/iaas/Content/Resources/Images/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/robo-cap/oci-lsf-resource-connector/archive/refs/tags/v1.0.zip)


## Manual deployment

 **Prerequisites:** `bash`, `ansible`

1. Create a file named `terraform.auto.tfvars` in the root directory using below list of variables and update associated values based on your use-case:
```
tenancy_ocid            = "ocid1.tenancy.oc1...7dq"
user_ocid               = "ocid1.user.oc1...7wa"
private_key_path        = "/path/to/..../oci_api_key.pem"
private_key_password    = ""
fingerprint             = "aa:bb:cc:dd:ee:ff:00:11:22:33:44:55:66:77:88:99"
region                  = "eu-frankfurt-1"
compartment_ocid        = "ocid1.compartment.oc1...iqq"
parent_compartment_ocid = "ocid1.compartment.oc1...iqq"

master_ad               = "GqIF:EU-FRANKFURT-1-AD-1"
master_shape            = "VM.Standard.E4.Flex"
master_image            = "ocid1.image.oc1...eha"
master_bootv_size_gbs   = 50
master_ocpus            = 2
master_memory_gbs       = 16
master_hostname         = "lsf-master-1"
lsf_subnet              = "ocid1.subnet.oc1...uca"
ssh_public_key          = "<ssh_public_key_for_lsf_master_host>"
assign_public_ip        = false

lsfinstaller            = "https://<url_for_lsf10.1_lsfinstall.tar.Z>"
lsfbin                  = "https://<url_for_lsf10.1_lnx310-lib217-x86_64.tar.Z>"
lsfpatch                = "https://<url_for_lsf10.1_lnx310-lib217-x86_64-601088.tar.Z>"
lsf_entitlement         = "https://<url_for_lsf_entitlement.dat>"
```
2. Execute `terraform init`
3. Execute `terraform plan`
4. Execute `terraform apply`

## Customization

Update the below two files if you want to customize the shapes resource connector can borrow from OCI :
 - `ansible_playbooks/roles/lsf/templates/oci_config.json.j2`
 - `ansible_playbooks/roles/lsf/files/ociprov_templates.json`

In case the number of CPUs/ammount on memory is changed for existing flexible shapes in `oci_config.json.j2` file, don't forget to update the data in `ociprov_templates.json` for each templateID. 

## Test
  - To submit a new job to a resource connector enabled queue, execute:
  
    `bsub -q dynamic sleep 60`
  - To check job status, execute:
    
    `bjobs`
  - To list nodes, part of the cluster, execute:

    `bhosts` / `lshosts`

  - Resource connector logs are available in file:

    `/nfs/cluster/lsf/log/mbatchd.log.<lsf-master-hostname>`

## Notes/Issues
* Use a regional subnet.
* This deployment was tested only with LSF version 10.1 (lsf10.1_lnx310-lib217-x86_64.tar.Z) and LSF patch version 601088 (lsf10.1_lnx310-lib217-x86_64-601088).
* URLs to binaries and required license are not provided.

## URLs
* Nothing at this time

## Contributing
This project is open source. Please submit your contributions by forking this repository and submitting a pull request! Oracle appreciates any contributions that are made by the open-source community.

## License
Copyright (c) 2022 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.

ORACLE AND ITS AFFILIATES DO NOT PROVIDE ANY WARRANTY WHATSOEVER, EXPRESS OR IMPLIED, FOR ANY SOFTWARE, MATERIAL OR CONTENT OF ANY KIND CONTAINED OR PRODUCED WITHIN THIS REPOSITORY, AND IN PARTICULAR SPECIFICALLY DISCLAIM ANY AND ALL IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE.  FURTHERMORE, ORACLE AND ITS AFFILIATES DO NOT REPRESENT THAT ANY CUSTOMARY SECURITY REVIEW HAS BEEN PERFORMED WITH RESPECT TO ANY SOFTWARE, MATERIAL OR CONTENT CONTAINED OR PRODUCED WITHIN THIS REPOSITORY. IN ADDITION, AND WITHOUT LIMITING THE FOREGOING, THIRD PARTIES MAY HAVE POSTED SOFTWARE, MATERIAL OR CONTENT TO THIS REPOSITORY WITHOUT ANY REVIEW. USE AT YOUR OWN RISK. 
