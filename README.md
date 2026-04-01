# Jeu de Gatcha

Ceci est la version avancée du projet de jeu de Gatcha. Elle intègre en plus des fonctionnalités de base, une interface utilisateur améliorée, deux microservices supplémentaires que sont l'API Combat et l'API Generate Gatcha. La première gère les combats entre les monstres tandis que la seconde est une API admin permettant de générer des monstres avec l'IA et de les ajouter à la base de données.

## Initialiser le projet

### Clonez le projet avec les sous-modules pour récupérer les différentes APIs et le front-end

```bash
git clone --recurse-submodules https://github.com/Maxe2005/GatchaApi
```

Si vous avez déjà cloné le projet sans les sous-modules, vous pouvez les initialiser et les mettre à jour avec la commande suivante :

```bash
git submodule update --init --recursive
```

### Initializer le .env

Copiez le fichier `.env.example` à la racine du projet et renommez-le en `.env`.

```bash
cp .env.example .env
```

Ce fichier contient les variables d'environnement nécessaires pour la configuration de l'application. Vous devez y inscrire notamment les clés API pour l'API de Gémini si vous souhaitez utiliser la fonctionnalité admin de génération de nouveaux monstres avec l'IA.

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

## Initialiser pgadmin

Lien pour pgadmin

```bash
http://localhost:5050
```

### Ajouter la db api-invocation

Clic droit sur Serveur -> Register -> Serveur...

- General > Name : Invocation (ou ce que vous voulez)
- Connection:
    - Hostname/address : postgres-invocations
    - Port : 5432
    - Maintenance database : api_invocationsdb
    - Username : api_invocations
    - Password : api_invocations
    - Save Password : coché

### Ajouter la db api-generate-gatcha

Clic droit sur Serveur -> Register -> Serveur...

- General > Name : Generate Gatcha (ou ce que vous voulez)
- Connection:
    - Hostname/address : postgres-generate-gatcha
    - Port : 5432
    - Maintenance database : gatcha_db
    - Username : gatcha_user
    - Password : gatcha_password
    - Save Password : coché

### Accéder aux tables

Exemple avec Invocation (créé précédemment) :

Servers -> Invocation -> Databases -> api_invocationdb -> Schemas -> public -> Tables -> <clic droit sur une table (ex : monsters)> -> View/Edit Data -> All Rows

## Acceder à la db images Minio

```bash
http://localhost:9001
```

Username : admin

Password : password123
