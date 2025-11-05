import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LearningStyleQuizScreen extends StatelessWidget {
  const LearningStyleQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Style Quiz')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Learning Quiz - Coming Soon'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Complete'),
            ),
          ],
        ),
      ),
    );
  }
}
