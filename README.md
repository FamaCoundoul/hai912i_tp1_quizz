# Application Quiz Flutter

## 📱 Vue d'ensemble

Une application de quiz interactive et moderne développée avec Flutter, offrant une expérience utilisateur fluide avec trois interfaces distinctes : page d'accueil, page de quiz avec timer, et tableau des scores (leaderboard).

##  Objectifs Pédagogiques

Cette application démontre la maîtrise des concepts suivants :
- Navigation entre plusieurs pages
- Gestion d'état avec StatefulWidget
- Chargement de données JSON
- Création d'interfaces utilisateur modernes et responsives
- Utilisation de timers et animations
- Gestion des interactions utilisateur

##  Architecture de l'Application

### Structure du Projet

```
lib/
├── main.dart                 # Point d'entrée et configuration
├── question_model.dart       # Modèle de données
└── pages/
    ├── welcome_page.dart     # Page d'accueil
    ├── quiz_page.dart        # Page de quiz
    └── leaderboard_page.dart # Tableau des scores

assets/
├── data/
│   └── quizz_questions.json  # Dataset des questions
└── images/
    ├── france.png
    ├── histoire.png
    └── ... (autres images)
```

##  Les Trois Pages Principales

### 1. Page d'Accueil (WelcomePage)

**Objectif** : Accueillir l'utilisateur et capturer son nom avant de démarrer le quiz.

**Composants clés** :
- Logo circulaire "QUIZ" sur fond blanc
- Champ de saisie de texte stylisé
- Bouton "Start" avec design moderne
- Palette de couleurs teal/jaune pour une ambiance accueillante

**Widgets utilisés** :
- `TextField` avec decoration personnalisée
- `Container` avec `BoxDecoration` pour le logo circulaire
- `ElevatedButton` avec style personnalisé

**Navigation** :
```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => QuizPage(...))
);
```

### 2. Page Quiz (QuizPage)

**Objectif** : Présenter les questions avec un timer et gérer les réponses de l'utilisateur.

**Fonctionnalités principales** :
- ⏱️ **Timer circulaire** : Compte à rebours de 30 secondes par question
- 🖼️ **Icône de question** : Image représentative affichée en dessous du timer
- ❓ **Carte de question** : Texte de la question dans une carte blanche épurée
- ✅ **Options de réponse** : Liste d'options avec feedback visuel immédiat
- 📊 **Indicateur de progression** : Affiche "Question X/Total"
- ➡️ **Bouton Next** : Navigation vers la question suivante

**Gestion du Timer** :
```dart
void _startTimer() {
  Future.delayed(const Duration(seconds: 1), () {
    if (mounted && _timeRemaining > 0 && _selectedAnswer == null) {
      setState(() => _timeRemaining--);
      _startTimer();
    }
  });
}
```

**Feedback Visuel** :
- ✅ Vert pour la bonne réponse
- ❌ Rouge pour la mauvaise réponse
- Animation douce lors de la sélection

**Widgets avancés** :
- `CircularProgressIndicator` pour le timer visuel
- `ListView.builder` pour afficher les options dynamiquement
- `InkWell` pour les interactions tactiles
- État local avec `setState` pour la réactivité

### 3. Page Leaderboard (LeaderboardPage)

**Objectif** : Afficher le classement des joueurs avec leurs scores (Pas implementer on fait une simulation avec une liste statique).

**Sections** :
1. **Top 3 Joueurs** :
    - Affichage en podium avec avatars
    - Couronne dorée (👑) pour le premier
    - Tailles d'avatars différenciées
    - Scores affichés sous chaque joueur

2. **Liste des Autres Joueurs** :
    - Carte blanche avec design épuré
    - Position, avatar, nom et score
    - Scroll vertical pour navigation

**Personnalisation** :
```dart
final List<Map<String, dynamic>> leaderboard = [
  {'name': 'David James', 'score': 9, 'avatar': '👨‍💼'},
  {'name': 'John Deh', 'score': 8, 'avatar': '👨‍🎓'},
  // ... autres joueurs
];
```

**Design Pattern** :
- Méthode `_buildTopPlayer` pour le podium
- Méthode `_buildLeaderboardItem` pour la liste
- Réutilisation de composants pour cohérence

## 🎨 Palette de Couleurs

```dart
const Color _darkTeal = Color(0xFF1B5E5E);        // Fond principal
const Color _mediumTeal = Color(0xFF2D7A7A);      // Éléments interactifs
const Color _lightBeige = Color(0xFFF5F1E8);      // Fond secondaire
const Color _accentYellow = Color(0xFFFFB84D);    // Boutons d'action
const Color _correctGreen = Color(0xFF6FB3A0);    // Réponses correctes
const Color _textDark = Color(0xFF2C3E50);        // Texte principal
```

## 📊 Modèle de Données (Question)

```dart
class Question {
  final String id;
  final String questionText;
  final bool isCorrect;
  final String theme;
  final int difficulty;
  final String image;
  final List<String> options;
  final String correctAnswer;
}
```

**Chargement depuis JSON** :
```dart
Future<List<Question>> _loadQuestionsFromJson() async {
  final String jsonData = 
    await rootBundle.loadString('assets/data/quizz_questions.json');
  final List<dynamic> list = json.decode(jsonData);
  return list.map((e) => Question.fromJson(e)).toList();
}
```

## 📝 Format du Dataset JSON

