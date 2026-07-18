# API Combat

L'API Combat gère la logique des combats entre monstres.

## 📌 Routes Disponibles

⚠️ **Pas de routes implémentées** - En phase de conception

Voir [À Implémenter](#à-implémenter) pour le modèle proposé.

## Status de l'implémentation

⚠️ **À noter**: Cette API n'a pas d'implémentation visible actuellement. Seule l'application principale a été créée.

## Base URL
```
http://localhost:{PORT}
```

## À Implémenter

Les fonctionnalités suivantes seraient typiquement attendues pour une API de combat:

### Routes Potentielles
- `POST /combats/start` - Initier un nouveau combat
- `POST /combats/{combatId}/move` - Exécuter une action/attaque
- `GET /combats/{combatId}` - Voir l'état du combat
- `POST /combats/{combatId}/end` - Terminer un combat
- `GET /combats/{playerId}/history` - Historique des combats

### Concepts de Combat
- Système de tour par tour
- Système de compétences (skills)
- Calcul des dégâts basé sur les stats
- Gestion de la santé (HP)
- Système de chance/accuracy
- Conditions spéciales (paralysie, poison, etc.)
- XP et rewards

---

## Notes
- Cette API attend encore son implémentation
- Elle devrait utiliser MongoDB pour la persistance des combats
- Elle devrait communiquer avec l'API Invocations pour les monstres
- Elle devrait communiquer avec l'API Joueur pour les stats joueurs
