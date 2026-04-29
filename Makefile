.ONESHELL:
SHELL 			:= /bin/sh

COMPOSE_PATH	:= srcs/docker-compose.yml
LOGIN			:= liliu
BASE_DIR		:= /home/$(LOGIN)/data
VM_DIRS			:= $(BASE_DIR)/mariadb $(BASE_DIR)/wordpress

all: setup-volumes up

setup-volumes:
	@mkdir -p $(VM_DIRS)

up:
	docker compose -f $(COMPOSE_PATH) up -d

build:
	docker compose -f $(COMPOSE_PATH) build

rebuild:
	docker compose -f $(COMPOSE_PATH) up -d --build

start:
	docker compose -f $(COMPOSE_PATH) start

stop:
	docker compose -f $(COMPOSE_PATH) stop

down:
	docker compose -f $(COMPOSE_PATH) down --rmi all --volumes --remove-orphans

wp-restart:
	docker compose -f $(COMPOSE_PATH) build wordpress
	docker compose -f $(COMPOSE_PATH) up -d wordpress

restart: stop start

clean: down
	docker system prune -af --volumes 

fclean: down
	-docker run --rm -v $(BASE_DIR):/data -e HOST_UID=$$(id -u $(LOGIN)) -e HOST_GID=$$(id -g $(LOGIN)) alpine chown -R $$(id -u $(LOGIN)):$$(id -g $(LOGIN)) /data 2>/dev/null
	docker compose -f $(COMPOSE_PATH) down --rmi all --volumes --remove-orphans
	docker system prune -af --volumes

evaluation:
	-@docker stop $$(docker ps -qa) 2>/dev/null || true
	-@docker rm $$(docker ps -qa) 2>/dev/null || true
	-@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	-@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	-@docker network rm $$(docker network ls -q) 2>/dev/null || true
	-@docker run --rm -v $(BASE_DIR):/data alpine chown -R $$(id -u $(LOGIN)):$$(id -g $(LOGIN)) /data 2>/dev/null || true
	-@rm -rf $(BASE_DIR) 2>/dev/null || true

re:
	@$(MAKE) fclean
	@$(MAKE) all

ps:
	docker compose -f $(COMPOSE_PATH) ps

logs:
	docker compose -f $(COMPOSE_PATH) logs -f

.PHONY: all setup-volumes up build rebuild start stop down wp-restart restart clean fclean evaluation re ps logs