#!/bin/bash

# Variables
GITHUB_URL="https://github.com/panda98r/docker-spring-boot-java-web-service-example.git"
APP_DIR="/var/www/html/springboot"
CLONE_DIR="/tmp/springboot-app"

#Install necessary packages
echo "Updating system packages..."
sudo apt update -y
sudo apt install -y openjdk-17-jdk maven git

#Clone the repository
echo "Cloning repository from $GITHUB_URL..."
if [ -d "$CLONE_DIR" ]; then
    sudo rm -rf "$CLONE_DIR"
fi
git clone "$GITHUB_URL" "$CLONE_DIR"

#Build the application using Maven
echo "Building the application..."
cd "$CLONE_DIR" || exit
mvn clean package

#Deploy the application
echo "Deploying the application to $APP_DIR..."
if [ -d "$APP_DIR" ]; then
    sudo rm -rf "$APP_DIR"
fi
sudo mkdir -p "$APP_DIR"
sudo cp -r "$CLONE_DIR/target/"* "$APP_DIR"

#Start the application
echo "Starting the Spring Boot application..."
sudo nohup java -jar "$APP_DIR/your-application.jar" > /dev/null 2>&1 &

#Verify the deployment
echo "The application has been deployed. Verify it by accessing http://127.0.0.1:8080"

