# Features

This directory contains all feature modules for the ISM app, organized by functionality.

## Structure

Each feature follows a consistent structure:
```
feature_name/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── providers/
├── domain/
│   ├── models/
│   └── repositories/
└── data/
    └── services/
```

## Features

### Core Features
- **onboarding/** - Avatar creation, business selection, learning style quiz, tutorial
- **profile/** - User profile, progress dashboard, achievements, settings
- **leaderboard/** - Global/friends/regional rankings, challenges, social features

### Learning Pillars
- **economics/** - Economics Tower lessons, quizzes, mini-games
- **management/** - Management Building lessons, quizzes, mini-games
- **business/** - Business Center lessons, quizzes, mini-games
- **marketing/** - Marketing Hub lessons, quizzes, mini-games

### Advanced Features
- **simulation/** - 30-day business simulation
- **shop/** - Avatar items, unlockables, currency management
- **ism_content/** - Success stories, campus tours, application hub, career paths

### Shared
- **shared/** - Widgets, utilities, and components used across multiple features

## Guidelines

1. Keep features isolated and independent
2. Use Riverpod providers for state management
3. Follow clean architecture principles
4. Write tests for each feature
5. Document complex business logic
