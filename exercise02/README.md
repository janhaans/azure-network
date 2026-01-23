# Excercise 02

Create in resource group `demo-rg`:

- Vnet `VNet1-hub` (10.1.0.0/16) and subnet `subnet1A` (10.1.1.0/24)
- Vnet `VNet2-spoke` (10.2.0.0/16) and subnet `subnet2A` (10.2.1.0/24)
- Vnet `VNet3-spoke` (10.3.0.0/16) and subnet `subnet3A` (10.3.1.0/24)
- Vnet `VNet4-spoke` (10.4.0.0/16) and subnet `subnet4A` (10.4.1.0/24)

All spoke VNet's are connected with hub VNet using VNet peering.

## Login Azure subsrciption

```
az login            # Choose your account and subscription
az account show     # Show you the details of the subscription that your commands will currently target
```

If you want to switch to another subscription

```
az account list --output table
az account set --subscription "Your Subscription Name or ID"
```

## Deploy

Before deployment validate the Bicep files. The `what-if` operation allows you to preview the changes that will be made to your environment without actually applying them.

```
az deployment sub what-if --name <deployment name> --location <region> --template-file <name bicep template>
```

When you run this command, the Azure CLI will compile your Bicep file and compare the desired state with the current state of your Azure resources. It will then output a summary showing which resources will be created, modified, or deleted. This is an excellent way to catch errors and verify that your template will do exactly what you expect before you run the actual deployment.

When everything is OK, you can deploy:

```
az deployment sub create --name <deployment name> --location <region> --template-file <naame bicep template>
```

### Deploy RG (subscription scope, incremental)

```
az deployment sub create \
 --template-file main.bicep \
 --location westeurope \
 --parameters main.bicepparam
```

### Deploy VNet/subnets (resource group scope, complete (remove resource not in template))

```
az deployment group create \
 --resource-group demo-rg \
 --template-file rg/networking-main.bicep \
 --parameters rg/networking-main.bicepparam \
 --mode Complete
```
