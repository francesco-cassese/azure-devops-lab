#!/usr/bin/env bash

RG="rg-ud07-auto"
LOCATION="italynorth"

EXISTS=$(az group exists --name "$RG")

if [ "$EXISTS" = "false" ]; then
  echo "Il Resource Group non esiste: lo creo."
  az group create \
    --name "$RG" \
    --location "$LOCATION" \
    --output table
else
  echo "Il Resource Group esiste già: lo riutilizzo."
fi

az group update \
  --name "$RG" \
  --tags ManagedBy=Autonomo UD=07 \
  --output none

az group show \
  --name "$RG" \
  --query "{Name:name,Location:location,State:properties.provisioningState}" \
  --output table
