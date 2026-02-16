#!/bin/sh
set -e

# Update Apache port configuration
if [ -z "$PORT" ]; then
    echo "PORT is not set, defaulting to 80"
    PORT=80
fi

echo "Configuring Apache to listen on port $PORT..."
# Recursively replace Listen 80 in /etc/apache2/
find /etc/apache2/ -name "*.conf" -exec sed -i "s/Listen 80/Listen $PORT/g" {} +

# Ensure ServerName is set to avoid warnings/errors
if ! grep -q "ServerName localhost" /etc/apache2/httpd.conf; then
    echo "ServerName localhost" >> /etc/apache2/httpd.conf
fi

# Start Apache
echo "Starting httpd..."
# Apache on Alpine is usually at /usr/sbin/httpd
# We use exec to replace the shell process
exec httpd -D FOREGROUND
