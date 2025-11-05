import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/progress_provider.dart';
import '../../../../core/theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final progress = ref.watch(userProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ISM - Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag),
            onPressed: () => context.push('/shop'),
            tooltip: 'Avatar Shop',
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () => context.push('/achievements'),
            tooltip: 'Achievements',
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: user.when(
        data: (userData) {
          if (userData == null) return const Center(child: Text('Not logged in'));
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome, ${userData.username}!',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 24),
                
                // Progress card
                progress.when(
                  data: (progressData) {
                    if (progressData == null) return const SizedBox();
                    return Card(
                      child: InkWell(
                        onTap: () => context.push('/progress'),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Level ${progressData.level}',
                                        style: Theme.of(context).textTheme.titleLarge),
                                    const SizedBox(height: 8),
                                    Text('XP: ${progressData.xp}'),
                                    Text('Coins: ${progressData.coins}'),
                                    Text('Gems: ${progressData.gems}'),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                ),
                
                const SizedBox(height: 24),
                
                // The Four Pillars
                Text('The Four Pillars',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildPillarCard(
                      context,
                      'Economics Tower',
                      Icons.trending_up,
                      AppColors.economicsColor,
                      () => context.go('/economics'),
                    ),
                    _buildPillarCard(
                      context,
                      'Management Building',
                      Icons.people,
                      AppColors.managementColor,
                      () => context.go('/management'),
                    ),
                    _buildPillarCard(
                      context,
                      'Business Center',
                      Icons.business,
                      AppColors.businessColor,
                      () => context.go('/business'),
                    ),
                    _buildPillarCard(
                      context,
                      'Marketing Hub',
                      Icons.campaign,
                      AppColors.marketingColor,
                      () => context.go('/marketing'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Quick actions
                ElevatedButton.icon(
                  onPressed: () => context.push('/rewards'),
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('Daily Rewards'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorRed,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => context.go('/leaderboard'),
                  icon: const Icon(Icons.leaderboard),
                  label: const Text('View Leaderboard'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildPillarCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
