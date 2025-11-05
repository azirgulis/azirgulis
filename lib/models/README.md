# Models

This directory contains all data models for the ISM app, using Freezed for immutability and code generation.

## Structure

- **user_model.dart** - User profile, avatar, preferences
- **progress_model.dart** - XP, level, coins, gems, progress tracking
- **lesson_model.dart** - Lesson content, type, difficulty, completion status
- **quiz_model.dart** - Quiz questions, answers, explanations, results
- **achievement_model.dart** - Badges, rewards, unlock conditions
- **business_model.dart** - Virtual business profile (name, industry, stats)
- **leaderboard_model.dart** - Leaderboard entries and rankings
- **challenge_model.dart** - Weekly challenges and competitions

## Usage

All models use Freezed for immutability and JSON serialization:

```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String username,
    // ... more fields
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

Run code generation after creating/modifying models:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
