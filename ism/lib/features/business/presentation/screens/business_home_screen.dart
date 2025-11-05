import 'package:flutter/material.dart';

class BusinessHomeScreen extends StatelessWidget {
  const BusinessHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Center')),
      body: const Center(child: Text('Business - Coming Soon')),
    );
  }
}
