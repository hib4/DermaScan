.PHONY: up down build logs migrate makemigrations shell

up:
	docker compose up -d --build

down:
	docker compose down

build:
	docker compose build

logs:
	docker compose logs -f web

migrate:
	docker compose exec web alembic upgrade head

makemigrations:
	docker compose run --rm web alembic revision --autogenerate -m "$(or $(filter-out $@,$(MAKECMDGOALS)),auto)"

shell:
	docker compose exec web bash

%:
	@:
