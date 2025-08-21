all: up

up:
	docker-compose -f ./srcs/docker-compose.yml up --build  -d
down:
	docker-compose -f ./srcs/docker-compose.yml down -v 

fclean: down
	docker system prune -a -f

re: clean all

.PHONY: all up down clean re