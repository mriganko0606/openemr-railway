#!/bin/sh
set -e

# Update Apache port configuration
if [ -z "$PORT" ]; then
    echo "PORT is not set, defaulting to 80"
    PORT=80
fi

echo "Configuring Apache to listen on port $PORT..."
# Function to replace port in file if it exists
replace_port() {
    if [ -f "$1" ]; then
        sed -i "s/Listen 80/Listen $PORT/g" "$1"
        echo "Updated $1"
    else
        echo "File $1 not found, skipping"
    fi
}

replace_port "/etc/apache2/httpd.conf"
replace_port "/etc/apache2/ports.conf"

# Start Apache
echo "Starting httpd..."
exec httpd -D FOREGROUND
