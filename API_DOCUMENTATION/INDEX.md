# 📚 Gatcha API - Documentation Complète

Bienvenue dans la documentation des APIs du système Gatcha ! Ce dossier contient la liste détaillée de toutes les routes disponibles pour chaque API avec les arguments attendus et les résultats en sortie.

## 📋 Table des matières

### 1. [API_authentification.md](API_authentification.md)
Gestion de l'authentification et des utilisateurs (JWT tokens).
- **Base de données**: MongoDB
- **Routes**: 4 endpoints
- **Fonctionnalités**: 
  - Enregistrement utilisateur
  - Connexion
  - Vérification de token
  - Suppression d'utilisateur

### 2. [API_joueur.md](API_joueur.md)
Gestion des profils joueurs, XP et inventaire.
- **Base de données**: MongoDB
- **Routes**: 5 endpoints
- **Fonctionnalités**:
  - Récupérer profil joueur
  - Ajouter expérience (XP)
  - Gérer inventaire de monstres
  - Créer nouveau joueur

### 3. [API_monstres.md](API_monstres.md)
Gestion des définitions master de monstres.
- **Base de données**: JSON + PostgreSQL (migration en cours)
- **Routes**: 3 endpoints
- **Fonctionnalités**:
  - Créer monstre
  - Récupérer monstre par ID
  - Récupérer plusieurs monstres (batch)

### 4. [API_invocations.md](API_invocations.md)
Gestion du système d'appels (gacha), monstres invoqués et compétences.
- **Base de données**: MongoDB
- **Routes**: 15 endpoints
- **Contrôleurs**: 4 (Invocation, Monsters, Skills, Stats)
- **Fonctionnalités**:
  - Invoquer monstres (simple et joueur)
  - Gérer monstres invoqués (CRUD)
  - Gérer compétences (CRUD)
  - Consulter statistiques de loot

### 5. [API_generate_gatcha.md](API_generate_gatcha.md)
Génération de monstres via IA et gestion de leur cycle de vie.
- **Framework**: FastAPI (Python)
- **Base de données**: PostgreSQL + MinIO (images)
- **Routes**: 12 endpoints
- **Groupes d'endpoints**: 4 (Gatcha, Admin, Transmission, Nano Banana)
- **Fonctionnalités**:
  - Générer monstres avec IA (Gemini)
  - Générer images avec Nano Banana
  - Review et correction de monstres
  - Transmission vers API Invocations
  - Dashboard admin

### 6. [API_combat.md](API_combat.md)
Système de combat entre monstres. ⚠️ En cours d'implémentation.
- **Status**: À implémenter
- **Concepts**: Modèle proposé pour futur développement

---

## 🏗️ Architecture d'ensemble

```
Client/Frontend
    ↓
┌─────────────────────────────────────────────────────┐
│          API_authentification                        │
│  (Gestion des utilisateurs et JWT tokens)           │
└──────┬──────────────────────────────────────────────┘
       │
       ├──→ API_joueur (Profils & Inventaires)
       │
       ├──→ API_invocations (Gacha & Monstres)
       │    ├──→ API_monstres (Données master)
       │    └──→ API_generate_gatcha (Création IA)
       │
       ├──→ API_combat (À implémenter)
       │
       └──→ API_generate_gatcha (Génération IA)
            └──→ Admin Management
```

---

## 🚀 Démarrage Rapide

### Lancer tous les services
```bash
docker compose up -d
```

### Consulter les logs
```bash
docker compose logs -f
```

### Arrêter tous les services
```bash
docker compose down
```

---

## 📊 Résumé des APIs

| API | Type | DB | Endpoints | Status |
|-----|------|----|---------  |--------|
| Authentification | REST (Java) | MongoDB | 4 | ✅ Actif |
| Joueur | REST (Java) | MongoDB | 5 | ✅ Actif |
| Monstres | REST (Java) | JSON/PostgreSQL | 3 | ✅ Actif |
| Invocations | REST (Java) | MongoDB | 15 | ✅ Actif |
| Generate Gatcha | REST (Python/FastAPI) | PostgreSQL + MinIO | 12 | ✅ Actif |
| Combat | REST (Java) | - | 0 | 🔄 À implémenter |

---

## 🔗 Patterns de Communication

### Inter-API Communication
- **API_invocations** → **API_authentification** (vérification tokens)
- **API_invocations** → **API_monstres** (récupération monstre)
- **API_invocations** → **API_joueur** (ajout inventaire)
- **API_generate_gatcha** → **API_invocations** (transmission monstres créés)

### Patterns Utilisés
- SAGA Pattern pour les transactions distribuées
- JWT pour l'authentification
- REST pour la communication
- Async/Await pour les appels de longue durée

---

## 📝 Format des Routes

Chaque fichier .md suit ce format standardisé:

```
## Route
**Endpoint**: METHOD /path/{param}
**Description**: Courte description du rôle
**Arguments**: Paramètres attendus (URL, Query, Body)
**Réponse**: Format JSON-like attendu avec codes HTTP
**Erreurs**: Liste des possibles codes d'erreur
```

---

## 🛠️ Pour ajouter une nouvelle route

1. Créer/modifier le contrôleur Java ou endpoint Python
2. Mettre à jour le fichier `.md` correspondant avec:
   - Endpoint complet
   - Description claire
   - Arguments détaillés
   - Exemple de réponse
   - Codes d'erreur possibles

---

## 📞 Support et Questions

Pour plus de détails sur une API spécifique, consultez son fichier `.md` dédié.

Pour des questions d'architecture générale, consultez:
- `/docs` dans chaque dossier API
- `docker-compose.yaml` pour la configuration des services
- `README.md` à la racine du projet

---

**Dernière mise à jour**: Février 2026
**Statut du système**: Fonctionnel avec développement en cours