```json
{
  "id": "1",
  "questionText": "Quelle est la capitale de la France ?",
  "isCorrect": true,
  "theme": "Géographie",
  "difficulty": 1,
  "image": "./images/france.png",
  "options": ["Paris", "Lyon", "Marseille", "Bordeaux"],
  "correctAnswer": "Paris"
}
```

**Propriétés** :
- `id` : Identifiant unique (String)
- `questionText` : Texte de la question
- `isCorrect` : Indicateur booléen (compatibilité)
- `theme` : Catégorie (Géographie, Histoire, Culture, etc.)
- `difficulty` : Niveau de 1 à 3
- `image` : Chemin vers l'image (transformé automatiquement)
- `options` : Liste des choix possibles
- `correctAnswer` : La réponse correcte (doit correspondre à une option)

## 🔧 Configuration et Installation

### Prérequis
- Flutter SDK (version 3.0 ou supérieure)
- Dart SDK
- IDE (VS Code, Android Studio, ou IntelliJ)

### Installation

1. **Cloner le projet**
```bash
git clone [URL_DU_REPO]
cd quiz_app
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer les assets**

Ajouter dans `pubspec.yaml` :
```yaml
flutter:
  assets:
    - assets/data/quizz_questions.json
    - assets/images/
```

4. **Créer les dossiers nécessaires**
```bash
mkdir -p assets/data
mkdir -p assets/images
```

5. **Ajouter le fichier JSON**
   Placer `quizz_questions.json` dans `assets/data/`

6. **Ajouter les images**
   Placer toutes les images référencées dans `assets/images/`

### Lancement

```bash
# Sur émulateur/simulateur
flutter run

# Sur appareil physique
flutter run -d [device_id]

# Mode release
flutter run --release
```

## 🎯 Fonctionnalités Détaillées

### Timer Automatique
- Compte à rebours de 30 secondes par question
- Passage automatique si le temps expire
- Animation circulaire progressive
- Arrêt automatique lors de la sélection d'une réponse

### Système de Score
- +1 point par bonne réponse
- Score total affiché sur le leaderboard
- Calcul en temps réel
- Persistance durant la session

### Navigation Intelligente
- `pushReplacement` pour éviter le retour arrière
- Transition fluide entre les pages
- Gestion du cycle de vie des widgets

### Feedback Utilisateur
- Changement de couleur immédiat
- Icône de validation (✓) pour bonne réponse
- Délai de 1.5s avant passage à la question suivante
- Désactivation des boutons après sélection

## 📱 Responsive Design

L'application s'adapte à différentes tailles d'écran :
- Utilisation de `MediaQuery` pour les dimensions
- Padding et margin proportionnels
- ScrollView pour le contenu dépassant l'écran
- SafeArea pour éviter les encoches

## 🔄 Gestion d'État

**State Management utilisé** :
- StatefulWidget pour les composants dynamiques
- setState() pour les mises à jour locales
- Passage de données via constructeurs

**Cycle de vie** :
```dart
initState() → _startTimer() → setState() → build()
```

## 🎨 Bonnes Pratiques Implémentées

1. **Séparation des Préoccupations**
    - Modèle de données séparé
    - Méthodes privées pour les widgets réutilisables
    - Constantes pour les couleurs

2. **Code Propre**
    - Nommage explicite des variables
    - Commentaires aux endroits clés
    - Indentation cohérente

3. **Performance**
    - Utilisation de `const` pour les widgets statiques
    - `ListView.builder` pour les listes dynamiques
    - Éviter les reconstructions inutiles

4. **UX/UI**
    - Feedback visuel immédiat
    - Animations fluides
    - Design cohérent et moderne

## 🚀 Améliorations Possibles

- [ ] Persistance des scores avec SharedPreferences
- [ ] Mode sombre / clair
- [ ] Catégories de questions sélectionnables
- [ ] Son pour les bonnes/mauvaises réponses
- [ ] Partage du score sur les réseaux sociaux
- [ ] Classement en ligne avec Firebase
- [ ] Effets d'animation avec AnimatedContainer
- [ ] Support multilingue avec i18n
- [ ] Mode hors ligne complet
- [ ] Statistiques détaillées par thème

## 📚 Concepts Flutter Utilisés

### Widgets
- Scaffold, AppBar, SafeArea
- Column, Row, Stack
- Container, Card, Padding
- ListView, ListView.builder
- TextField, ElevatedButton
- CircleAvatar, Icon
- CircularProgressIndicator

### Navigation
- Navigator.push()
- Navigator.pushReplacement()
- MaterialPageRoute

### Gestion d'État
- StatelessWidget vs StatefulWidget
- setState()
- initState()

### Asynchrone
- async/await
- Future.delayed()
- rootBundle.loadString()

### Styling
- BoxDecoration
- BorderRadius
- BoxShadow
- LinearGradient
- TextStyle

##  Débogage

### Problèmes courants

**Images ne s'affichent pas** :
```dart
// Vérifier le chemin dans pubspec.yaml
flutter:
  assets:
    - assets/images/

// Vérifier le nom exact du fichier
Image.asset('assets/images/france.png')
```

**Erreur de parsing JSON** :
```dart
// Vérifier la structure JSON
// Utiliser jsonlint.com pour valider
```

**Timer ne fonctionne pas** :
```dart
// Vérifier que le widget est mounted
if (mounted) {
  setState(() { ... });
}
```

##  Licence

Ce projet est développé à des fins pédagogiques.


---

**Développé avec ❤️ en Flutter**