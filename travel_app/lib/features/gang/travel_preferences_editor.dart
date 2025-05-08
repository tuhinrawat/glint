import 'package:flutter/material.dart';
import '../../models/travel_preferences.dart';

class TravelPreferencesEditor extends StatefulWidget {
  final TravelPreferences initialPreferences;
  final Function(TravelPreferences) onSave;

  const TravelPreferencesEditor({
    super.key,
    required this.initialPreferences,
    required this.onSave,
  });

  @override
  State<TravelPreferencesEditor> createState() => _TravelPreferencesEditorState();
}

class _TravelPreferencesEditorState extends State<TravelPreferencesEditor> {
  late TravelPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = widget.initialPreferences;
  }

  void _updatePreferences() {
    widget.onSave(_preferences);
    Navigator.pop(context);
  }

  Widget _buildMultiSelectSection(String title, List<String> selected, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (bool value) {
                setState(() {
                  if (value) {
                    selected.add(option);
                  } else {
                    selected.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Preferences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _updatePreferences,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMultiSelectSection(
              'Favorite Destinations',
              _preferences.favoriteDestinationTypes,
              TravelPreferences.destinationTypes,
            ),
            _buildMultiSelectSection(
              'Travel Styles',
              _preferences.travelStyles,
              TravelPreferences.styles,
            ),
            _buildMultiSelectSection(
              'Accommodation',
              _preferences.accommodationPreferences,
              TravelPreferences.accommodations,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budget Preference',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SegmentedButton<BudgetPreference>(
                  segments: BudgetPreference.values.map((pref) {
                    return ButtonSegment<BudgetPreference>(
                      value: pref,
                      label: Text(pref.name.toUpperCase()),
                    );
                  }).toList(),
                  selected: {_preferences.budgetPreference},
                  onSelectionChanged: (Set<BudgetPreference> selection) {
                    setState(() {
                      _preferences = TravelPreferences(
                        favoriteDestinationTypes: _preferences.favoriteDestinationTypes,
                        travelStyles: _preferences.travelStyles,
                        accommodationPreferences: _preferences.accommodationPreferences,
                        budgetPreference: selection.first,
                        cuisinePreferences: _preferences.cuisinePreferences,
                        activities: _preferences.activities,
                        tripDurationPreference: _preferences.tripDurationPreference,
                        languages: _preferences.languages,
                        isPublic: _preferences.isPublic,
                      );
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Duration',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SegmentedButton<TripDurationPreference>(
                  segments: TripDurationPreference.values.map((duration) {
                    String label = switch (duration) {
                      TripDurationPreference.short => '1-3d',
                      TripDurationPreference.medium => '4-7d',
                      TripDurationPreference.long => '1-2w',
                      TripDurationPreference.extended => '2w+',
                    };
                    return ButtonSegment<TripDurationPreference>(
                      value: duration,
                      label: Text(label),
                    );
                  }).toList(),
                  selected: {_preferences.tripDurationPreference},
                  onSelectionChanged: (Set<TripDurationPreference> selection) {
                    setState(() {
                      _preferences = TravelPreferences(
                        favoriteDestinationTypes: _preferences.favoriteDestinationTypes,
                        travelStyles: _preferences.travelStyles,
                        accommodationPreferences: _preferences.accommodationPreferences,
                        budgetPreference: _preferences.budgetPreference,
                        cuisinePreferences: _preferences.cuisinePreferences,
                        activities: _preferences.activities,
                        tripDurationPreference: selection.first,
                        languages: _preferences.languages,
                        isPublic: _preferences.isPublic,
                      );
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMultiSelectSection(
              'Activities',
              _preferences.activities,
              TravelPreferences.activityTypes,
            ),
            SwitchListTile(
              title: const Text('Make Preferences Public'),
              subtitle: const Text('Allow other travelers to see your preferences'),
              value: _preferences.isPublic,
              onChanged: (bool value) {
                setState(() {
                  _preferences = TravelPreferences(
                    favoriteDestinationTypes: _preferences.favoriteDestinationTypes,
                    travelStyles: _preferences.travelStyles,
                    accommodationPreferences: _preferences.accommodationPreferences,
                    budgetPreference: _preferences.budgetPreference,
                    cuisinePreferences: _preferences.cuisinePreferences,
                    activities: _preferences.activities,
                    tripDurationPreference: _preferences.tripDurationPreference,
                    languages: _preferences.languages,
                    isPublic: value,
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
} 