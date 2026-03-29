# Jeu de Gatcha

Ceci est la version avancée du projet de jeu de Gatcha. Elle intègre en plus des fonctionnalités de base, une interface utilisateur améliorée, deux microservices supplémentaires que sont l'API Combat et l'API Generate Gatcha. La première gère les combats entre les monstres tandis que la seconde est une API admin permettant de générer des monstres avec l'IA et de les ajouter à la base de données.

## Mettre à jour les sous-modules

```bash
git submodule update --remote
```

## Lancer le jeu dockerisé

```bash
docker compose up -d --build
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
