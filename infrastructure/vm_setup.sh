#!/bin/bash

RESOURCE_GROUP="soc-lab"
VM_NAME="soc-vm"

az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --image UbuntuLTS \
  --admin-username azureuser \
  --generate-ssh-keys
