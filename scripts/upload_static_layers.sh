#!/bin/bash

#Fetches the bom's static layers and uploads them to the data bucket static/ dir

ENABLED_RADARS_CONFIG=$1
BUCKET=$2
URL="http://www.bom.gov.au/products/radar_transparencies"
LAYERS="background.png locations.png topography.png"

radars=$(cat $ENABLED_RADARS_CONFIG | jq '.push_radars[]' | tr -d '"')


for radar in $radars
do
  echo $radar
  mkdir -p ./static/layers/$radar/512x512

  for layer in $LAYERS
  do
    location="$URL/$radar.$layer"
    wget -O ./static/layers/$radar/512x512/$layer $location
    aws s3 cp ./static/layers/$radar/512x512/$layer s3://$BUCKET/static/layers/$radar/512x512/$layer
  done
done
