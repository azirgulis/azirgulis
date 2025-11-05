import 'package:flutter/material.dart';
import '../../../../models/lesson_model.dart';

class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final Color pillarColor;
  final VoidCallback onTap;
  final bool isCompleted;
  final bool isLocked;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.pillarColor,
    required this.onTap,
    this.isCompleted = false,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isLocked ? 1 : 2,
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: isLocked ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Lesson Number Circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? pillarColor
                        : pillarColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: pillarColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isLocked
                        ? Icon(
                            Icons.lock,
                            color: pillarColor,
                            size: 24,
                          )
                        : isCompleted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 28,
                              )
                            : Text(
                                '${lesson.lessonNumber}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: pillarColor,
                                ),
                              ),
                  ),
                ),
                const SizedBox(width: 16),

                // Lesson Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lesson.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                            context,
                            Icons.access_time,
                            '${lesson.estimatedMinutes} min',
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            context,
                            Icons.signal_cellular_alt,
                            lesson.difficulty,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            context,
                            Icons.monetization_on,
                            '+${lesson.coinsReward}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  isLocked
                      ? Icons.lock_outline
                      : Icons.arrow_forward_ios,
                  color: pillarColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: pillarColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: pillarColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: pillarColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
