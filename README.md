# Jeu de Gatcha

## Lancer le jeu dockerisé

```bash
docker compose up -d
```

### Url pour accèder au Front et aux Swagger des Api

```bash
# Front
http://localhost:3000
```

```bash
# Api Invocations
http://localhost:8080/swagger-ui/index.html
```

```bash
# Api Authentification
http://localhost:8081/swagger-ui/index.html
```

```bash
# Api Joueur
http://localhost:8082/swagger-ui/index.html
```

```bash
# Api Monstres
http://localhost:8083/swagger-ui/index.html
```

```bash
# Api Generate gatcha
http://localhost:8084/docs
```

```bash
# pgAdmin
http://localhost:5050
```

```bash
# Api Minio
http://localhost:9001
```

## Mettre à jour les sous-modules

```bash
git submodule update --remote
```

## Reset les volumes

```bash
docker compose down -v
docker compose up -d
```

## Re-démarer une API après des modifs de config

```bash
docker compose down
docker compose build --no-cache api-joueur
```
