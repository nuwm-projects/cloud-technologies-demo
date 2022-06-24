.PHONY: help

help:
	$(info Helper for counter demo docker project)

build:
	docker build --platform linux/amd64 -t maxxx00m/counter-app:latest .
	docker push maxxx00m/counter-app:latest

run-dev:
	docker compose -f docker-compose-dev.yml up

build-dev:
	docker compose -f docker-compose-dev.yml build