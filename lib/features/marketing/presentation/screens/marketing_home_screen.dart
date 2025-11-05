import 'package:flutter/material.dart';

class MarketingHomeScreen extends StatelessWidget {
  const MarketingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketing Hub')),
      body: const Center(child: Text('Marketing - Coming Soon')),
    );
  }
}
