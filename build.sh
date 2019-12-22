#!/bin/bash

# Exit the script if a command fails
set -e

# Build the container image
docker build -t nmag-www .

# Copy the output directory from the container
docker create -it --name nmag-www-temp nmag-www
docker cp nmag-www-temp:/nmag-www/output .
docker rm -f nmag-www-temp
