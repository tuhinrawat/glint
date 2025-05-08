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
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (isEditable && onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
                tooltip: 'Edit preferences',
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => Chip(
            label: Text(item),
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          )).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
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
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const Divider(),
            _buildDetailRow(
              context,
              'Budget Level:',
              _formatBudgetPreference(preferences.budgetPreference),
            ),
            _buildDetailRow(
              context,
              'Trip Duration:',
              _formatTripDuration(preferences.tripDurationPreference),
            ),
            _buildDetailRow(
              context,
              'Accommodation:',
              preferences.accommodationPreferences.join(', '),
            ),
            if (!preferences.isPublic)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.lock, size: 16),
                    SizedBox(width: 4),
                    Text('Private preferences'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
} 