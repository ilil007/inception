COMPOSE_FILE=srcs/docker-compose.yml
LOGIN=liliu
DATA_DIR=/home/$(LOGIN)/data
VOLUMES=$(DATA_DIR)/mariadb $(DATA_DIR)/wordpress

all: create-volumes up

create-volumes:
	@mkdir -p $(VOLUMES)

up:
	docker compose -f $(COMPOSE_FILE) up -d

build:
	docker compose -f $(COMPOSE_FILE) build

rebuild:
	docker compose -f $(COMPOSE_FILE) up -d --build

start:
	docker compose -f $(COMPOSE_FILE) start

stop:
	docker compose -f $(COMPOSE_FILE) stop

down:
	docker compose -f $(COMPOSE_FILE) down

rebuild-wordpress:
	docker compose -f $(COMPOSE_FILE) build wordpress
	docker compose -f $(COMPOSE_FILE) up -d wordpress

restart: stop start

clean: down
	docker system prune -af --volumes

# remove all, including images, containers, volumes, and networks
fclean: down
	-docker run --rm -v $(DATA_DIR):/data -e HOST_UID=$$(id -u $(LOGIN)) -e HOST_GID=$$(id -g $(LOGIN)) alpine chown -R $$(id -u $(LOGIN)):$$(id -g $(LOGIN)) /data 2>/dev/null
	docker compose -f $(COMPOSE_FILE) down --rmi all --volumes --remove-orphans
	docker system prune -af --volumes
	-rm -rf $(DATA_DIR) 2>/dev/null || true

evaluation:
	-@docker stop $$(docker ps -qa) 2>/dev/null || true
	-@docker rm $$(docker ps -qa) 2>/dev/null || true
	-@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	-@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	-@docker network rm $$(docker network ls -q) 2>/dev/null || true
	-@docker run --rm -v $(DATA_DIR):/data alpine chown -R $$(id -u $(LOGIN)):$$(id -g $(LOGIN)) /data 2>/dev/null || true
	-@rm -rf $(DATA_DIR) 2>/dev/null || true

re:
	@$(MAKE) fclean
	@$(MAKE) all

ps:
	docker compose -f $(COMPOSE_FILE) ps

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

.PHONY: all up build rebuild start stop down clean fclean re ps logs evaluation