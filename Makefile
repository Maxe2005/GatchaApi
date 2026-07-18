# GatchaApi — root Makefile
# Orchestrates the full microservices stack via the root docker-compose.yaml.
# Per-service "restart-<svc>" targets rebuild+recreate ONLY that one container
# (no --no-cache, no full-stack downtime) — use build-svc-nocache / restart-svc
# with SVC=<name> for anything not covered by a named shortcut.
#
# Does NOT touch each API submodule's own standalone docker-compose.yml —
# those use the same container names/ports as this root stack and would
# conflict if run concurrently. All targets here operate on the root
# docker-compose.yaml only.

.DEFAULT_GOAL := help

.PHONY: help up down down-v reset-volumes ps logs build \
	pull-submodules init-submodules env \
	build-svc build-svc-nocache up-svc restart-svc logs-svc \
	restart-api-authentification restart-api-joueur restart-api-monsters \
	restart-api-invocations restart-api-generate-gatcha restart-gatcha-front restart-celery \
	build-api-authentification build-api-joueur build-api-monsters \
	build-api-invocations build-api-generate-gatcha build-gatcha-front build-celery \
	up-api-authentification up-api-joueur up-api-monsters \
	up-api-invocations up-api-generate-gatcha up-gatcha-front up-celery \
	front-dev front-build front-preview front-lint front-format front-typecheck

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-28s\033[0m %s\n", $$1, $$2}'

# ===== Stack-wide =====

up: ## Build (if needed) and start the whole stack in the background
	docker compose up -d --build

down: ## Stop and remove all containers (keeps volumes)
	docker compose down

down-v: ## Stop and remove all containers AND volumes (destructive: wipes all DB/minio data)
	docker compose down -v

reset-volumes: ## Reset all volumes and restart the stack fresh (mirrors README "Reset les volumes")
	docker compose down -v
	docker compose up -d

ps: ## Show status of all containers in the stack
	docker compose ps

logs: ## Tail logs for all services
	docker compose logs -f

build: ## Build all service images
	docker compose build

# ===== Submodules =====

pull-submodules: ## Update all git submodules to their tracked remote branch tip
	git submodule update --remote

init-submodules: ## Initialize submodules after a plain (non --recurse-submodules) clone
	git submodule update --init --recursive

# ===== Environment =====

env: ## Bootstrap .env from .env.exemple if .env does not already exist
	@test -f .env && echo ".env already exists, not overwriting" || cp .env.exemple .env

# ===== Generic single-service helpers (usage: make restart-svc SVC=api-joueur) =====

build-svc: ## Build a single service's image (usage: make build-svc SVC=api-joueur)
	docker compose build $(SVC)

build-svc-nocache: ## Build a single service's image without cache (usage: make build-svc-nocache SVC=api-joueur)
	docker compose build --no-cache $(SVC)

up-svc: ## Start/recreate a single service (usage: make up-svc SVC=api-joueur)
	docker compose up -d $(SVC)

restart-svc: ## Rebuild and restart a single service (usage: make restart-svc SVC=api-joueur)
	docker compose build $(SVC)
	docker compose up -d $(SVC)

logs-svc: ## Tail logs for a single service (usage: make logs-svc SVC=api-joueur)
	docker compose logs -f $(SVC)

# ===== Named per-service shortcuts =====

build-api-authentification:
	docker compose build api-authentification
up-api-authentification:
	docker compose up -d api-authentification
restart-api-authentification: ## Rebuild and restart api-authentification only (config/code change)
	docker compose build api-authentification
	docker compose up -d api-authentification

build-api-joueur:
	docker compose build api-joueur
up-api-joueur:
	docker compose up -d api-joueur
restart-api-joueur: ## Rebuild and restart api-joueur only (config/code change)
	docker compose build api-joueur
	docker compose up -d api-joueur
logs-api-joueur: ## Tail logs for api-joueur only
	docker compose logs -f api-joueur

build-api-monsters:
	docker compose build api-monsters
up-api-monsters:
	docker compose up -d api-monsters
restart-api-monsters: ## Rebuild and restart api-monsters only (config/code change)
	docker compose build api-monsters
	docker compose up -d api-monsters
logs-api-monsters: ## Tail logs for api-monsters only
	docker compose logs -f api-monsters

build-api-invocations:
	docker compose build api-invocations
up-api-invocations:
	docker compose up -d api-invocations
restart-api-invocations: ## Rebuild and restart api-invocations only (config/code change)
	docker compose build api-invocations
	docker compose up -d api-invocations
logs-api-invocations: ## Tail logs for api-invocations only
	docker compose logs -f api-invocations

build-api-generate-gatcha:
	docker compose build api-generate-gatcha
up-api-generate-gatcha:
	docker compose up -d api-generate-gatcha
restart-api-generate-gatcha: ## Rebuild and restart api-generate-gatcha only (config/code change)
	docker compose build api-generate-gatcha
	docker compose up -d api-generate-gatcha
logs-api-generate-gatcha: ## Tail logs for api-generate-gatcha only
	docker compose logs -f api-generate-gatcha

build-gatcha-front:
	docker compose build gatcha-front
up-gatcha-front:
	docker compose up -d gatcha-front
restart-gatcha-front: ## Rebuild and restart gatcha-front only (config/code change)
	docker compose build gatcha-front
	docker compose up -d gatcha-front
logs-gatcha-front: ## Tail logs for gatcha-front only
	docker compose logs -f gatcha-front

build-celery:
	docker compose build celery
up-celery:
	docker compose up -d celery
restart-celery: ## Rebuild and restart the celery worker only (config/code change)
	docker compose build celery
	docker compose up -d celery
logs-celery: ## Tail logs for the celery worker only
	docker compose logs -f celery

# ===== Front-end (Gatcha_Front, local npm — not Docker) =====

front-dev: ## Run the front-end dev server locally (Vite, outside Docker)
	cd Gatcha_Front && npm run dev

front-build: ## Build the front-end for production locally
	cd Gatcha_Front && npm run build

front-preview: ## Preview the production front-end build locally
	cd Gatcha_Front && npm run preview

front-lint: ## Lint the front-end codebase (ESLint)
	cd Gatcha_Front && npm run lint

front-format: ## Format the front-end codebase (Prettier, writes changes)
	cd Gatcha_Front && npm run format

front-typecheck: ## Type-check the front-end codebase (tsc, no emit)
	cd Gatcha_Front && npm run typecheck
