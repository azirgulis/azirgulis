import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../../../providers/progress_provider.dart';
import '../../../../core/theme/app_colors.dart';

class DailyReward {
  final int day;
  final int coins;
  final int xp;
  final int gems;
  final String title;
  final IconData icon;

  const DailyReward({
    required this.day,
    required this.coins,
    required this.xp,
    this.gems = 0,
    required this.title,
    required this.icon,
  });
}

class DailyRewardsScreen extends ConsumerStatefulWidget {
  const DailyRewardsScreen({super.key});

  @override
  ConsumerState<DailyRewardsScreen> createState() => _DailyRewardsScreenState();
}

class _DailyRewardsScreenState extends ConsumerState<DailyRewardsScreen> {
  late ConfettiController _confettiController;
  bool _hasClaimedToday = false;

  final List<DailyReward> rewards = const [
    DailyReward(
      day: 1,
      coins: 50,
      xp: 25,
      title: 'Day 1',
      icon: Icons.star,
    ),
    DailyReward(
      day: 2,
      coins: 75,
      xp: 35,
      title: 'Day 2',
      icon: Icons.star,
    ),
    DailyReward(
      day: 3,
      coins: 100,
      xp: 50,
      gems: 1,
      title: 'Day 3',
      icon: Icons.diamond,
    ),
    DailyReward(
      day: 4,
      coins: 125,
      xp: 60,
      title: 'Day 4',
      icon: Icons.star,
    ),
    DailyReward(
      day: 5,
      coins: 150,
      xp: 75,
      gems: 2,
      title: 'Day 5',
      icon: Icons.diamond,
    ),
    DailyReward(
      day: 6,
      coins: 200,
      xp: 100,
      title: 'Day 6',
      icon: Icons.star,
    ),
    DailyReward(
      day: 7,
      coins: 300,
      xp: 150,
      gems: 5,
      title: 'Day 7',
      icon: Icons.emoji_events,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _claimDailyReward() async {
    final progressAsync = ref.read(userProgressProvider);
    if (!progressAsync.hasValue || progressAsync.value == null) return;

    final progress = progressAsync.value!;
    final currentDay = (progress.dailyStreak % 7) == 0 ? 7 : (progress.dailyStreak % 7);
    final reward = rewards[currentDay - 1];

    // Award rewards
    await ref.read(userProgressProvider.notifier).addCoins(reward.coins);
    await ref.read(userProgressProvider.notifier).addXP(reward.xp);
    if (reward.gems > 0) {
      await ref.read(userProgressProvider.notifier).addGems(reward.gems);
    }

    setState(() {
      _hasClaimedToday = true;
    });

    // Show confetti
    _confettiController.play();

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Daily reward claimed! +${reward.coins} coins, +${reward.xp} XP${reward.gems > 0 ? ", +${reward.gems} gems" : ""}',
          ),
          backgroundColor: AppColors.successGreen,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(userProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Rewards'),
      ),
      body: Stack(
        children: [
          progressAsync.when(
            data: (progress) {
              if (progress == null) {
                return const Center(child: Text('No progress data available'));
              }

              final currentDay = (progress.dailyStreak % 7) == 0 ? 7 : (progress.dailyStreak % 7);
              final canClaim = !_hasClaimedToday; // TODO: Check last claim time from server

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Streak info card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.errorRed.withOpacity(0.8),
                            AppColors.errorRed.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.errorRed.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.local_fire_department,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${progress.dailyStreak} Day Streak!',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  canClaim
                                      ? 'Claim your reward for day $currentDay'
                                      : 'Come back tomorrow for more!',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Rewards grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: rewards.length,
                      itemBuilder: (context, index) {
                        final reward = rewards[index];
                        final isClaimed = reward.day < currentDay;
                        final isToday = reward.day == currentDay;
                        final isLocked = reward.day > currentDay;

                        return _buildRewardCard(
                          reward,
                          isClaimed: isClaimed,
                          isToday: isToday,
                          isLocked: isLocked,
                          canClaim: canClaim && isToday,
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Info text
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Log in daily to maintain your streak and claim better rewards!',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error loading rewards: $error'),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(
    DailyReward reward, {
    required bool isClaimed,
    required bool isToday,
    required bool isLocked,
    required bool canClaim,
  }) {
    Color getColor() {
      if (isClaimed) return Colors.grey;
      if (isToday) return AppColors.successGreen;
      return AppColors.primaryColor;
    }

    return Card(
      elevation: isToday && canClaim ? 8 : 2,
      child: InkWell(
        onTap: canClaim ? _claimDailyReward : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isToday && !isClaimed
                ? LinearGradient(
                    colors: [
                      AppColors.successGreen.withOpacity(0.2),
                      AppColors.successGreen.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            border: isToday && !isClaimed
                ? Border.all(
                    color: AppColors.successGreen,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Day badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: getColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  reward.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: getColor(),
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: getColor().withOpacity(isClaimed ? 0.1 : 0.2),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      reward.icon,
                      size: 32,
                      color: getColor(),
                    ),
                    if (isClaimed)
                      const Icon(
                        Icons.check_circle,
                        size: 24,
                        color: Colors.white,
                      ),
                    if (isLocked)
                      const Icon(
                        Icons.lock,
                        size: 24,
                        color: Colors.grey,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Rewards
              Column(
                children: [
                  if (reward.coins > 0)
                    _buildRewardText(
                      Icons.monetization_on,
                      '+${reward.coins}',
                      AppColors.coinsColor,
                      isLocked: isLocked,
                    ),
                  if (reward.xp > 0)
                    _buildRewardText(
                      Icons.stars,
                      '+${reward.xp}',
                      AppColors.xpColor,
                      isLocked: isLocked,
                    ),
                  if (reward.gems > 0)
                    _buildRewardText(
                      Icons.diamond,
                      '+${reward.gems}',
                      AppColors.gemsColor,
                      isLocked: isLocked,
                    ),
                ],
              ),

              if (isToday && canClaim) ...[
                const SizedBox(height: 8),
                Text(
                  'TAP TO CLAIM',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.successGreen,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardText(
    IconData icon,
    String text,
    Color color, {
    bool isLocked = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isLocked ? Colors.grey : color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isLocked ? Colors.grey : color,
            ),
          ),
        ],
      ),
    );
  }
}
