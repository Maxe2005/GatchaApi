## Mettre à jour les sous-modules

```bash
git submodule update --remote
```

## Reset les volumes

```bash
docker compose down -v
docker compose up -d
```

## Re-démarer après des modifs de config

```bash
docker compose down
docker compose build --no-cache api_joueur
```
