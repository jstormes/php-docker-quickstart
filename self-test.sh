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

# Copy application files to the container's temporary directory
rm -rf /tmp/app
mkdir /tmp/app
cp -r /app/* /tmp/app/

# Change to the temporary directory
cd /tmp/app

# Remove the vendor directory if it exists
rm -rf vendor

# Install dependencies using Composer if composer.json exists
if [ -f composer.json ]; then
  echo "\n\nInstalling dependencies using Composer..."
  composer install --no-interaction --optimize-autoloader
else
  echo "\n\ncomposer.json not found. Skipping Composer installation."
fi

# Run unit tests if PHPUnit is phpunit.xml exists
if [ -f phpunit.xml ]; then
  echo "\n\nRunning PHPUnit tests..."
  vendor/bin/phpunit --configuration phpunit.xml
else
  echo "\n\nphpunit.xml not found. Skipping PHPUnit tests."
fi

# Run static analysis using PHPStan
#phpstan analyse --configuration phpstan.neon

echo "\n\n!!!!!!!!!!!! Self-test completed successfully !!!!!!!!!!!!\n\n"
exit 0