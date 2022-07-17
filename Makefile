.PHONY: $(shell egrep -oh ^[a-zA-Z0-9][a-zA-Z0-9\/_-]+: $(MAKEFILE_LIST) | sed 's/://')
.DEFAULT_GOAL := help
SHELL := /bin/bash

docker/build: ## Build containers
	docker compose build
docker/ps: ## Display of running containers
	docker compose ps
docker/up: ## Start containers
	docker compose up -d
docker/stop: ## Stop containers
	docker compose stop
docker/down: ## Destroy containers
	docker compose down --remove-orphans
docker/downv: ## Destroy containers, volumes and networks
	docker compose down -v --remove-orphans
docker/prune: ## Discard unneeded Docker images
	docker system prune -f
docker/restart: ## Restart containers
	docker compose restart
docker/login: ## Login to Go container
	docker compose exec golang bash

clean: ## Delete binary files
	docker compose exec golang rm -rf bin/*
deps: ## Install Dependencies
	docker compose exec golang go mod download
	docker compose exec golang go mod tidy
lint: ## Golangci-lint
	docker compose exec golang golangci-lint run ./...
test: ## Test
	docker compose exec golang go test -v ./...
build: ## Build
	make clean deps
	docker compose exec golang bash -c 'env CGO_ENABLED=0 GOOS=linux go build -o bin/handler'
help: ## Help
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9][a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ''
	@awk 'BEGIN {FS = ":.*?## "} /^docker\/[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
