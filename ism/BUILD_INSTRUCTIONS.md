# Build Instructions for ISM App

## Prerequisites

- Flutter SDK 3.2+
- Dart 3.0+
- Firebase CLI (for Firebase configuration)

## Initial Setup

### 1. Install Dependencies

```bash
cd ism
flutter pub get
```

### 2. Run Code Generation

The app uses code generation for Freezed models and Riverpod providers. Run:

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# OR watch mode (recommended during development)
flutter pub run build_runner watch --delete-conflicting-outputs
```

This will generate:
- `*.freezed.dart` files for all Freezed models
- `*.g.dart` files for JSON serialization
- `*.g.dart` files for Riverpod providers

### 3. Configure Firebase

**Option A: Use FlutterFire CLI (Recommended)**

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

This will automatically create `lib/core/constants/firebase_options.dart` with your Firebase configuration.

**Option B: Manual Configuration**

1. Create a Firebase project at https://console.firebase.google.com
2. Add Android and iOS apps to your Firebase project
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Place them in:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
5. Update `lib/core/constants/firebase_options.dart` with your Firebase config

### 4. Set Up Firebase Services

In your Firebase console:

1. **Authentication**
   - Enable Email/Password
   - Enable Google Sign-In
   - (Optional) Enable Anonymous Sign-In

2. **Cloud Firestore**
   - Create database
   - Start in test mode (or configure security rules)

3. **Firebase Storage**
   - Create default bucket
   - Configure security rules

4. **Firebase Analytics**
   - Automatically enabled

5. **Cloud Messaging** (for notifications)
   - Set up as needed

### 5. Run the App

```bash
# Development
flutter run

# With specific device
flutter run -d <device-id>

# Release build
flutter run --release
```

## Common Issues

### Build Runner Conflicts

If you encounter conflicts during code generation:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Firebase Configuration Errors

Make sure:
- `google-services.json` and `GoogleService-Info.plist` are in the correct locations
- Firebase is initialized in `main.dart`
- All Firebase services are enabled in your Firebase console

### Missing Generated Files

If you see errors about missing `.g.dart` or `.freezed.dart` files, run:

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Development Workflow

1. Make changes to models or providers
2. Build runner will auto-generate code (if in watch mode)
3. Hot reload/restart the app

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/path/to/test_file.dart
```

## Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build for iOS
flutter build ios --release
```

## Firebase Security Rules

### Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }

    // Progress collection
    match /progress/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }

    // Leaderboard (read-only for all authenticated users)
    match /leaderboard/{entry} {
      allow read: if request.auth != null;
      allow write: if false; // Only server-side writes
    }

    // Challenges (read for all, write restricted)
    match /challenges/{challengeId} {
      allow read: if request.auth != null;
      allow write: if false; // Only server-side writes
    }
  }
}
```

### Storage Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.resource.size < 5 * 1024 * 1024; // 5MB limit
    }
  }
}
```

## Environment Variables

For API keys (news, stocks), create a `.env` file:

```
NEWS_API_KEY=your_news_api_key
STOCK_API_KEY=your_stock_api_key
```

Add `.env` to `.gitignore` (already done).

## Troubleshooting

### "Bad state: No element" Error

This usually means Firebase isn't properly initialized. Check:
1. Firebase configuration in `firebase_options.dart`
2. Firebase initialization in `main.dart`
3. Firebase services are enabled in console

### Google Sign-In Not Working

Android:
- Add SHA-1 certificate fingerprint to Firebase console
- Check `google-services.json` is up to date

iOS:
- Add URL schemes to `Info.plist`
- Check `GoogleService-Info.plist` is included

### Build Runner Hanging

Kill the process and restart:
```bash
pkill -f build_runner
flutter pub run build_runner build --delete-conflicting-outputs
```

## Next Steps

After setup, you can:
1. Run the app and create an account
2. Complete the onboarding flow
3. Explore the four learning pillars
4. Track your progress and earn rewards

For development:
1. Check `TODO.md` for implementation roadmap
2. See `CONTRIBUTING.md` for contribution guidelines
3. Review `README.md` for project overview
