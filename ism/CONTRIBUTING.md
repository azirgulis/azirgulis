# Contributing to ISM App

Thank you for your interest in contributing to the ISM educational app! This document provides guidelines and instructions for contributing.

## Getting Started

1. **Fork the repository** and clone it locally
2. **Install dependencies**: `flutter pub get`
3. **Run code generation**: `flutter pub run build_runner build`
4. **Create a branch** for your feature/fix: `git checkout -b feature/your-feature-name`

## Development Workflow

### Code Style

- Follow the [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format .` to format code before committing
- Run `flutter analyze` to check for issues
- Maintain trailing commas for better diffs
- Use single quotes for strings
- Prefer const constructors where possible

### Commit Messages

Use clear, descriptive commit messages following this format:
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Build process or auxiliary tool changes

**Examples:**
```
feat(economics): add Market Matcher mini-game

Implement drag-and-drop supply/demand curve matching game
with 20 levels and scoring system.

Closes #42
```

```
fix(quiz): correct XP calculation for perfect scores

Previously gems were awarded but XP was not doubled.
Now awards 2x XP for 100% quiz scores.

Fixes #58
```

### Code Generation

After modifying models with Freezed or JSON serialization:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or use watch mode during development:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Write integration tests for user flows
- Aim for 80%+ code coverage

Run tests:
```bash
flutter test
flutter test --coverage
```

### Pull Request Process

1. **Update documentation** if you're changing functionality
2. **Add tests** for new features
3. **Update TODO.md** if completing tasks
4. **Ensure CI passes** (tests, linting, formatting)
5. **Request review** from at least one maintainer
6. **Address feedback** promptly

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Screenshots/Videos
(If applicable)

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests pass locally
```

## Project Structure

```
lib/
├── core/              # App-wide utilities and configuration
├── features/          # Feature modules (onboarding, economics, etc.)
├── models/            # Data models (Freezed)
├── providers/         # Riverpod providers
├── services/          # API, Firebase, local storage services
└── widgets/           # Reusable UI components

assets/                # Images, videos, animations
test/                  # Tests
```

## Adding New Features

### 1. Create Feature Module

```
lib/features/your_feature/
├── presentation/
│   ├── screens/
│   │   └── your_screen.dart
│   └── widgets/
│       └── your_widget.dart
├── domain/
│   └── models/
│       └── your_model.dart
└── data/
    └── services/
        └── your_service.dart
```

### 2. Create Models (if needed)

```dart
// lib/models/your_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'your_model.freezed.dart';
part 'your_model.g.dart';

@freezed
class YourModel with _$YourModel {
  const factory YourModel({
    required String id,
    required String name,
  }) = _YourModel;

  factory YourModel.fromJson(Map<String, dynamic> json) =>
      _$YourModelFromJson(json);
}
```

### 3. Create Providers

```dart
// lib/providers/your_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'your_provider.g.dart';

@riverpod
class YourNotifier extends _$YourNotifier {
  @override
  YourState build() {
    return const YourState.initial();
  }

  Future<void> doSomething() async {
    // Implementation
  }
}
```

### 4. Create Screens

```dart
// lib/features/your_feature/presentation/screens/your_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourScreen extends ConsumerWidget {
  const YourScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Screen')),
      body: const Center(child: Text('Content')),
    );
  }
}
```

### 5. Write Tests

```dart
// test/features/your_feature/your_screen_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('YourScreen displays title', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: YourScreen()),
      ),
    );

    expect(find.text('Your Screen'), findsOneWidget);
  });
}
```

## Firebase Setup

When adding Firebase features:

1. Update security rules in Firebase Console
2. Document the database structure
3. Handle errors gracefully
4. Implement offline support where applicable
5. Add analytics events

## Internationalization

When adding new strings:

1. Add to ARB files: `lib/l10n/app_en.arb`, `lib/l10n/app_lt.arb`
2. Run code generation: `flutter gen-l10n`
3. Use in code: `AppLocalizations.of(context)!.yourString`

## Asset Management

When adding assets:

1. Place in appropriate directory: `assets/images/`, `assets/videos/`, `assets/animations/`
2. Add to `pubspec.yaml` if not covered by existing patterns
3. Optimize images (use WebP for smaller sizes)
4. Document asset naming conventions

## Code Review Guidelines

### For Authors
- Keep PRs focused and reasonably sized
- Respond to feedback constructively
- Update PR based on review comments
- Mark conversations as resolved

### For Reviewers
- Be constructive and respectful
- Focus on code quality, not personal preferences
- Suggest improvements with examples
- Approve when satisfied

## Issue Reporting

### Bug Reports

```markdown
**Describe the bug**
Clear description of the bug

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What should happen

**Screenshots**
If applicable

**Device info**
- OS: [e.g. Android 13, iOS 16]
- Device: [e.g. Pixel 7, iPhone 14]
- App version: [e.g. 1.0.0]
```

### Feature Requests

```markdown
**Feature description**
Clear description of the feature

**Use case**
Why is this feature needed?

**Proposed solution**
How should this work?

**Alternatives**
Other approaches considered
```

## Community Guidelines

- Be respectful and inclusive
- Help others learn and grow
- Give credit where due
- Follow the code of conduct

## Questions?

- Open a GitHub Discussion for general questions
- Open an Issue for bugs or feature requests
- Contact the maintainers for sensitive matters

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

**Thank you for contributing to ISM! 🎓**
