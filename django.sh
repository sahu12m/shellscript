#!/bin/bash

# Variables
PROJECT_DIR="/var/www/html/Django/First_Django_App"
NGINX_CONF="/etc/nginx/sites-available/django.local"
NGINX_SYMLINK="/etc/nginx/sites-enabled/django.local"
GUNICORN_SERVICE_FILE="/etc/systemd/system/gunicorn.service"
REPO_URL="https://github.com/panda98r/Django.git"
REQUIREMENTS_FILE="$PROJECT_DIR/requirements.txt"

#Check if Nginx is installed, install if not
if ! command -v nginx &> /dev/null; then
    echo "Nginx is not installed. Installing..........."
    sudo apt update
    sudo apt install -y nginx
else
    echo "Nginx is already installed............"
fi

#Start Nginx service if not running
if ! systemctl is-active --quiet nginx; then
    echo "Starting Nginx service............"
    sudo systemctl start nginx
    sudo systemctl enable nginx
else
    echo "Nginx service is already running..............."
fi

#Check if Gunicorn is installed, install if not
if ! which gunicorn &> /dev/null; then
    echo "Gunicorn is not installed. Installing............."
    pip install gunicorn
else
    echo "Gunicorn is already installed............."
fi

#Delete the existing /var/www/html/Django folder
if [ -d "/var/www/html/Django" ]; then
    echo "Deleting existing /var/www/html/Django folder..............."
    sudo rm -rf /var/www/html/Django
fi

Create /var/www/html/Django folder
echo "Creating /var/www/html/Django folder..........."
sudo mkdir -p /var/www/html/Django

#Set permissions to directory
echo "Setting permissions for /var/www/html/Django.........."
sudo chown -R $USER:$USER /var/www/html/Django
sudo chmod -R 755 /var/www/html/Django

#Clone the Django project if not already present, or pull the latest changes
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Cloning the Django project from GitHub............"
    git clone $REPO_URL $PROJECT_DIR
    if [ -d "$PROJECT_DIR" ]; then
        echo "Repository successfully cloned to $PROJECT_DIR..........."
    else
        echo "Failed to clone the repository..............."
    fi
else
    echo "Django project already exists at $PROJECT_DIR. Pulling latest changes................"
    cd $PROJECT_DIR
    git pull origin main
fi

#Install dependencies from requirements.txt
echo "Installing dependencies from requirements.txt................."
if [ -f "$REQUIREMENTS_FILE" ]; then
    pip install -r $REQUIREMENTS_FILE
else
    echo "Requirements.txt not found. Skipping dependencies installation................"
fi

#Modify ALLOWED_HOSTS and Static Files Settings in Django settings
echo "Modifying ALLOWED_HOSTS and static files settings in Django settings..................."

find_settings_file() {
    find $1 -name "settings.py" -type f
}

DJANGO_SETTINGS_FILE=$(find_settings_file "$PROJECT_DIR")

if [ -f "$DJANGO_SETTINGS_FILE" ]; then
    echo "Found settings.py at $DJANGO_SETTINGS_FILE"

    # Update ALLOWED_HOSTS
    if ! grep -q "127.0.0.1" "$DJANGO_SETTINGS_FILE"; then
        echo "Modifying ALLOWED_HOSTS in $DJANGO_SETTINGS_FILE....................."
        sudo sed -i "s/^ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = \['127.0.0.1'\]/" "$DJANGO_SETTINGS_FILE"
    else
        echo "ALLOWED_HOSTS already contains '127.0.0.1'......................."
    fi

    # Add import os if not already present
    if ! grep -q "import os" "$DJANGO_SETTINGS_FILE"; then
        echo "Adding 'import os' to $DJANGO_SETTINGS_FILE....................."
        sudo sed -i "1i import os" "$DJANGO_SETTINGS_FILE"
    else
        echo "'import os' is already present in $DJANGO_SETTINGS_FILE......................."
    fi

    # Add STATIC_URL if not present
    if ! grep -q "STATIC_URL" "$DJANGO_SETTINGS_FILE"; then
        echo "Adding STATIC_URL to $DJANGO_SETTINGS_FILE....................."
        echo "\nSTATIC_URL = '/static/'" | sudo tee -a "$DJANGO_SETTINGS_FILE" > /dev/null
    else
        echo "STATIC_URL is already defined in $DJANGO_SETTINGS_FILE......................."
    fi

    # Add STATIC_ROOT if not present
    if ! grep -q "STATIC_ROOT" "$DJANGO_SETTINGS_FILE"; then
        echo "Adding STATIC_ROOT to $DJANGO_SETTINGS_FILE....................."
        echo "\nSTATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')" | sudo tee -a "$DJANGO_SETTINGS_FILE" > /dev/null
    else
        echo "STATIC_ROOT is already defined in $DJANGO_SETTINGS_FILE......................."
    fi

    # Add MEDIA_URL and MEDIA_ROOT if not present
    if ! grep -q "MEDIA_URL" "$DJANGO_SETTINGS_FILE"; then
        echo "Adding MEDIA_URL and MEDIA_ROOT to $DJANGO_SETTINGS_FILE....................."
        echo "\nMEDIA_URL = '/media/'" | sudo tee -a "$DJANGO_SETTINGS_FILE" > /dev/null
        echo "MEDIA_ROOT = os.path.join(BASE_DIR, 'media')" | sudo tee -a "$DJANGO_SETTINGS_FILE" > /dev/null
    else
        echo "MEDIA_URL and MEDIA_ROOT are already defined in $DJANGO_SETTINGS_FILE......................."
    fi

else
    echo "settings.py not found in the project directory. Skipping ALLOWED_HOSTS and static files settings modification............................."
fi

#Collect Static Files
echo "Collecting static files................."
cd $PROJECT_DIR/First_Django_project
python3 manage.py collectstatic --noinput

#Configure Gunicorn and Nginx
echo "Creating Nginx configuration file"
sudo tee $NGINX_CONF > /dev/null <<EOL
server {
    listen 80;
    server_name 127.0.0.1;

    location /static/ {
        alias /var/www/html/Django/First_Django_App/First_Django_project/static/;
    }

    location /media/ {
        alias /var/www/html/Django/First_Django_App/First_Django_project/media/;
    }

    location / {
        proxy_pass http://unix:/var/www/html/Django/First_Django_App/First_Django_project/gunicorn.sock;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

sudo ln -s $NGINX_CONF $NGINX_SYMLINK
sudo systemctl reload nginx

# Create Gunicorn service
sudo tee $GUNICORN_SERVICE_FILE > /dev/null <<EOL
[Unit]
Description=gunicorn daemon for First_Django_App
After=network.target

[Service]
User=$USER
Group=www-data
WorkingDirectory=/var/www/html/Django/First_Django_App/First_Django_project/
ExecStart=/usr/local/bin/gunicorn --workers 3 --bind unix:/var/www/html/Django/First_Django_project/gunicorn.sock First_Django_project.wsgi:application

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
sudo systemctl restart gunicorn

