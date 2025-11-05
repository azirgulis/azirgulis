import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusinessSelectionScreen extends StatelessWidget {
  const BusinessSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your Business')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Business Selection - Coming Soon'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/onboarding/quiz'),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
