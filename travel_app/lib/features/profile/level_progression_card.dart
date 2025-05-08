import 'package:flutter/material.dart';
import '../../models/user_level.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_styles.dart';

class LevelProgressionCard extends StatelessWidget {
  final UserLevel currentLevel;
  final UserLevel nextLevel;
  final double progress;
  final int totalPoints;

  const LevelProgressionCard({
    super.key,
    required this.currentLevel,
    required this.nextLevel,
    required this.progress,
    required this.totalPoints,
  });

  @override
  Widget build(BuildContext context) {
    final isMaxLevel = currentLevel.id == nextLevel.id;

    return Card(
      margin: const EdgeInsets.all(16),
      color: AppTheme.surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Current level badge or icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                  child: Icon(
                    Icons.psychology, // Placeholder icon
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentLevel.title,
                        style: CommonStyles.headingMedium(context),
                      ),
                      Text(
                        currentLevel.description,
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: AppTheme.fontSizeSmall,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Points: $totalPoints',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Progress bar and next level information
            if (!isMaxLevel) ...[
              Row(
                children: [
                  Text(
                    '${currentLevel.requiredPoints}',
                    style: CommonStyles.levelText(context),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[700],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                          minHeight: 10,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${nextLevel.requiredPoints}',
                    style: CommonStyles.levelText(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isMaxLevel 
                    ? 'You have reached the highest level!'
                    : 'Next Level: ${nextLevel.title} (${(progress * 100).toInt()}% complete)',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeSmall,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              if (!isMaxLevel)
                Text(
                  'Need ${nextLevel.requiredPoints - totalPoints} more points',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ] else ...[
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMedium,
                    vertical: AppTheme.spacingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: Text(
                    'Maximum Level Achieved!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppTheme.fontSizeSmall,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 