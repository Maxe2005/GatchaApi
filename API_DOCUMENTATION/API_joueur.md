# API Joueur

L'API Joueur gère les profils des joueurs, leur expérience (XP) et leur inventaire de monstres.

## 📌 Routes Disponibles

| # | Méthode | Endpoint | Description |
|---|---------|----------|-------------|
| 1 | `GET` | [/api/players/{username}](#1-récupérer-un-joueur) | Récupérer un joueur par son pseudo |
| 2 | `POST` | [/api/players/{username}/xp](#2-ajouter-de-lexperience) | Ajouter de l'expérience à un joueur |
| 3 | `POST` | [/api/players/{username}/monsters](#3-ajouter-un-monstre-à-linventaire) | Ajouter un monstre à l'inventaire |
| 4 | `DELETE` | [/api/players/{username}/monsters/{monsterId}](#4-supprimer-un-monstre-de-linventaire) | Supprimer un monstre de l'inventaire |
| 5 | `POST` | [/api/players](#5-créer-un-nouveau-joueur) | Créer un nouveau profil joueur |

## Base URL
```
http://localhost:{PORT}
```

## Routes

### 1. Récupérer un joueur
**Endpoint**: `GET /api/players/{username}`

**Description**: Récupère les informations complètes d'un joueur par son pseudo.

**Arguments** (Paramètres d'URL):
- `username` (string, obligatoire): Le pseudo du joueur

**Réponse** (200 OK):
```json
{
  "_id": "string",
  "username": "string",
  "xp": "number",
  "level": "number",
  "inventory": [
    {
      "monsterId": "string"
    }
  ],
  "createdAt": "ISO8601 date",
  "updatedAt": "ISO8601 date"
}
```

**Erreurs**:
- `404 Not Found`: Joueur non trouvé

---

### 2. Ajouter de l'expérience
**Endpoint**: `POST /api/players/{username}/xp`

**Description**: Ajoute de l'expérience à un joueur. L'expérience est cumulée et peut déclencher une augmentation de niveau.

**Arguments** (Paramètres d'URL + Corps):
- `username` (string, obligatoire): Le pseudo du joueur
- Corps (JSON):
```json
{
  "amount": "number (double)"
}
```

**Réponse** (200 OK):
```json
{
  "username": "string",
  "xp": "number",
  "level": "number",
  "levelUp": "boolean"
}
```

**Erreurs**:
- `404 Not Found`: Joueur non trouvé (404)
- `RuntimeException`: Erreur lors de l'ajout d'XP (400)

---

### 3. Ajouter un monstre à l'inventaire
**Endpoint**: `POST /api/players/{username}/monsters`

**Description**: Ajoute un monstre à l'inventaire du joueur.

**Arguments** (Paramètres d'URL + Corps):
- `username` (string, obligatoire): Le pseudo du joueur
- Corps (JSON):
```json
{
  "monsterId": "string"
}
```

**Réponse** (200 OK):
```json
{
  "username": "string",
  "inventory": [
    {
      "monsterId": "string"
    }
  ],
  "message": "Monster added successfully"
}
```

**Erreurs**:
- `400 Bad Request`: Inventaire plein ou monstre invalide
- `RuntimeException`: Erreur lors de l'ajout (400)

---

### 4. Supprimer un monstre de l'inventaire
**Endpoint**: `DELETE /api/players/{username}/monsters/{monsterId}`

**Description**: Supprime un monstre de l'inventaire du joueur.

**Arguments** (Paramètres d'URL):
- `username` (string, obligatoire): Le pseudo du joueur
- `monsterId` (string, obligatoire): L'ID du monstre à supprimer

**Réponse** (200 OK):
```json
{
  "username": "string",
  "inventory": [
    {
      "monsterId": "string"
    }
  ],
  "message": "Monster removed successfully"
}
```

**Erreurs**:
- `404 Not Found`: Joueur ou monstre non trouvé
- `400 Bad Request`: Monstre non dans l'inventaire (400)

---

### 5. Créer un nouveau joueur
**Endpoint**: `POST /api/players`

**Description**: Crée un nouveau profil joueur avec un pseudo donné.

**Arguments** (Corps - JSON):
```json
{
  "username": "string"
}
```

**Réponse** (201 Created):
```json
{
  "_id": "string",
  "username": "string",
  "xp": 0,
  "level": 1,
  "inventory": [],
  "createdAt": "ISO8601 date",
  "updatedAt": "ISO8601 date"
}
```

**Erreurs**:
- `409 Conflict`: Le pseudo existe déjà (409)
- `RuntimeException`: Erreur lors de la création (400)

---

## Notes
- La base de données utilisée est MongoDB
- Les joueurs ont une limite de capacité d'inventaire
- L'XP déclenche automatiquement les montées de niveau selon un système de progression
- Chaque monstre est identifié par un `monsterId` unique
