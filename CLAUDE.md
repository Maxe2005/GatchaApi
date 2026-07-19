# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository shape

This is the **root/orchestration repo** for a Gatcha game built as microservices. It contains no application code of its own — each service lives in its own git submodule, wired together by the root `docker-compose.yaml` and shortcutted by the root `Makefile`.

| Submodule | Stack | Port (host) | DB |
|---|---|---|---|
| `API_authentification` | Spring Boot / Java | 8081 | MongoDB (`mongo-authentification`) |
| `API_joueur` | Spring Boot / Java | 8082 | MongoDB (`mongo-player`) |
| `API_monstres` | Spring Boot / Java | 8083 | MongoDB (`mongo-monsters`) |
| `API_invocations` | Spring Boot / Java | 8080 | PostgreSQL (`postgres-invocations`) |
| `API_generate_gatcha` | Python / FastAPI | 8084 (container 8000) | PostgreSQL (`postgres-generate-gatcha`) + Redis + MinIO + Celery worker |
| `Gatcha_Front` | Vite + TypeScript (React) | 3000 | — |

Since these are git submodules, `git status`/`git diff` at the root won't show in-submodule changes — `cd` into the submodule to work on its code, and remember commits there need to be pushed/committed independently of the root repo (which just tracks the submodule's pinned commit).

## Common commands (root Makefile)

Run `make help` to list everything. Key targets:

```bash
make up                          # docker compose up -d --build (whole stack)
make down / make down-v          # stop (down-v also wipes volumes/DB data)
make ps / make logs
make init-submodules             # git submodule update --init --recursive (after a plain clone)
make pull-submodules             # git submodule update --remote
make env                         # bootstrap .env from .env.exemple if missing

# Single-service (usage: make restart-svc SVC=api-joueur)
make build-svc SVC=<name> / make build-svc-nocache SVC=<name>
make up-svc SVC=<name> / make restart-svc SVC=<name> / make logs-svc SVC=<name>
# Named shortcuts also exist per service, e.g.:
make restart-api-invocations     # rebuild + restart just that container
make restart-celery               # the API_generate_gatcha Celery worker

# Front-end (runs locally via npm, NOT docker)
make front-dev / front-build / front-preview / front-lint / front-format / front-typecheck
```

The root `docker-compose.yaml` is the **only** way to run the stack: the submodules no longer ship a standalone `docker-compose.yml`, and their Makefiles (`make up/down/restart/logs/...` from inside a submodule) just proxy to the root compose file scoped to that one service. All runtime configuration is injected from this repo (root compose `environment:` blocks + root `.env`).

Service URLs once the stack is up: Front `:3000`, API Invocations Swagger `:8080/swagger-ui/index.html`, API Authentification Swagger `:8081/swagger-ui/index.html`, API Joueur Swagger `:8082/swagger-ui/index.html`, API Monstres Swagger `:8083/swagger-ui/index.html`, API Generate Gatcha docs `:8084/docs`, pgAdmin `:5050`, MinIO console `:9001`.

## Per-service commands

