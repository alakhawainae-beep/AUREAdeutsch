# AUREA Deutsch

Application Flutter d’apprentissage de l’allemand, du niveau **A1** au **C2** (Cadre européen commun de référence — CECR).

## Vision

AUREA Deutsch propose un parcours clair et progressif pour apprendre l’allemand avec élégance et structure. Chaque niveau CECR dispose de son espace dédié, prêt à accueillir leçons, exercices et ressources.

## Niveaux

| Niveau | Objectif |
|--------|----------|
| **A1** | Bases essentielles — salutations, présentation, quotidien simple |
| **A2** | Vie quotidienne — routines, courses, ville, loisirs |
| **B1** | Autonomie — voyage, travail, opinions, récits |
| **B2** | Aisance — argumentation, médias, registre formel |
| **C1** | Maîtrise — précision, idiomes, structures complexes |
| **C2** | Excellence — finesse stylistique et niveau quasi natif |

## Structure du projet

```text
lib/
  main.dart                 # Point d'entrée + thème
  models/                   # Modèles (niveaux CECR)
  theme/                    # Identité visuelle
  widgets/                  # Composants réutilisables
  screens/
    home_screen.dart        # Accueil : 6 cartes A1–C2
    level_workspace_screen.dart
    a1/ … c2/               # Espaces par niveau + dossiers lessons/
assets/
  images/                   # Images et illustrations
```

## Prérequis

- [Flutter](https://docs.flutter.dev/get-started/install) (SDK 3.11+)
- Android Studio / Xcode / un navigateur pour le web

## Démarrage

```bash
flutter pub get
flutter run
```

## Plateformes

- Android
- iOS
- Web

## Contribution

1. Créer une branche thématique
2. Ajouter les leçons dans `lib/screens/<niveau>/lessons/`
3. Placer les visuels dans `assets/images/`
4. Ouvrir une pull request claire et testée

## Licence

Projet privé — tous droits réservés.
