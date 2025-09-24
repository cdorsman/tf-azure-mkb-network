# Create Custom HTML Page
# This script creates a custom index.html for the MKB web server using NGINX default structure

set -e

echo "Creating custom HTML page for NGINX..."

# NGINX default document root on Ubuntu (actual location used by nginx config)
NGINX_ROOT="/var/www/html"

# Create the custom HTML page in NGINX's default location
cat > "$NGINX_ROOT/index.html" << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>MKB Web Server</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 40px; 
            background-color: #f5f5f5; 
        }
        .container { 
            max-width: 800px; 
            margin: 0 auto; 
            background: white; 
            padding: 20px; 
            border-radius: 10px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
        }
        h1 { color: #2c3e50; }
        .info { background: #ecf0f1; padding: 10px; border-left: 4px solid #3498db; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to MKB Web Server</h1>
        <div class="info">
            <p><strong>Server:</strong> HOSTNAME_PLACEHOLDER</p>
            <p><strong>Time:</strong> TIME_PLACEHOLDER</p>
            <p><strong>Status:</strong> NGINX is running successfully</p>
            <p><strong>Document Root:</strong> /var/www/html</p>
        </div>
        <p>This server is part of the MKB Infrastructure monitoring system.</p>
    </div>
</body>
</html>
HTML

# Replace placeholders with actual values
sed -i "s/HOSTNAME_PLACEHOLDER/$(hostname)/g" "$NGINX_ROOT/index.html"
sed -i "s/TIME_PLACEHOLDER/$(date)/g" "$NGINX_ROOT/index.html"

# Set proper permissions for NGINX
chown www-data:www-data "$NGINX_ROOT/index.html"
chmod 644 "$NGINX_ROOT/index.html"

echo "Custom HTML page created successfully at: $NGINX_ROOT/index.html"