**Java services** (`API_authentification`, `API_joueur`, `API_monstres`, `API_invocations`) all use Maven wrapper from within the submodule:
```bash
./mvnw clean package
./mvnw test                                    # full suite
./mvnw test -Dtest=ClassName                   # single test class
./mvnw test -Dtest=ClassName#methodName        # single test method
```
- `API_invocations` is the most tooled: `mvn spotless:apply` to format (Google Java Format), `mvn checkstyle:check` to lint (`checkstyle.xml`, warnings only, won't fail build), or run the interactive `./format-lint.sh`. It also owns Flyway migrations (`src/main/resources/db/migration`) — schema is migration-owned (`ddl-auto: validate`), not Hibernate auto-generated.
- `API_monstres` has test dependencies (JUnit/Mockito) but currently no `src/test` directory — nothing to run yet.
- None of the Java services have automated linting except `API_invocations`.

**`API_generate_gatcha`** (Python):
```bash
make install                                   # creates .venv, installs requirements.txt
make run                                       # uvicorn app.main:app --reload, port 8000
make up / down / restart / logs                # docker via the ROOT compose (plus celery-up/celery-restart/... for the worker)
make db-alembic-revision MSG="..." / make db-alembic-up   # Alembic migrations
.venv/bin/pytest tests/test_validation_service.py::test_name   # single test (no pytest.ini/make test target exists)
```
No lint/format tooling is configured for this service.

**`Gatcha_Front`**:
```bash
npm run dev / build / preview
npm run lint          # ESLint
npm run format        # Prettier (writes)
npm run typecheck     # tsc --noEmit
```
There is no test framework configured (no Jest/Vitest despite a `babel.config.json` existing) — there is currently no way to run "a single test".

## Cross-service architecture

- **`API_authentification` is the identity source of truth**, but it does **not issue JWTs** — `POST /user/login` returns an opaque token that is really `username=...,expirationDate=...` AES-encrypted with a key derived from `AUTH_SECRET`/`AUTH_SALT`. Verification happens via `POST /user/verify-token`, checked by every other Java service.
- `API_joueur` and `API_monstres` both validate incoming requests with an `AuthInterceptor` (a Spring `HandlerInterceptor`, not a security filter) that calls out to `API_authentification`'s `/user/verify-token` over plain `RestTemplate`. It fails closed: 401 on invalid/missing token, 500 if the auth service itself is unreachable.
- **`API_invocations` is the orchestration hub**: it calls `API_authentification` (verify), `API_monstres` (create/delete monster), `API_joueur` (add monster to inventory), and `API_generate_gatcha`. It forwards the *original caller's* bearer token to downstream services via `BearerTokenRestTemplateInterceptor` rather than using a service credential — the caller's identity, not the invocations service's, is what downstream services see. Auth enforcement is feature-flagged (`app.auth.enabled` in `application.yml`) — check current value rather than assuming it's on.
- Invocation creation follows a **saga pattern with compensation**: if adding the monster to the player's inventory fails after the monster was already created, `API_invocations` automatically deletes the just-created monster rather than leaving orphaned data. It also supports replaying failed invocations. Rarity odds: COMMON 50% / RARE 30% / EPIC 15% / LEGENDARY 5% (dynamically adjustable), with 3 independently-rolled skills per monster.
- **`API_generate_gatcha` does not itself validate caller tokens** — it trusts network-level isolation rather than checking auth on its own endpoints — but it does forward a bearer token when calling `API_invocations`. It uses Google Gemini (`GEMINI_API_KEY`) for monster stat/text generation and Banana.dev (`BANANA_API_KEY`) for pixel-art image generation, with images produced asynchronously via a Celery worker (Redis-backed) and progress reported over a WebSocket (`/api/v1/monsters/images/ws/{batch_id}`). Generated assets are stored in MinIO (`raw-assets`/`game-assets` buckets). It has an explicit **monster state machine** (`app/models/monster/state.py`, `transition.py`, `update_event.py`) governing generation lifecycle.
- **`Gatcha_Front`** never calls backend hosts directly — all requests go through Vite dev-server proxies defined in `vite.config.js` (`/auth-service`, `/joueur-service`, `/monsters-service`, `/invocation-service`, `/admin-service` → generate_gatcha). State is React Context per domain (`AuthContext`, `PlayerContext`, `MonsterContext`, etc. under `src/context`) with one service module per backend under `src/services`, plus IndexedDB (`indexedDBService.ts`) used as a client-side cache/offline store for monsters/player/resources/invocation history.

Dependency direction at a glance: `Gatcha_Front` → all APIs (via proxy) · `API_invocations` → `API_authentification`, `API_monstres`, `API_joueur`, `API_generate_gatcha` · `API_joueur`/`API_monstres` → `API_authentification` (token verification only) · `API_generate_gatcha` → `API_invocations`.

## Java package layering (all four Spring services)

Standard controller → service → persistence/repository layering, no DDD. Typical packages: `controller` (+ `controller/dto/input`, `controller/dto/output`), `service`, `persistence`/`repository` (+ `dto`, `entity`), `exception`, `config`, `utils`. `API_invocations` is the richest (also has `client/dto/{auth,gatcha,monsters,player}`, `mapper`, `validation`) since it's the integration hub — see its `docs/ARCHITECTURE_INTER_API.md` and `docs/SAGA_PATTERN.md` if working on cross-service logic there. Note `API_monstres` uses a lowercase base package (`com.imt.api_monstres`) and capitalized `Repository` folder, inconsistent with the other three services — don't assume identical casing when navigating by analogy.

## Environment

`.env` at the root (copy from `.env.exemple`) holds secrets consumed by `API_generate_gatcha` and its `celery` container via `env_file` — `GEMINI_API_KEY`, `BANANA_API_KEY`, MinIO/Redis/Postgres credentials — plus `AUTH_SECRET`/`AUTH_SALT` (**required**, the compose fails fast if missing) and the optional `DEFAULT_ADMIN_*`/`DEFAULT_USER_*` seed accounts, interpolated into `api-authentification`'s `environment:` block. The other services get their config purely from `environment:` blocks in `docker-compose.yaml`.

None of the submodules are production-hardened — `API_authentification`'s own README explicitly warns it should not be deployed to production as-is.
