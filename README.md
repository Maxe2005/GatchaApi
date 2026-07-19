# Jeu de Gatcha

Développé par Maxence CHOISEL, Rémy MAZINGUE, Mathis MEIER et Esteban CHOLLET--RODRIGUEZ dans le cadre du projet du cours Web API et DATA de l'IMT Nord Europe.

Ce projet est un jeu de Gatcha, où les joueurs peuvent invoquer des monstres, les faire combattre et progresser dans le jeu. Le projet est composé de plusieurs microservices, chacun gérant une partie spécifique du jeu.

## Démarrage rapide avec Makefile

Un `Makefile` est disponible à la racine pour raccourcir les commandes les plus courantes (stack Docker, sous-modules, front-end). Listez tous les raccourcis disponibles avec :

```bash
make help
```

Les sections ci-dessous détaillent les commandes manuelles équivalentes, utiles si `make` n'est pas disponible ou pour comprendre ce que fait chaque raccourci.

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
cp .env.exemple .env
```

Ce fichier contient les variables d'environnement nécessaires pour la configuration de l'application. Vous devez y inscrire notamment :

- `AUTH_SECRET` et `AUTH_SALT` (**requis**) : secrets de chiffrement des tokens de l'API d'authentification — la stack refuse de démarrer s'ils sont absents ;
- les clés API pour l'API de Gémini si vous souhaitez utiliser la fonctionnalité admin de génération de nouveaux monstres avec l'IA ;
- optionnellement `DEFAULT_ADMIN_USERNAME`/`DEFAULT_ADMIN_PASSWORD` et `DEFAULT_USER_USERNAME`/`DEFAULT_USER_PASSWORD` pour seeder des comptes par défaut au démarrage.

> **Note** : ce `.env` racine est désormais la **seule** source de configuration — les sous-modules n'ont plus de `docker-compose.yml` ni de `.env` docker propres, et ce `docker-compose.yaml` racine est l'unique façon de lancer le projet.

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

## URL github des différentes APIs

```bash
# Api Invocations
https://github.com/Maxe2005/API_invocations
```

```bash
# Api Authentification
https://github.com/Maxe2005/API_authentification
```

```bash
# Api Joueur
https://github.com/Maxe2005/API_joueur
```

```bash
# Api Monstres
https://github.com/Maxe2005/API_monstres
```

```bash
# Front
https://github.com/Maxe2005/Gatcha_Front
```

## Reset les volumes

```bash
docker compose down -v
docker compose up -d
```

## Re-démarer une API après des modifs de config pour (par exemple) l'API Joueur

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
