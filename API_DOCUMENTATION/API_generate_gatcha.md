# API Generate Gatcha

API Python (FastAPI) chargée de générer les données et images des monstres via l'IA (Gemini, Nano Banana). Gère le cycle de vie complet des monstres (création, review, correction, transmission).

## 📌 Routes Disponibles

### Gatcha (2 routes)
| # | Méthode | Endpoint | Description |
|---|---------|----------|-------------|
| 1 | `POST` | [/generate](#1-générer-un-monstre) | Générer un monstre avec IA |
| 2 | `POST` | [/generate-batch](#2-générer-plusieurs-monstres-batch) | Générer plusieurs monstres |

### Admin (6 routes)
| # | Méthode | Endpoint | Description |
|---|---------|----------|-------------|
| 3 | `GET` | [/monsters](#1-lister-les-monstres) | Lister tous les monstres avec filtres |
| 4 | `GET` | [/monsters/{monster_id}](#2-récupérer-les-détails-dun-monstre) | Récupérer détails complets |
| 5 | `GET` | [/monsters/{monster_id}/history](#3-récupérer-lhistorique-dun-monstre) | Voir historique des transitions |
| 6 | `POST` | [/monsters/{monster_id}/review](#4-review-un-monstre) | Approuver ou rejeter un monstre |
| 7 | `POST` | [/monsters/{monster_id}/correct](#5-corriger-un-monstre-défectueux) | Corriger un monstre en erreur |
| 8 | `GET` | [/dashboard/stats](#6-récupérer-les-statistiques-du-dashboard) | Voir statut général du système |

### Transmission (3 routes)
| # | Méthode | Endpoint | Description |
|---|---------|----------|-------------|
| 9 | `POST` | [/transmit/{monster_id}](#1-transmettre-un-monstre-à-lapi-invocations) | Transmettre monstre approuvé |
| 10 | `POST` | [/transmit-batch](#2-transmettre-tous-les-monstres-approuvés-batch) | Transmission en batch |
| 11 | `GET` | [/health-check](#3-vérifier-la-santé-de-lapi-dinvocations) | Vérifier API Invocations |

### Nano Banana (1 route)
| # | Méthode | Endpoint | Description |
|---|---------|----------|-------------|
| 12 | `POST` | [/generate-simple](#1-générer-une-image-simple) | Générer image avec Nano Banana |

## Base URL
```
http://localhost:{PORT}
```

---

## Gatcha Endpoints

### 1. Générer un monstre
**Endpoint**: `POST /generate`

**Description**: Génère une carte de monstre complète avec stats basées sur un prompt texte.

**Arguments** (Corps - JSON):
```json
{
  "prompt": "string (description du monstre souhaité)"
}
```

**Réponse** (200 OK):
```json
{
  "id": "string",
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
  "skills": [...],
  "image_url": "string"
}
```

**Erreurs**:
- `500 Internal Server Error`: Erreur lors de la génération (API Gemini ou image)

---

### 2. Générer plusieurs monstres (batch)
**Endpoint**: `POST /generate-batch`

**Description**: Génère plusieurs monstres avec stats équilibrées et concepts variés.

**Arguments** (Corps - JSON):
```json
{
  "n": "number (nombre de monstres à générer)",
  "prompt": "string (description générale, ex: 'fire type creatures')"
}
```

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
    "skills": [...],
    "image_url": "string"
  },
  ...
]
```

**Erreurs**:
- `500 Internal Server Error`: Erreur lors de la génération batch

---

## Admin Endpoints

### 1. Lister les monstres
**Endpoint**: `GET /monsters`

**Description**: Liste tous les monstres avec filtres optionnels.

**Arguments** (Paramètres de query):
- `state` (string, optionnel): Filtrer par état du monstre
  - États possibles: `DRAFT`, `PENDING_REVIEW`, `APPROVED`, `DEFECTIVE`, `TRANSMITTED`
- `limit` (number, optionnel, défaut=50): Nombre max de résultats (1-200)
- `offset` (number, optionnel, défaut=0): Pagination
- `sort_by` (string, optionnel, défaut=`created_at`): Champ de tri
- `order` (string, optionnel, défaut=`desc`): Ordre (asc|desc)

**Réponse** (200 OK):
```json
[
  {
    "id": "string",
    "name": "string",
    "state": "string",
    "created_at": "ISO8601 date",
    "updated_at": "ISO8601 date"
  },
  ...
]
```

---

### 2. Récupérer les détails d'un monstre
**Endpoint**: `GET /monsters/{monster_id}`

**Description**: Récupère les détails complets d'un monstre incluant métadonnées et rapport de validation.

**Arguments** (Paramètres d'URL):
- `monster_id` (string, obligatoire): L'ID du monstre

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
  "skills": [...],
  "metadata": {
    "state": "string",
    "created_at": "ISO8601 date",
    "updated_at": "ISO8601 date",
    "history": [...]
  },
  "validation_report": {
    "is_valid": "boolean",
    "errors": ["string"],
    "warnings": ["string"]
  }
}
```

**Erreurs**:
- `404 Not Found`: Monstre non trouvé

---

### 3. Récupérer l'historique d'un monstre
**Endpoint**: `GET /monsters/{monster_id}/history`

**Description**: Récupère l'historique complet des transitions d'état d'un monstre.

**Arguments** (Paramètres d'URL):
- `monster_id` (string, obligatoire): L'ID du monstre

**Réponse** (200 OK):
```json
{
  "monster_id": "string",
  "current_state": "string",
  "history": [
    {
      "from_state": "string",
      "to_state": "string",
      "timestamp": "ISO8601 date",
      "actor": "string",
      "note": "string"
    },
    ...
  ]
}
```

**Erreurs**:
- `404 Not Found`: Monstre non trouvé

---

### 4. Review un monstre
**Endpoint**: `POST /monsters/{monster_id}/review`

**Description**: Review un monstre (approuve ou rejette). Dans ce dernier cas, le monstre passe en état `DEFECTIVE`.

**Arguments** (Paramètres d'URL + Corps):
- `monster_id` (string, obligatoire): L'ID du monstre
- Corps (JSON):
```json
{
  "action": "enum(approve, reject)",
  "notes": "string (optionnel)",
  "corrected_data": {
    "name": "string (optionnel)",
    "stats": {...(optionnel)},
    ...
  }
}
```

**Réponse** (200 OK):
```json
{
  "status": "success",
  "monster_id": "string",
  "new_state": "string",
  "message": "Monster approvedd/rejectedd successfully"
}
```

**Erreurs**:
- `400 Bad Request`: Monstre non dans un état valide pour review
- `404 Not Found`: Monstre non trouvé

---

### 5. Corriger un monstre défectueux
**Endpoint**: `POST /monsters/{monster_id}/correct`

**Description**: Corrige un monstre en état `DEFECTIVE` et le remet en `PENDING_REVIEW`.

**Arguments** (Paramètres d'URL + Corps):
- `monster_id` (string, obligatoire): L'ID du monstre
- Corps (JSON):
```json
{
  "corrected_data": {
    "name": "string (optionnel)",
    "stats": {...(optionnel)},
    ...
  },
  "notes": "string (optionnel)"
}
```

**Réponse** (200 OK):
```json
{
  "status": "success",
  "monster_id": "string",
  "new_state": "PENDING_REVIEW",
  "message": "Monster corrected and moved to PENDING_REVIEW"
}
```

**Erreurs**:
- `400 Bad Request`: Monstre non en état `DEFECTIVE`
- `404 Not Found`: Monstre non trouvé

---

### 6. Récupérer les statistiques du dashboard
**Endpoint**: `GET /dashboard/stats`

**Description**: Récupère les statistiques globales du système de gestion des monstres.

**Arguments**: Aucun

**Réponse** (200 OK):
```json
{
  "total_monsters": "number",
  "by_state": {
    "DRAFT": "number",
    "PENDING_REVIEW": "number",
    "APPROVED": "number",
    "DEFECTIVE": "number",
    "TRANSMITTED": "number"
  },
  "transmission_rate": "number (pourcentage)",
  "avg_review_time_minutes": "number",
  "recent_activity": [
    {
      "monster_id": "string",
      "action": "string",
      "timestamp": "ISO8601 date"
    },
    ...
  ]
}
```

---

## Transmission Endpoints

### 1. Transmettre un monstre à l'API Invocations
**Endpoint**: `POST /transmit/{monster_id}`

**Description**: Transmet un monstre approuvé vers l'API d'invocations. Le monstre doit être en état `APPROVED`.

**Arguments** (Paramètres d'URL + Query):
- `monster_id` (string, obligatoire): L'ID du monstre
- `force` (boolean, optionnel, défaut=false): Force la transmission même si non approuvé

**Réponse** (200 OK):
```json
{
  "status": "success",
  "monster_id": "string",
  "new_state": "TRANSMITTED",
  "invocation_api_response": {...},
  "message": "Monster transmitted successfully"
}
```

**Erreurs**:
- `400 Bad Request`: Monstre non approuvé (sauf si force=true)
- `404 Not Found`: Monstre non trouvé
- `502 Bad Gateway`: Erreur de communication avec l'API d'invocations

---

### 2. Transmettre tous les monstres approuvés (batch)
**Endpoint**: `POST /transmit-batch`

**Description**: Transmet tous les monstres en état `APPROVED` vers l'API d'invocations.

**Arguments** (Paramètres de query):
- `max_count` (number, optionnel): Nombre maximum de monstres à transmettre

**Réponse** (200 OK):
```json
{
  "status": "success",
  "total_attempted": "number",
  "successful": "number",
  "failed": "number",
  "details": [
    {
      "monster_id": "string",
      "status": "success|failed",
      "message": "string"
    },
    ...
  ]
}
```

**Erreurs**:
- `502 Bad Gateway`: Erreur de communication avec l'API d'invocations

---

### 3. Vérifier la santé de l'API d'invocations
**Endpoint**: `GET /health-check`

**Description**: Vérifie la disponibilité et l'état de l'API d'invocations.

**Arguments**: Aucun

**Réponse** (200 OK):
```json
{
  "status": "healthy|unhealthy",
  "invocation_api_url": "string",
  "response_time_ms": "number",
  "last_check": "ISO8601 date"
}
```

**Erreurs**:
- `500 Internal Server Error`: L'API d'invocations est indisponible

---

## Nano Banana (Image Generation) Endpoints

### 1. Générer une image simple
**Endpoint**: `POST /generate-simple`

**Description**: Génère une image directement avec Nano Banana (Gemini) et la sauvegarde localement.

**Arguments** (Corps - multipart/form-data):
- `aspect_ratio` (string, obligatoire): Ratio d'aspect (ex: `1:1`, `3:4`, `16:9`)
- `image_size` (string, obligatoire): Taille de l'image (ex: `1024x1024`, `4K`)
- `output_image_name` (string, obligatoire): Nom du fichier à sauvegarder (sans extension ou `.png`)
- `prompt` (string, obligatoire): Description texte de l'image
- `image` (file, optionnel): Fichier image d'entrée pour le in-painting

**Réponse** (200 OK):
```json
{
  "status": "success",
  "message": "Image generated and saved successfully",
  "file_path": "string",
  "params": {
    "aspect_ratio": "string",
    "image_size": "string",
    "prompt": "string",
    "image_provided": "boolean"
  }
}
```

**Erreurs**:
- `500 Internal Server Error`: Erreur lors de la génération d'image

---

## Cycle de Vie des Monstres

Les monstres passent par les états suivants:

1. **DRAFT**: État initial après génération IA
2. **PENDING_REVIEW**: En attente de review par un administrateur
3. **APPROVED**: Validé et prêt pour transmission
4. **DEFECTIVE**: Rejeté et nécessite correction
5. **TRANSMITTED**: Envoyé avec succès à l'API Invocations

---

## Notes
- PostgreSQL est utilisé pour stocker les métadonnées
- MinIO gère les images et fichiers
- Les monstres sont générés via l'API Gemini
- Les états et transitions sont tracés pour audit
