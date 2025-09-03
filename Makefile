all: up

up:
	docker compose -f srcs/docker-compose.yaml up --build -d

down:
	docker compose -f srcs/docker-compose.yaml down -v

fclean: down
	docker system prune -a -f

re: fclean all

.PHONY: all up down clean re
