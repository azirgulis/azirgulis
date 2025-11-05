import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/onboarding/presentation/screens/avatar_creation_screen.dart';
import '../../features/onboarding/presentation/screens/business_selection_screen.dart';
import '../../features/onboarding/presentation/screens/learning_style_quiz_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/economics/presentation/screens/economics_home_screen.dart';
import '../../features/economics/presentation/screens/lesson_detail_screen.dart';
import '../../features/economics/presentation/screens/quiz_screen.dart';
import '../../features/economics/presentation/screens/quiz_results_screen.dart';
import '../../features/economics/presentation/games/market_matcher_game.dart';
import '../../features/management/presentation/screens/management_home_screen.dart';
import '../../features/business/presentation/screens/business_home_screen.dart';
import '../../features/marketing/presentation/screens/marketing_home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/leaderboard/presentation/screens/leaderboard_screen.dart';
import '../../features/achievements/presentation/screens/achievements_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../providers/auth_provider.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';
      final isOnboarding = state.matchedLocation.startsWith('/onboarding');
      final isSplash = state.matchedLocation == '/splash';

      // Allow splash screen
      if (isSplash) return null;

      // If not logged in and not on auth screens, go to login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // If logged in and on auth screens, go to home
      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding/avatar',
        builder: (context, state) => const AvatarCreationScreen(),
      ),
      GoRoute(
        path: '/onboarding/business',
        builder: (context, state) => const BusinessSelectionScreen(),
      ),
      GoRoute(
        path: '/onboarding/quiz',
        builder: (context, state) => const LearningStyleQuizScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/economics',
        builder: (context, state) => const EconomicsHomeScreen(),
      ),
      GoRoute(
        path: '/economics/lesson/:lessonNumber',
        builder: (context, state) {
          final lessonNumber = int.parse(state.pathParameters['lessonNumber']!);
          return LessonDetailScreen(lessonNumber: lessonNumber);
        },
      ),
      GoRoute(
        path: '/economics/lesson/:lessonNumber/quiz',
        builder: (context, state) {
          final lessonNumber = int.parse(state.pathParameters['lessonNumber']!);
          return QuizScreen(lessonNumber: lessonNumber);
        },
      ),
      GoRoute(
        path: '/economics/lesson/:lessonNumber/quiz/results',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return QuizResultsScreen(
            correctAnswers: extra['correctAnswers'] as int,
            totalQuestions: extra['totalQuestions'] as int,
            score: extra['score'] as int,
            xpEarned: extra['xpEarned'] as int,
            coinsEarned: extra['coinsEarned'] as int,
            gemsEarned: extra['gemsEarned'] as int,
            isPerfect: extra['isPerfect'] as bool,
          );
        },
      ),
      GoRoute(
        path: '/economics/games/market-matcher',
        builder: (context, state) => const MarketMatcherGame(),
      ),
      GoRoute(
        path: '/management',
        builder: (context, state) => const ManagementHomeScreen(),
      ),
      GoRoute(
        path: '/business',
        builder: (context, state) => const BusinessHomeScreen(),
      ),
      GoRoute(
        path: '/marketing',
        builder: (context, state) => const MarketingHomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

// Splash screen (temporary, will be moved to features)
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'ISM',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Build Your Business Empire',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
