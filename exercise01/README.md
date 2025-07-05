# Scope

ResourceGroup: name = CharisTechRG, region = east US

VNET: name = CoreServicesVNet, IP space = 10.10.0.0/16

- Subnet: name = SharedServicesSubnet, IP space = 10.10.1.0/24
- Subnet: name = DatabaseSubnet, IP space = 10.10.2.0/24
- Subnet: name = PublicWebServiceSubnet, IP space = 10.10.3.0/24

VNet: name = EngineeringVNet, IPv4 = 10.20.0.0/16, IPv6 = fd00:db8:deca::/48

- Subnet: name = EngSubnet1, IPv4 = 10.20.1.0/24, IPv6 = fd00:db8:deca:1::/64
- Subnet: name = EngSubnet2, IPv4 = 10.20.2.0/24, IPv6 = fd00:db8:deca:2::/64

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

# Verify

```
az network VNet list --resource-group CharisTechRG --output table
```

# Delete

Since all the resources (the VNet and its subnets) were created inside a single resource group, the easiest and cleanest way to remove everything is to delete that resource group.

You can do this with a single Azure CLI command:

```
az group delete --name CharisTechRG --yes           # --yes skips the confirmation
```
