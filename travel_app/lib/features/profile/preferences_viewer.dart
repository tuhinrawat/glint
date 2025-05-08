import 'package:flutter/material.dart';
import '../../models/travel_preferences.dart';

class PreferencesViewer extends StatelessWidget {
  final TravelPreferences preferences;
  final bool isEditable;
  final VoidCallback? onEdit;

  const PreferencesViewer({
    super.key,
    required this.preferences,
    this.isEditable = false,
    this.onEdit,
  });

  Widget _buildPreferenceSection(BuildContext context, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getSectionIcon(title),
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              if (isEditable && onEdit != null)
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => _buildPreferenceChip(context, item)).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPreferenceChip(BuildContext context, String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  IconData _getSectionIcon(String title) {
    return switch (title) {
      'Favorite Destinations' => Icons.place,
      'Travel Styles' => Icons.style,
      'Preferred Activities' => Icons.local_activity,
      'Cuisine Preferences' => Icons.restaurant,
      'Travel Details' => Icons.article,
      _ => Icons.favorite,
    };
  }

  Widget _buildDetailSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.article,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Travel Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              if (isEditable && onEdit != null)
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
        ),
        _buildDetailItem(
          context,
          'Budget Level',
          _formatBudgetPreference(preferences.budgetPreference),
          Icons.attach_money,
        ),
        _buildDetailItem(
          context,
          'Trip Duration',
          _formatTripDuration(preferences.tripDurationPreference),
          Icons.timelapse,
        ),
        _buildDetailItem(
          context,
          'Accommodation',
          preferences.accommodationPreferences.join(', '),
          Icons.hotel,
        ),
        _buildDetailItem(
          context,
          'Cuisine',
          preferences.cuisinePreferences.join(', '),
          Icons.restaurant,
        ),
        if (preferences.languages.isNotEmpty)
          _buildDetailItem(
            context,
            'Languages',
            preferences.languages.join(', '),
            Icons.language,
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBudgetPreference(BudgetPreference pref) {
    return switch (pref) {
      BudgetPreference.budget => 'Budget-friendly',
      BudgetPreference.moderate => 'Moderate spender',
      BudgetPreference.luxury => 'Luxury traveler',
      BudgetPreference.ultraLuxury => 'Ultra-luxury enthusiast',
    };
  }

  String _formatTripDuration(TripDurationPreference pref) {
    return switch (pref) {
      TripDurationPreference.short => '1-3 days trips',
      TripDurationPreference.medium => '4-7 days trips',
      TripDurationPreference.long => '1-2 weeks trips',
      TripDurationPreference.extended => 'Extended trips (2+ weeks)',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.travel_explore,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Travel Preferences',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (!preferences.isPublic)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 16,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Private',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const Divider(height: 24),
            _buildPreferenceSection(
              context,
              'Favorite Destinations',
              preferences.favoriteDestinationTypes,
            ),
            _buildPreferenceSection(
              context,
              'Travel Styles',
              preferences.travelStyles,
            ),
            _buildPreferenceSection(
              context,
              'Preferred Activities',
              preferences.activities,
            ),
            _buildPreferenceSection(
              context,
              'Cuisine Preferences',
              preferences.cuisinePreferences,
            ),
            _buildDetailSection(context),
          ],
        ),
      ),
    );
  }
} 