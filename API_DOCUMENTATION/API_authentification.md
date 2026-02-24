# API Authentification

L'API d'authentification gère l'enregistrement, l'authentification et la gestion des tokens JWT des utilisateurs.

## 📌 Routes Disponibles

| # | Méthode | Endpoint | Description |
|---|---------|----------|-------------|
| 1 | `POST` | [/user](#1-enregistrement-utilisateur) | Créer et enregistrer un nouvel utilisateur |
| 2 | `POST` | [/user/login](#2-connexion-utilisateur) | Authentifier un utilisateur |
| 3 | `POST` | [/user/verify-token](#3-vérifier-le-token) | Valider un token JWT |
| 4 | `POST` | [/user/delete](#4-supprimer-un-utilisateur) | Supprimer un utilisateur |

## Base URL
```
http://localhost:{PORT}
```

## Routes

### 1. Enregistrement utilisateur
**Endpoint**: `POST /user`

**Description**: Crée un nouvel utilisateur et retourne un token d'authentification JWT.

**Arguments** (Corps de la requête - JSON):
```json
{
  "username": "string",
  "password": "string"
}
```

**Réponse** (201 Created / 409 Conflict):
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Erreurs**:
- `ValidationException`: Username ou password non fourni (400)
- `UserDuplicateException`: L'utilisateur existe déjà (409)

---

### 2. Connexion utilisateur
**Endpoint**: `POST /user/login`

**Description**: Authentifie un utilisateur existant et retourne un token JWT.

**Arguments** (Corps de la requête - JSON):
```json
{
  "username": "string",
  "password": "string"
}
```

**Réponse** (200 OK):
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Erreurs**:
- `ValidationException`: Username ou password non fourni (400)
- `ValidationException`: Utilisateur non trouvé (404)
- `UserCredsException`: Mot de passe incorrect (401)

---

### 3. Vérifier le token
**Endpoint**: `POST /user/verify-token`

**Description**: Valide un token JWT et retourne le nom d'utilisateur associé.

**Arguments** (Corps de la requête - JSON):
```json
{
  "token": "string"
}
```

**Réponse** (200 OK):
```json
{
  "username": "string"
}
```

**Erreurs**:
- `TokenInvalidException`: Token invalide ou expiré (401)

---

### 4. Supprimer un utilisateur
**Endpoint**: `POST /user/delete`

**Description**: Supprime un utilisateur basé sur le token d'authentification fourni.

**Arguments** (Corps de la requête - JSON):
```json
{
  "token": "string"
}
```

**Réponse** (200 OK):
```
HTTP Status 200
```

**Erreurs**:
- `TokenInvalidException`: Token invalide ou expiré (401)
- (401) Si le token est invalide

---

## Notes
- Les tokens JWT sont utilisés pour l'authentification sur les autres APIs
- Les mots de passe sont chiffrés via AES avant stockage
- Les utilisateurs sont stockés dans MongoDB
