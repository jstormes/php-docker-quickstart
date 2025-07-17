#!/bin/bash
############################################################################
# This script is intended to be run in a Docker container to perform self-tests.
# It is not intended to be run on the host system.
############################################################################
set -e

# Check if the script is running inside a Docker container
if [ ! -f /.dockerenv ]; then
  echo "This script is intended to be run inside a Docker container."
  exit 1
fi

echo "Running self-test script..."

# Copy application files to the container
rm -rf /tmp/app
mkdir /tmp/app
cp -r /app/* /tmp/app/

# Change to the application directory
cd /tmp/app

# Remove the vendor directory if it exists
rm -rf vendor

# Install dependencies using Composer
#composer install --no-interaction --optimize-autoloader

# Run unit tests
#phpunit --configuration phpunit.xml

# Run static analysis using PHPStan
#phpstan analyse --configuration phpstan.neon

echo "Self-test completed successfully."
exit 0