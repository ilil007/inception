# User Documentation (Inception)

## Overview of Services
This stack provides a complete, containerized web hosting environment:
- **NGINX**: Acts as a secure web server managing HTTPS connections.
- **WordPress**: Serves as the website’s content management system.
- **MariaDB**: Provides the database backend for storing WordPress data.

## Starting and Stopping the Project
A Makefile is available at the root of the repository to simplify project management:
- **Start the project**: Execute `make` or `make all`. This will build the containers if necessary and start them in the background.
- **Stop the project**: Execute `make down` (or `make clean`) to safely stop and remove the containers.

## Accessing the Website and Administration Panel
After the services are up and running:
- **Website**: Visit `https://liliu.42.fr` in your browser . *Note: You may need to accept the self-signed SSL certificate warning in your browser.*
- **Administration Panel**: Access the WordPress admin dashboard at `https://liliu.42.fr/wp-admin`.

## Locating and Managing Credentials
All sensitive environment variables, passwords, and user details are securely stored in a `.env` file located in the `srcs/` directory. If you are an administrator, edit this `.env` file to update passwords or database configuration prior to starting the stack. 

## Checking if Services are Running Correctly
To confirm that all services are running correctly, use:
```bash
docker compose -f srcs/docker-compose.yml ps
```
All services (`nginx`, `wordpress`, `mariadb`) should display a status of `Up`. If you If troubleshooting is required, you can view live logs with:
```bash
docker compose -f srcs/docker-compose.yml logs -f
```