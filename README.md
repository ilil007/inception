*This project has been created as part of the 42 curriculum by liliu.*

## Description
Inception is a system administration project that aims to broaden our knowledge of system administration by using Docker. The goal is to virtualize several Docker images, creating them in our own personal virtual machine. It involves setting up a small infrastructure composed of different services under specific rules.

## Project description
This project heavily leverages Docker to containerize various services. By building our own Dockerfiles for each service directly from an Alpine or Debian base (here is Debian), we ensure a lightweight, custom, and secure environment without relying on pre-configured application images. The included sources encompass:
- **NGINX**: Acting as a reverse proxy and the sole entry point to our infrastructure, ensuring secured connections via TLS/SSL.
- **WordPress + php-fpm**: Serving as the dynamic content manager for the website.
- **MariaDB**: Providing the relational database backend for WordPress.

### Main Design Choices
The infrastructure separates concerns by assigning one dedicated container per service. Containers communicate over an isolated Docker network.

### Comparisons

#### Virtual Machines vs Docker
- **Virtual Machines (VMs)** virtualize the entire hardware stack, requiring a full guest operating system for each instance, which consumes significant CPU and RAM.
- **Docker (Containers)** virtualizes the OS kernel, allowing multiple isolated user-space instances to run on the same host OS. This makes containers much more lightweight, faster to start, and less resource-heavy than VMs.

#### Secrets vs Environment Variables
- **Environment Variables** are simple to pass into containers but can be exposed through logs, process lists, or `docker inspect` commands, potentially leading to security risks.
- **Secrets** (like Docker Swarm or Kubernetes secrets) mount sensitive data securely as temporary in-memory files within the container, reducing the risk of accidental exposure.

#### Docker Network vs Host Network
- **Docker Network** creates an isolated, software-defined network where containers can resolve each other via internal DNS, walled off from external traffic unless explicitly published.
- **Host Network** directly binds the container to the host's networking stack, meaning the container shares the exact IP and port space as the host VM, offering potentially lower overhead but greatly reducing isolation and security.

#### Docker Volumes vs Bind Mounts
- **Docker Volumes** are managed directly by Docker and persist even if the container is removed. They are optimal for database storage and easily transportable.
- **Bind Mounts** link a specific path on the host filesystem directly to a path inside the container. They tie the container's operation to the host's specific directory structure (e.g., `~/data/` in this project).

## Instructions

### Prerequisites
- Docker & Docker Compose
- `sudo` access (to edit `/etc/hosts`)

### Setup & Execution
1. Configure `/etc/hosts`: Add `127.0.0.1 liliu.42.fr` to your host machine's `/etc/hosts` file.
2. Create the `.env` file at the root of the project with your valid configuration variables (e.g., `DOMAIN_NAME`, `DB_ROOT_PASSWORD`, `WP_DB_NAME`, etc.).
3. Run `make` or `make all` to create volumes, build images, and start all containers.
4. Visit `https://liliu.42.fr` in your browser.
5. To stop the environment, use `make down`. Use `make fclean` to complete wipe images, volumes, and data.

## Resources
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
- [WordPress Developer Resources](https://developer.wordpress.org/)

**AI Usage**
Artificial Intelligence tools (like GitHub Copilot/ChatGPT) were used as assistants for drafting documentation, explaining obscure Docker configurations, debugging service connectivity, and generating boilerplate markdown structures. The core logic and Dockerfile implementations remain solely written and understood by the author.
