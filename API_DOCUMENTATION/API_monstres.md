# API Monstres

L'API Monstres gère les données globales de monstres (définitions, stats, compétences, etc.) dans le système.

## 📌 Routes Disponibles

| # | Méthode | Endpoint | Description |
|---|---------|----------|-------------|
| 1 | `POST` | [/api/monsters/create](#1-créer-un-monstre) | Créer un nouveau monstre |
| 2 | `GET` | [/api/monsters/{monsterId}](#2-récupérer-un-monstre-par-id) | Récupérer un monstre spécifique |
| 3 | `GET` | [/api/monsters?ids=...](#3-récupérer-plusieurs-monstres-par-ids) | Récupérer plusieurs monstres |

## Base URL
```
http://localhost:{PORT}
```

## Routes

### 1. Créer un monstre
**Endpoint**: `POST /api/monsters/create`

**Description**: Crée un nouveau monstre avec ses statistiques et compétences. Retourne l'ID généré et un message de confirmation.

**Arguments** (Corps - JSON):
```json
{
  "name": "string",
  "type": "string",
  "rank": "enum(S, A, B, C, D)",
  "rarity": "number",
  "stats": {
    "hp": "number",
    "attack": "number",
    "defense": "number",
    "speed": "number",
    "spAtk": "number",
    "spDef": "number"
  },
  "elementary": "enum(FIRE, WATER, GRASS, ELECTRIC, ICE, NORMAL)",
  "skills": [
    {
      "name": "string",
      "power": "number",
      "accuracy": "number",
      "ppMax": "number"
    }
  ],
  "ratios": {
    "maleRatio": "number (0-100)",
    "femaleRatio": "number (0-100)"
  }
}
```

**Réponse** (201 Created):
```json
{
  "monsterId": "string",
  "message": "Monster created successfully"
}
```

**Erreurs**:
- `400 Bad Request`: Données invalides ou incomplètes

---

### 2. Récupérer un monstre par ID
**Endpoint**: `GET /api/monsters/{monsterId}`

**Description**: Récupère les informations complètes d'un monstre spécifique.

**Arguments** (Paramètres d'URL):
- `monsterId` (string, obligatoire): L'ID unique du monstre

**Réponse** (200 OK):
```json
{
  "_id": "string",
  "name": "string",
  "type": "string",
  "rank": "string",
  "rarity": "number",
  "stats": {
    "hp": "number",
    "attack": "number",
    "defense": "number",
    "speed": "number",
    "spAtk": "number",
    "spDef": "number"
  },
  "elementary": "string",
  "skills": [
    {
      "name": "string",
      "power": "number",
      "accuracy": "number",
      "ppMax": "number"
    }
  ]
}
```

**Erreurs**:
- `404 Not Found`: Aucun monstre trouvé pour cet ID

---

### 3. Récupérer plusieurs monstres par IDs
**Endpoint**: `GET /api/monsters?ids=id1,id2,id3`

**Description**: Récupère les données de plusieurs monstres via une liste d'IDs.

**Arguments** (Paramètres de query):
- `ids` (string, obligatoire): Liste d'IDs séparés par des virgules (ex: `id1,id2,id3`)

**Réponse** (200 OK):
```json
[
  {
    "_id": "string",
    "name": "string",
    "type": "string",
    "rank": "string",
    "rarity": "number",
    "stats": {...},
    "elementary": "string",
    "skills": [...]
  },
  ...
]
```

**Erreurs**:
- `404 Not Found`: Certains IDs n'existent pas. Retourne la liste des IDs manquants.

---

## Notes
- Les monstres sont stockés en JSON et en base de données (transition vers PostgreSQL)
- Les rangs (Rank) : S, A, B, C, D
- Les éléments (Elementary) : FIRE, WATER, GRASS, ELECTRIC, ICE, NORMAL
- Les statistiques de base incluent: HP, Attack, Defense, Speed, SpAtk, SpDef
- Les monstres peuvent avoir plusieurs compétences
- Les ratios genre sont définis en pourcentages pour male/female
