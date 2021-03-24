# Equinix Network Edge example: Fortinet FortiGate firewall

This example shows how to create redundant Fortinet FortiGate firewall
device on Platform Equinix using Equinix Fortigate Terraform module and
Equinix Terraform provider.

In addition to pair of Fortigate devices, following resources are being created
in this example:

* SSH public key that will be configured on both devices
* two ACL templates, one for each of the device

The devices are created in Equinix managed mode with license subscription.
Remaining parameters include:

* medium hardware platform (4CPU cores, 8GB of memory)
* VM04 software package
* 100 Mbps of additional internet bandwidth on each device
