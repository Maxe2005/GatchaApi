# Jeu de Gatcha

Développé par Maxence CHOISEL, Rémy MAZINGUE, Mathis MEIER et Esteban CHOLLET--RODRIGUEZ dans le cadre du projet du cours Web API et DATA de l'IMT Nord Europe.

Ce projet est un jeu de Gatcha, où les joueurs peuvent invoquer des monstres, les faire combattre et progresser dans le jeu. Le projet est composé de plusieurs microservices, chacun gérant une partie spécifique du jeu.

Il y a deux versions du projet : celle-ci, présente sur la branche master qui est la version stable basique demandé par le sujet, et une version plus avancée sur la branche master_plus, qui contient des fonctionnalités supplémentaires et des améliorations en particulier dans l'interface utilisateur.

## Initialiser le projet

Clonez le projet avec les sous-modules pour récupérer les différentes APIs et le front-end

```bash
git clone --recurse-submodules https://github.com/Maxe2005/GatchaApi
```

Si vous avez déjà cloné le projet sans les sous-modules, vous pouvez les initialiser et les mettre à jour avec la commande suivante :

```bash
git submodule update --init --recursive.
```

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
