Create Resource group
name: demo-rg
location: westeurope

Create VNet 10.1.0.0/16
name: VNet1-demo

Create Subnet 10.1.1.0/24
name: subnet1A

Create VM's
name: VM1
location: westeurope
Image: Ubuntu Server
VM architecture: x64
size: standard_B1S
authentication: SSH
vnet: VNet1-demo
subnet: subnet1A

name: VM2
location: westeurope
Image: Ubuntu Server
VM architecture: x64
size: standard_B1S
authentication: SSH
vnet: VNet1-demo
subnet: subnet1A
