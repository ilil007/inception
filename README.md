*This project has been created as part of the 42 curriculum by liliu.*

## Description
Inception is a system administration project designed to expand knowledge in infrastructure and containerization using Docker. The objective is to virtualize multiple Docker images and run them within a personal virtual machine, forming a small but structured infrastructure that follows specific constraints.

## Project description
This project heavily leverages Docker to containerize various services. By building our own Dockerfiles for each service directly from an Alpine or Debian base (here is Debian), we ensure a lightweight, custom, and secure environment without relying on pre-configured application images. The included sources encompass:
- **NGINX**: Functions as a reverse proxy and the single entry point to the system, handling secure TLS/SSL connections.
- **WordPress + php-fpm**: Provides dynamic website content management.
- **MariaDB**: Acts as the relational database storing WordPress data.

### Main Design Choices
The architecture isolates responsibilities by assigning one container per service. All containers communicate through a dedicated Docker network, ensuring separation and controlled interaction.

### Comparisons

#### Virtual Machines vs Docker
- **Virtual Machines (VMs)** virtualize the entire hardware stack, requiring a full guest operating system for each instance, which consumes significant CPU and RAM.
- **Docker (Containers)** shares the host OS kernel, allowing multiple isolated environments to run efficiently. Containers are significantly lighter, faster to start, and consume fewer resources than VMs.

#### Secrets vs Environment Variables
- **Environment Variables** are simple to pass into containers but can be exposed through logs, process lists, or `docker inspect` commands, potentially leading to security risks.
- **Secrets** (like Docker Swarm or Kubernetes secrets) store sensitive data securely as temporary in-memory files inside containers, minimizing exposure risks

#### Docker Network vs Host Network
- **Docker Network** provides an isolated virtual network where containers can communicate via internal DNS while remaining shielded from external access unless explicitly exposed.
- **Host Network** connects containers directly to the host’s network stack, sharing the same IP and ports. While this may reduce overhead, it significantly weakens isolation and security.

#### Docker Volumes vs Bind Mounts
- **Docker Volumes** are managed by Docker and persist independently of container lifecycles, making them ideal for storing database data.
- **Bind Mounts** link a specific path on the host filesystem directly to a path inside the container. They tie the container's operation to the host's specific directory structure (e.g., `~/data/` in this project).

## Instructions

### Prerequisites
- Docker & Docker Compose
- `sudo` access (to edit `/etc/hosts`)

### Setup & Execution
1. Create `/etc/hosts`: Add `127.0.0.1 liliu.42.fr` to your host machine's `/etc/hosts` file.
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
Artificial Intelligence tools (such as GitHub Copilot and ChatGPT) were used as support for drafting documentation, clarifying complex Docker configurations, debugging connectivity issues, and generating markdown structure. However, all core logic, architectural decisions, and Dockerfile implementations were independently written and fully understood by the author.
