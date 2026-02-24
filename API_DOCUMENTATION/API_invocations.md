# API Invocations

L'API Invocations gère les appels (gacha), les monstres invoqués, les compétences, et les statistiques du système de loot.

## 📌 Routes Disponibles

### Invocation (3 routes)
| # | Méthode | Endpoint | Description |
|---|---------|----------|-------------|
| 1 | `GET` | [/api/invocation/invoque](#1-invoquer-un-monstre-simple) | Invoquer un monstre aléatoire |
| 2 | `POST` | [/api/invocation/global-invoque/{playerId}](#2-invoquer-un-monstre-joueur) | Invoquer pour un joueur spécifique |
| 3 | `POST` | [/api/invocation/recreate](#3-recréer-les-invocations-en-arrière-plan) | Rejeu des invocations en attente |

### Monsters (5 routes)
| # | Méthode | Endpoint | Description |
|---|---------|----------|-------------|
| 4 | `POST` | [/api/invocation/monsters/create](#1-créer-un-monstre) | Créer un nouveau monstre |
| 5 | `GET` | [/api/invocation/monsters/{monsterId}](#2-récupérer-un-monstre) | Récupérer un monstre |
| 6 | `GET` | [/api/invocation/monsters/all](#3-récupérer-tous-les-monstres) | Lister tous les monstres |
| 7 | `PUT` | [/api/invocation/monsters/{monsterId}](#4-mettre-à-jour-un-monstre) | Mettre à jour un monstre |
| 8 | `DELETE` | [/api/invocation/monsters/{monsterId}](#5-supprimer-un-monstre) | Supprimer un monstre |

### Skills (5 routes)
| # | Méthode | Endpoint | Description |
|---|---------|----------|-------------|
| 9 | `POST` | [/api/invocation/skills](#1-créer-une-compétence) | Créer une nouvelle compétence |
| 10 | `GET` | [/api/invocation/skills/{skillId}](#2-récupérer-une-compétence) | Récupérer une compétence |
| 11 | `GET` | [/api/invocation/skills/monster/{monsterId}](#3-récupérer-les-compétences-dun-monstre) | Lister compétences d'un monstre |
| 12 | `PUT` | [/api/invocation/skills/{skillId}](#4-mettre-à-jour-une-compétence) | Mettre à jour une compétence |
| 13 | `DELETE` | [/api/invocation/skills/{skillId}](#5-supprimer-une-compétence) | Supprimer une compétence |

### Stats (2 routes)
| # | Méthode | Endpoint | Description |
|---|---------|----------|-------------|
| 14 | `GET` | [/api/invocation/stats/verify-ranks-drop-rate](#1-vérifier-les-taux-de-drop-des-rangs) | Vérifier la validité des taux |
| 15 | `GET` | [/api/invocation/stats/get-loot-rate](#2-récupérer-les-taux-de-loot) | Récupérer taux théoriques/réels |

## Base URL
```
http://localhost:{PORT}
```

## Routes

### Invitation Controller

#### 1. Invoquer un monstre (simple)
**Endpoint**: `GET /api/invocation/invoque`

**Description**: Effectue une invocation simple et retourne un monstre aléatoire selon les probabilités de loot.

**Arguments**: Aucun

**Réponse** (200 OK):
```json
{
  "id": "string",
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
  "skills": [...]
}
```

---

#### 2. Invoquer un monstre (joueur)
**Endpoint**: `POST /api/invocation/global-invoque/{playerId}`

**Description**: Effectue une invocation pour un joueur spécifique et ajoute le monstre à son inventaire.

**Arguments** (Paramètres d'URL):
- `playerId` (string, obligatoire): L'ID du joueur

**Réponse** (200 OK):
```json
{
  "id": "string",
  "name": "string",
  "type": "string",
  "rank": "string",
  "rarity": "number",
  "stats": {...},
  "elementary": "string",
  "skills": [...]
}
```

**Erreurs**:
- `400 Bad Request`: Joueur invalide ou introuvable

---

#### 3. Recréer les invocations en arrière-plan
**Endpoint**: `POST /api/invocation/recreate`

**Description**: Rejeu et récréation de toutes les invocations en attente dans le buffer.

**Arguments**: Aucun (Corps vide)

**Réponse** (200 OK):
```json
{
  "totalProcessed": "number",
  "successful": "number",
  "failed": "number",
  "report": "string"
}
```

---

### Monsters Controller

#### 1. Créer un monstre
**Endpoint**: `POST /api/invocation/monsters/create`

**Description**: Crée un nouveau monstre dans la base MongoDB.

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
  "skills": [...]
}
```

**Réponse** (201 Created):
```
"monsterId_string"
```

---

#### 2. Récupérer un monstre
**Endpoint**: `GET /api/invocation/monsters/{monsterId}`

**Description**: Récupère les données complètes d'un monstre par ID.

**Arguments** (Paramètres d'URL):
- `monsterId` (string, obligatoire): L'ID du monstre

**Réponse** (200 OK):
```json
{
  "id": "string",
  "name": "string",
  "type": "string",
  "rank": "string",
  "rarity": "number",
  "stats": {...},
  "elementary": "string",
  "skills": [...]
}
```

**Erreurs**:
- `404 Not Found`: Monstre non trouvé

---

#### 3. Récupérer tous les monstres
**Endpoint**: `GET /api/invocation/monsters/all`

**Description**: Retourne la liste de tous les monstres disponibles.

**Arguments**: Aucun

**Réponse** (200 OK):
```json
[
  {
    "id": "string",
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

---

#### 4. Mettre à jour un monstre
**Endpoint**: `PUT /api/invocation/monsters/{monsterId}`

**Description**: Met à jour les données d'un monstre existant.

**Arguments** (Paramètres d'URL + Corps):
- `monsterId` (string, obligatoire): L'ID du monstre
- Corps (JSON): Les champs à mettre à jour (format similaire à la création)

**Réponse** (200 OK):
```
Aucun contenu
```

**Erreurs**:
- `404 Not Found`: Monstre non trouvé

---

#### 5. Supprimer un monstre
**Endpoint**: `DELETE /api/invocation/monsters/{monsterId}`

**Description**: Supprime un monstre de la base de données.

**Arguments** (Paramètres d'URL):
- `monsterId` (string, obligatoire): L'ID du monstre

**Réponse** (200 OK):
```json
{
  "deleted": "boolean"
}
```

**Erreurs**:
- `404 Not Found`: Monstre non trouvé (retourne `{"deleted": false}`)

---

### Skills Controller

#### 1. Créer une compétence
**Endpoint**: `POST /api/invocation/skills`

**Description**: Crée une nouvelle compétence pour les monstres.

**Arguments** (Corps - JSON):
```json
{
  "name": "string",
  "type": "string",
  "power": "number",
  "accuracy": "number",
  "ppMax": "number",
  "monsterId": "string",
  "rank": "enum(S, A, B, C, D)"
}
```

**Réponse** (201 Created):
```
"skillId_string"
```

---

#### 2. Récupérer une compétence
**Endpoint**: `GET /api/invocation/skills/{skillId}`

**Description**: Récupère les détails d'une compétence spécifique.

**Arguments** (Paramètres d'URL):
- `skillId` (string, obligatoire): L'ID de la compétence

**Réponse** (200 OK):
```json
{
  "id": "string",
  "name": "string",
  "type": "string",
  "power": "number",
  "accuracy": "number",
  "ppMax": "number",
  "monsterId": "string",
  "rank": "string"
}
```

**Erreurs**:
- `404 Not Found`: Compétence non trouvée

---

#### 3. Récupérer les compétences d'un monstre
**Endpoint**: `GET /api/invocation/skills/monster/{monsterId}`

**Description**: Retourne toutes les compétences associées à un monstre.

**Arguments** (Paramètres d'URL):
- `monsterId` (string, obligatoire): L'ID du monstre

**Réponse** (200 OK):
```json
[
  {
    "id": "string",
    "name": "string",
    "type": "string",
    "power": "number",
    "accuracy": "number",
    "ppMax": "number",
    "rank": "string"
  },
  ...
]
```

**Erreurs**:
- `404 Not Found`: Monstre non trouvé ou pas de compétences

---

#### 4. Mettre à jour une compétence
**Endpoint**: `PUT /api/invocation/skills/{skillId}`

**Description**: Met à jour les détails d'une compétence existante.

**Arguments** (Paramètres d'URL + Corps):
- `skillId` (string, obligatoire): L'ID de la compétence
- Corps (JSON): Les champs à mettre à jour

**Réponse** (200 OK):
```
Aucun contenu
```

**Erreurs**:
- `404 Not Found`: Compétence non trouvée

---

#### 5. Supprimer une compétence
**Endpoint**: `DELETE /api/invocation/skills/{skillId}`

**Description**: Supprime une compétence de la base de données.

**Arguments** (Paramètres d'URL):
- `skillId` (string, obligatoire): L'ID de la compétence

**Réponse** (200 OK):
```json
{
  "deleted": "boolean"
}
```

**Erreurs**:
- `404 Not Found`: Compétence non trouvée (retourne `{"deleted": false}`)

---

### Stats Controller

#### 1. Vérifier les taux de drop des rangs
**Endpoint**: `GET /api/invocation/stats/verify-ranks-drop-rate`

**Description**: Valide que les taux de drop par rang sont corrects et totalisent 100%.

**Arguments**: Aucun

**Réponse** (200 OK):
```
"Ranks drop rates are valid and sum up to 100%."
```

ou

```
"Ranks drop rates are NOT valid and do not sum up to 100%.
Please check the configuration."
```

---

#### 2. Récupérer les taux de loot
**Endpoint**: `GET /api/invocation/stats/get-loot-rate?type=all`

**Description**: Retourne les taux de loot (théoriques ou réels) du système d'invocation.

**Arguments** (Paramètres de query):
- `type` (string, optionnel): Type de taux à retourner
  - `all` (défaut): Tous les taux
  - `Theoretical Drop Rates`: Taux théoriques
  - `Real Drop Rates`: Taux réels observés

**Réponse** (200 OK):
```
"Taux théoriques:
 - S: 5%
 - A: 15%
 - B: 30%
 - C: 35%
 - D: 15%
Taux réels:
 - S: 4.9%
 - A: 14.8%
 - B: 30.1%
 - C: 35.2%
 - D: 15.0%"
```

---

## Notes
- MongoDB est utilisé pour stocker les monstres et compétences
- Les invocations utilisent un système probabiliste basé sur les rangs (S, A, B, C, D)
- Les appels (gacha) peuvent déclencher des bonus ou des événements spéciaux
- Les statistiques de loot sont mises à jour en temps réel
