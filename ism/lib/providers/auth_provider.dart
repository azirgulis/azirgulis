import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/auth/auth_service.dart';
import '../services/firestore/firestore_service.dart';
import '../models/user_model.dart';

part 'auth_provider.g.dart';

// Auth service provider
@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

// Firestore service provider
@riverpod
FirestoreService firestoreService(FirestoreServiceRef ref) {
  return FirestoreService();
}

// Current Firebase user stream
@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}

// Current user model provider
@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  Future<UserModel?> build() async {
    final authService = ref.watch(authServiceProvider);
    final firestoreService = ref.watch(firestoreServiceProvider);
    final firebaseUser = authService.currentUser;

    if (firebaseUser == null) return null;

    try {
      final userData = await firestoreService.getUser(firebaseUser.uid);
      if (userData == null) return null;

      return UserModel.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final firestoreService = ref.read(firestoreServiceProvider);
      final firebaseUser = authService.currentUser;

      if (firebaseUser == null) return null;

      final userData = await firestoreService.getUser(firebaseUser.uid);
      if (userData == null) return null;

      return UserModel.fromJson(userData);
    });
  }

  Future<void> updateUser(Map<String, dynamic> updates) async {
    final user = state.value;
    if (user == null) return;

    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.updateUser(user.id, updates);
    await refresh();
  }
}

// Sign up provider
@riverpod
class SignUp extends _$SignUp {
  @override
  FutureOr<void> build() {}

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final firestoreService = ref.read(firestoreServiceProvider);

      // Create Firebase user
      final credential = await authService.signUpWithEmail(
        email: email,
        password: password,
        username: username,
      );

      // Create user document in Firestore
      final userData = {
        'id': credential.user!.uid,
        'email': email,
        'username': username,
        'displayName': username,
        'photoUrl': null,
        'createdAt': DateTime.now().toIso8601String(),
        'isAnonymous': false,
        'preferredLanguage': 'en',
        'friends': [],
        'friendRequests': [],
      };

      await firestoreService.createUser(credential.user!.uid, userData);

      // Initialize user progress
      final progressData = {
        'userId': credential.user!.uid,
        'level': 1,
        'xp': 0,
        'coins': 0,
        'gems': 0,
        'dailyStreak': 0,
        'pillarProgress': {},
        'unlockedAchievements': [],
        'totalLessonsCompleted': 0,
        'totalQuizzesTaken': 0,
      };

      await firestoreService.saveProgress(credential.user!.uid, progressData);

      // Refresh current user
      ref.invalidate(currentUserProvider);
    });
  }
}

// Sign in provider
@riverpod
class SignIn extends _$SignIn {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithEmail(email: email, password: password);
      ref.invalidate(currentUserProvider);
    });
  }
}

// Sign in with Google provider
@riverpod
class GoogleSignIn extends _$GoogleSignIn {
  @override
  FutureOr<void> build() {}

  Future<void> signIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final firestoreService = ref.read(firestoreServiceProvider);

      final credential = await authService.signInWithGoogle();
      final user = credential.user!;

      // Check if user document exists
      final existingUser = await firestoreService.getUser(user.uid);

      if (existingUser == null) {
        // Create new user document
        final userData = {
          'id': user.uid,
          'email': user.email ?? '',
          'username': user.displayName ?? 'User',
          'displayName': user.displayName,
          'photoUrl': user.photoURL,
          'createdAt': DateTime.now().toIso8601String(),
          'isAnonymous': false,
          'preferredLanguage': 'en',
          'friends': [],
          'friendRequests': [],
        };

        await firestoreService.createUser(user.uid, userData);

        // Initialize progress
        final progressData = {
          'userId': user.uid,
          'level': 1,
          'xp': 0,
          'coins': 0,
          'gems': 0,
          'dailyStreak': 0,
          'pillarProgress': {},
          'unlockedAchievements': [],
          'totalLessonsCompleted': 0,
          'totalQuizzesTaken': 0,
        };

        await firestoreService.saveProgress(user.uid, progressData);
      }

      ref.invalidate(currentUserProvider);
    });
  }
}

// Sign out provider
@riverpod
class SignOut extends _$SignOut {
  @override
  FutureOr<void> build() {}

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      ref.invalidate(currentUserProvider);
    });
  }
}
