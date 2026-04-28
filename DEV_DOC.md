# Developer Documentation (Inception)

## Setting Up the Environment

### Prerequisites
- **Operating System**: Linux (typically Debian, Ubuntu, or an Alpine VM).
- **Tools**: `make`, `docker`, and `docker-compose` (or the `docker compose` plugin).

### Host Configuration
To properly resolve the local domain, ensure the domain name maps to `localhost` in your `/etc/hosts` file. Add the following line:
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
A `Makefile` located at the root directory is used to manage the `srcs/docker-compose.yml` setup:
- **Build and Start**: Run `make` or `make all`. This builds images from the provided Dockerfiles and starts all containers in detached mode.
- **Stop and Remove Containers**: Run `make clean` or `make down`. 
- **Full Reset**: Run `make fclean`. This will stop everything, remove all networks, images, and wipe the persistent volumes.
- **Restart**: Run `make re` (equivalent to `fclean` + `all`).

## Managing Containers and Volumes

- **View Logs**: For debugging startup scripts or runtime issues:
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
To prevent data loss when containers are recreated, persistent storage is handled via Docker volumes mapped to directories on the host machine:
- **MariaDB Data**: Stored persistently on the host at `/home/login/data/mariadb` and mounted into the database container at `/var/lib/mysql`. This safeguards posts, site configuration, and users.
- **WordPress Files**: Stored persistently on the host at `/home/login/data/wordpress` and mounted to the web and PHP containers at `/var/www/wordpress`. This preserves themes, plugins, and uploaded media files.