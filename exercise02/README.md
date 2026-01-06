# Excercise 02

Create in resource group `demo-rg`:

- Vnet `hub-vnet` (10.1.0.0/16) and subnet `hub-subnet1` (10.1.1.0/24)
- Vnet `spoke1-vnet` (10.2.0.0/16) and subnet `spoke1-subnet1` (10.2.1.0/24)
- Vnet `spoke2-vnet` (10.3.0.0/16) and subnet `spoke2-subnet1` (10.3.1.0/24)
- Vnet `spoke3-vnet` (10.4.0.0/16) and subnet `spoke3-subnet1` (10.4.1.0/24)

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
az deployment sub what-if --name exercise02 --location westeurope --template-file main.bicep
```

When you run this command, the Azure CLI will compile your Bicep file and compare the desired state with the current state of your Azure resources. It will then output a summary showing which resources will be created, modified, or deleted. This is an excellent way to catch errors and verify that your template will do exactly what you expect before you run the actual deployment.

When everything is OK, you can deploy:

```
az deployment sub create --name exercise02 --location westeurope --template-file main.bicep
```
