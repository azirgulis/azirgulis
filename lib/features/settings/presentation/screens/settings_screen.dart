import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../providers/settings_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // User section
            currentUserAsync.when(
              data: (user) {
                if (user == null) return const SizedBox();
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.primaryColor,
                          child: Text(
                            user.username[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.username,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 24),

            // Appearance section
            _buildSectionHeader(context, 'Appearance'),
            _buildSettingTile(
              context: context,
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Switch between light and dark theme',
              trailing: Switch(
                value: settings.isDarkMode,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).setDarkMode(value);
                },
                activeColor: AppColors.primaryColor,
              ),
            ),
            _buildSettingTile(
              context: context,
              icon: Icons.text_fields,
              title: 'Text Size',
              subtitle: 'Adjust text size: ${(settings.textSize * 100).toInt()}%',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showTextSizeDialog(context, ref, settings.textSize),
            ),

            const SizedBox(height: 24),

            // Notifications section
            _buildSectionHeader(context, 'Notifications'),
            _buildSettingTile(
              context: context,
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive updates about your progress',
              trailing: Switch(
                value: settings.notificationsEnabled,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).toggleNotifications();
                },
                activeColor: AppColors.primaryColor,
              ),
            ),
            _buildSettingTile(
              context: context,
              icon: Icons.volume_up,
              title: 'Sound',
              subtitle: 'Play sounds for achievements and rewards',
              trailing: Switch(
                value: settings.soundEnabled,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).toggleSound();
                },
                activeColor: AppColors.primaryColor,
              ),
            ),

            const SizedBox(height: 24),

            // Content section
            _buildSectionHeader(context, 'Content'),
            _buildSettingTile(
              context: context,
              icon: Icons.play_circle,
              title: 'Auto-play Videos',
              subtitle: 'Automatically play lesson videos',
              trailing: Switch(
                value: settings.autoPlayVideos,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).toggleAutoPlayVideos();
                },
                activeColor: AppColors.primaryColor,
              ),
            ),
            _buildSettingTile(
              context: context,
              icon: Icons.language,
              title: 'Language',
              subtitle: _getLanguageLabel(settings.language),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLanguageDialog(context, ref, settings.language),
            ),

            const SizedBox(height: 24),

            // About section
            _buildSectionHeader(context, 'About'),
            _buildSettingTile(
              context: context,
              icon: Icons.info,
              title: 'App Version',
              subtitle: '1.0.0',
              trailing: const SizedBox(),
            ),
            _buildSettingTile(
              context: context,
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              trailing: const Icon(Icons.open_in_new),
              onTap: () {
                // TODO: Open privacy policy
              },
            ),
            _buildSettingTile(
              context: context,
              icon: Icons.description,
              title: 'Terms of Service',
              trailing: const Icon(Icons.open_in_new),
              onTap: () {
                // TODO: Open terms of service
              },
            ),

            const SizedBox(height: 24),

            // Account section
            _buildSectionHeader(context, 'Account'),
            _buildSettingTile(
              context: context,
              icon: Icons.logout,
              title: 'Sign Out',
              titleColor: AppColors.errorRed,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showSignOutDialog(context, ref),
            ),

            const SizedBox(height: 32),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading settings: $error'),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (titleColor ?? AppColors.primaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: titleColor ?? AppColors.primaryColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  String _getLanguageLabel(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'lt':
        return 'Lietuvių';
      default:
        return 'English';
    }
  }

  void _showTextSizeDialog(
    BuildContext context,
    WidgetRef ref,
    double currentSize,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Size'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Preview Text',
                  style: TextStyle(fontSize: 16 * currentSize),
                ),
                const SizedBox(height: 16),
                Slider(
                  value: currentSize,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  label: '${(currentSize * 100).toInt()}%',
                  onChanged: (value) {
                    setState(() {});
                    ref.read(settingsProvider.notifier).setTextSize(value);
                  },
                ),
                Text('${(currentSize * 100).toInt()}%'),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    String currentLanguage,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setLanguage(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Lietuvių (Coming Soon)'),
              value: 'lt',
              groupValue: currentLanguage,
              onChanged: null, // Disabled for now
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(signOutProvider.future);
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.errorRed,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
