import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AvatarCreationScreen extends StatelessWidget {
  const AvatarCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Your Avatar')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Avatar Creation - Coming Soon'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/onboarding/business'),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
