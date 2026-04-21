# User Documentation (Inception)

## Overview of Services
This stack provides a complete, containerized web hosting environment:
- **NGINX**: A secure web server handling SSL/TLS connections.
- **WordPress**: The content management system for the website.
- **MariaDB**: The relational database used by WordPress to store its data.

## Starting and Stopping the Project
To manage the project, use the provided `Makefile` at the root of the repository:
- **Start the project**: Run `make` or `make all`. This will build the containers if necessary and start them in the background.
- **Stop the project**: Run `make down` (or `make clean`) to safely stop and remove the containers.

## Accessing the Website and Administration Panel
Once the services are running:
- **Main Website**: Open your browser and navigate to `https://liliu.42.fr` . *Note: You may need to accept the self-signed SSL certificate warning in your browser.*
- **Administration Panel**: Access the WordPress admin dashboard at `https://liliu.42.fr/wp-admin`.

## Locating and Managing Credentials
All sensitive environment variables, passwords, and user details are securely stored in a `.env` file located in the `srcs/` directory. If you are an administrator, edit this `.env` file to update passwords or database configuration prior to starting the stack. 

## Checking if Services are Running Correctly
You can verify the status of the active services by running:
```bash
docker compose -f srcs/docker-compose.yml ps
```
All services (`nginx`, `wordpress`, `mariadb`) should display a status of `Up`. If you suspect an issue, you can inspect the real-time logs by running:
```bash
docker compose -f srcs/docker-compose.yml logs -f
```