#!/bin/bash

set -e

# ==============================
# Configuration
# ==============================

RESOURCE_GROUP="cloud-soc-rg"
LOCATION="eastus"

VNET_NAME="soc-vnet"
SUBNET_WEB="web-subnet"
SUBNET_MONITOR="monitor-subnet"

NSG_NAME="soc-nsg"

WEB_VM="web-vm"
SOC_VM="soc-vm"

ADMIN_USER="azureuser"

echo "Starting Cloud SOC deployment..."

# ==============================
# Create Resource Group
# ==============================

echo "Creating resource group..."

az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# ==============================
# Create Virtual Network
# ==============================

echo "Creating Virtual Network..."

az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --address-prefix 10.0.0.0/16 \
  --subnet-name $SUBNET_WEB \
  --subnet-prefix 10.0.1.0/24

# Create second subnet

az network vnet subnet create \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET_MONITOR \
  --address-prefix 10.0.2.0/24

# ==============================
# Create Network Security Group
# ==============================

echo "Creating Network Security Group..."

az network nsg create \
  --resource-group $RESOURCE_GROUP \
  --name $NSG_NAME

# Allow SSH

az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name AllowSSH \
  --protocol Tcp \
  --priority 1000 \
  --destination-port-range 22 \
  --access Allow

# Allow HTTP

az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name AllowHTTP \
  --protocol Tcp \
  --priority 1001 \
  --destination-port-range 80 \
  --access Allow

# ==============================
# Deploy Web Server VM
# ==============================

echo "Deploying Web VM..."

az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $WEB_VM \
  --image Ubuntu2204 \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_WEB \
  --nsg $NSG_NAME \
  --admin-username $ADMIN_USER \
  --generate-ssh-keys \
  --size Standard_B2s

# ==============================
# Deploy SOC Monitoring VM
# ==============================

echo "Deploying SOC Monitoring VM..."

az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $SOC_VM \
  --image Ubuntu2204 \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_MONITOR \
  --nsg $NSG_NAME \
  --admin-username $ADMIN_USER \
  --generate-ssh-keys \
  --size Standard_B2s

# ==============================
# Get Public IPs
# ==============================

echo ""
echo "Deployment complete!"
echo ""

WEB_IP=$(az vm show \
  --resource-group $RESOURCE_GROUP \
  --name $WEB_VM \
  -d \
  --query publicIps \
  -o tsv)

SOC_IP=$(az vm show \
  --resource-group $RESOURCE_GROUP \
  --name $SOC_VM \
  -d \
  --query publicIps \
  -o tsv)

echo "Web Server Public IP: $WEB_IP"
echo "SOC Monitoring Public IP: $SOC_IP"

echo ""
echo "SSH into machines:"
echo "ssh $ADMIN_USER@$WEB_IP"
echo "ssh $ADMIN_USER@$SOC_IP"

**How to Run It**

**Install Azure CLI and login:**
az login

**Make the script executable:**
chmod +x deploy.sh

**Run:**
./deploy.sh

What This Script Builds in Azure

Infrastructure created:

Resource Group
    Virtual Network
    Web-subnet
    Monitor-subnet
  Network Security Group
  Web VM
  SOC Monitoring VM

