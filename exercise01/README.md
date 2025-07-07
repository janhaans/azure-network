# Scope

ResourceGroup: name = CharisTechRG, region = east US

VNET: name = CoreServicesVNet, IP space = 10.10.0.0/16

- Subnet: name = SharedServicesSubnet, IP space = 10.10.1.0/24
- Subnet: name = DatabaseSubnet, IP space = 10.10.2.0/24
- Subnet: name = PublicWebServiceSubnet, IP space = 10.10.3.0/24

VNet: name = EngineeringVNet, IPv4 = 10.20.0.0/16, IPv6 = fd00:db8:deca::/48

- Subnet: name = EngSubnet1, IPv4 = 10.20.1.0/24, IPv6 = fd00:db8:deca:1::/64
- Subnet: name = EngSubnet2, IPv4 = 10.20.2.0/24, IPv6 = fd00:db8:deca:2::/64

WebVM01:

- name=WebVM01
- group=CharisTechRG
- location=eastus
- VNet=CoreServicesVNet
- subnet=PublicWebServiceSubnet
- size=Standard_B2s
- adminUsername='azureuser'
- sshPublicKey=<public-key>
- private IP assignment=Dynamic

WebVM02:

- name=WebVM02
- group=CharisTechRG
- location=eastus
- VNet=CoreServicesVNet
- subnet=PublicWebServiceSubnet
- size=Standard_B2s
- adminUsername='azureuser'
- sshPublicKey=<public-key>
- private IP assignment=Static(10.10.3.10)

# Login Azure subsrciption

```
az login            # Choose your account and subscription
az account show     # Show you the details of the subscription that your commands will currently target
```

If you want to switch to another subscription

```
az account list --output table
az account set --subscription "Your Subscription Name or ID"
```

# Deploy

Before deployment validate the Bicep files. The `what-if` operation allows you to preview the changes that will be made to your environment without actually applying them.

```
az deployment sub what-if --name CharisTechValidation --location eastus --template-file main.bicep
```

When you run this command, the Azure CLI will compile your Bicep file and compare the desired state with the current state of your Azure resources. It will then output a summary showing which resources will be created, modified, or deleted. This is an excellent way to catch errors and verify that your template will do exactly what you expect before you run the actual deployment.

When everything is OK, you can deploy:

```
az deployment sub create --name CharisTechDeployment --location eastus --template-file main.bicep
```

## Bicep files are idempotent.

Idempotency is a core principle of Infrastructure as Code (IaC) and means that no matter how many times you run the same deployment, the end result will always be the same.

When you deploy a Bicep file, the Azure Resource Manager (ARM) service checks the current state of the resources in Azure. It then compares this to the desired state defined in your Bicep file:

- If a resource in your file doesn't exist, ARM creates it.
- If a resource already exists and its configuration matches what's in your file, ARM does nothing.
- If a resource already exists but its configuration is different, ARM updates the resource to match your file.

# Verify

Verify the list VNet's using the `az network VNet list` command:

```
az network VNet list --resource-group CharisTechRG --output table
```

Verify the list of VM's using the `az vm list` command:

```
az vm list --resource-group CharisTechRG --output table
```

Review the private IP assignment of the VM network interfaces using the `az network nic list` command:

```
az network nic list -g CharisTechRG --query "[*].{NIC:name, PrivateIP:ipConfigurations[0].privateIPAddress, Assignment:ipConfigurations[0].privateIPAllocationMethod, IPVersion:ipConfigurations[0].privateIPAddressVersion}" -o table
```

# Delete

Since all the resources (the VNet and its subnets) were created inside a single resource group, the easiest and cleanest way to remove everything is to delete that resource group.

You can do this with a single Azure CLI command:

```
az group delete --name CharisTechRG --yes           # --yes skips the confirmation
```
