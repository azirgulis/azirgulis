import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 100),
            const SizedBox(height: 24),
            const Text('Welcome to ISM!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => context.go('/onboarding/avatar'),
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
