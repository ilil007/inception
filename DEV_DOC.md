# Developer Documentation (Inception)

## Setting Up the Environment

### Prerequisites
- **Operating System**: Linux (typically Debian, Ubuntu, or an Alpine VM).
- **Tools**: `make`, `docker`, and `docker-compose` (or the `docker compose` plugin).

### Host Configuration
To correctly route traffic for the local domain, ensure the domain name maps to `localhost` in your `/etc/hosts` file. Add the following line:
```
127.0.0.1 liliu.42.fr
```

### Secrets and Initialization (`.env`)
Before building the project, create a `.env` file inside the `srcs/` directory. It must contain the necessary configuration values and secrets. Example format:
```env
DOMAIN_NAME=liliu.42.fr

# Database Configuration (MariaDB)
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=wp_pass
MYSQL_ROOT_PASSWORD=root_pass

# WordPress Configuration
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin_pass
WP_ADMIN_EMAIL=admin@liliu.42.fr
WP_USER=user
WP_USER_PASSWORD=user_pass
WP_USER_EMAIL=user@liliu.42.fr
```

## Building and Launching the Project
The project uses a `Makefile` at the root directory to orchestrate the `srcs/docker-compose.yml` configuration:
- **Build and Start**: Run `make` or `make all`. This triggers docker-compose to build the container images from local Dockerfiles and starts the environment in a detached state.
- **Stop and Remove Containers**: Run `make clean` or `make down`. 
- **Full Reset**: Run `make fclean`. This will stop everything, remove all networks, images, and wipe the persistent volumes.
- **Restart**: Run `make re` (combines `fclean` + `all`).

## Managing Containers and Volumes

- **View Logs**: To debug initialization scripts or runtime errors, use:
  ```bash
  docker compose -f srcs/docker-compose.yml logs -f <service_name>
  ```
- **Execute Commands inside a Container**:
  ```bash
  docker exec -it <container_name> /bin/bash # or /bin/sh for Alpine-based containers
  ```
- **List and Inspect Volumes**:
  ```bash
  docker volume ls
  docker volume inspect <volume_name>
  ```

## Data Storage and Persistence
To ensure that database entries and website media are not lost when containers are recreated, data persists using Docker volumes bound to host machine directories:
- **MariaDB Data**: Stored persistently on the host at `/home/login/data/mariadb` and mounted into the database container at `/var/lib/mysql`. This safeguards posts, site configuration, and users.
- **WordPress Files**: Stored persistently on the host at `/home/login/data/wordpress` and mounted to the web and PHP containers at `/var/www/wordpress`. This safeguards downloaded themes, plugins, and uploaded structural files.