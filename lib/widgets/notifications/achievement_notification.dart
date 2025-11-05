import 'package:flutter/material.dart';
import '../../models/achievement_model.dart';
import '../../core/theme/app_colors.dart';

class AchievementNotification extends StatefulWidget {
  final AchievementModel achievement;
  final VoidCallback onDismiss;
  final VoidCallback? onTap;

  const AchievementNotification({
    super.key,
    required this.achievement,
    required this.onDismiss,
    this.onTap,
  });

  @override
  State<AchievementNotification> createState() =>
      _AchievementNotificationState();
}

class _AchievementNotificationState extends State<AchievementNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _controller.forward();

    // Auto dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  Color _getRarityColor() {
    switch (widget.achievement.rarity) {
      case AchievementRarity.common:
        return AppColors.badgeCommon;
      case AchievementRarity.rare:
        return AppColors.badgeRare;
      case AchievementRarity.epic:
        return AppColors.badgeEpic;
      case AchievementRarity.legendary:
        return AppColors.badgeLegendary;
    }
  }

  String _getRarityLabel() {
    switch (widget.achievement.rarity) {
      case AchievementRarity.common:
        return 'COMMON';
      case AchievementRarity.rare:
        return 'RARE';
      case AchievementRarity.epic:
        return 'EPIC';
      case AchievementRarity.legendary:
        return 'LEGENDARY';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () {
                if (widget.onTap != null) {
                  _dismiss();
                  widget.onTap!();
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getRarityColor().withOpacity(0.2),
                      _getRarityColor().withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getRarityColor(),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    // Achievement Icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: _getRarityColor().withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getRarityColor(),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _getIconData(widget.achievement.iconName),
                          color: _getRarityColor(),
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Achievement Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Rarity Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getRarityColor(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getRarityLabel(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Title
                          Text(
                            'Achievement Unlocked!',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.achievement.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _getRarityColor(),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),

                          // Rewards
                          Row(
                            children: [
                              if (widget.achievement.coinsReward > 0) ...[
                                Icon(
                                  Icons.monetization_on,
                                  size: 14,
                                  color: AppColors.coinsColor,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '+${widget.achievement.coinsReward}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.coinsColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              if (widget.achievement.xpReward > 0) ...[
                                Icon(
                                  Icons.stars,
                                  size: 14,
                                  color: AppColors.xpColor,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '+${widget.achievement.xpReward}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.xpColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              if (widget.achievement.gemsReward > 0) ...[
                                Icon(
                                  Icons.diamond,
                                  size: 14,
                                  color: AppColors.gemsColor,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '+${widget.achievement.gemsReward}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.gemsColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Dismiss Button
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: _dismiss,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    // Map string icon names to IconData
    switch (iconName) {
      case 'emoji_events':
        return Icons.emoji_events;
      case 'school':
        return Icons.school;
      case 'check_circle':
        return Icons.check_circle;
      case 'trending_up':
        return Icons.trending_up;
      case 'psychology':
        return Icons.psychology;
      case 'business_center':
        return Icons.business_center;
      case 'campaign':
        return Icons.campaign;
      case 'grade':
        return Icons.grade;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'flash_on':
        return Icons.flash_on;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'group':
        return Icons.group;
      case 'leaderboard':
        return Icons.leaderboard;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'nightlight':
        return Icons.nightlight;
      case 'apartment':
        return Icons.apartment;
      case 'auto_stories':
        return Icons.auto_stories;
      case 'speed':
        return Icons.speed;
      case 'done_all':
        return Icons.done_all;
      case 'diamond':
        return Icons.diamond;
      case 'attach_money':
        return Icons.attach_money;
      default:
        return Icons.star;
    }
  }
}

/// Overlay entry manager for showing achievement notifications
class AchievementNotificationOverlay {
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context,
    AchievementModel achievement, {
    VoidCallback? onTap,
  }) {
    // Remove existing notification if any
    hide();

    _currentEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: AchievementNotification(
          achievement: achievement,
          onDismiss: hide,
          onTap: onTap,
        ),
      ),
    );

    Overlay.of(context).insert(_currentEntry!);
  }

  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}
