import 'package:flutter/material.dart';
import '../../models/travel_preferences.dart';
import '../../core/widgets/common_styles.dart';
import '../../core/services/currency_service.dart';

class PreferencesEditor extends StatefulWidget {
  final TravelPreferences initialPreferences;
  final Function(TravelPreferences) onSave;

  const PreferencesEditor({
    super.key,
    required this.initialPreferences,
    required this.onSave,
  });

  @override
  State<PreferencesEditor> createState() => _PreferencesEditorState();
}

class _PreferencesEditorState extends State<PreferencesEditor> {
  late TravelPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = widget.initialPreferences;
  }

  void _updatePreferences() {
    widget.onSave(_preferences);
    Navigator.pop(context, _preferences);
  }

  IconData _getSectionIcon(String title) {
    return switch (title) {
      'Favorite Destinations' => Icons.place,
      'Travel Styles' => Icons.style,
      'Activities' => Icons.local_activity,
      'Accommodation' => Icons.hotel,
      'Budget Preference' => Icons.attach_money,
      'Preferred Trip Duration' => Icons.timelapse,
      _ => Icons.favorite,
    };
  }

  Widget _buildMultiSelectSection(String title, List<String> selected, List<String> options) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getSectionIcon(title),
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((option) {
                final isSelected = selected.contains(option);
                return FilterChip(
                  label: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  showCheckmark: false,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetPreferenceSelector() {
    Map<BudgetPreference, Map<String, dynamic>> budgetOptions = {
      BudgetPreference.budget: {
        'label': 'BUDGET',
        'icon': Icons.money_off,
      },
      BudgetPreference.moderate: {
        'label': 'MODERATE',
        'icon': Icons.account_balance_wallet,
      },
      BudgetPreference.luxury: {
        'label': 'LUXURY',
        'icon': Icons.attach_money,
      },
      BudgetPreference.ultraLuxury: {
        'label': 'ULTRA',
        'icon': Icons.diamond,
      },
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Budget Preference',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<BudgetPreference>(
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                showSelectedIcon: false,
                segments: budgetOptions.entries.map((entry) {
                  return ButtonSegment<BudgetPreference>(
                    value: entry.key,
                    label: Text(
                      entry.value['label'],
                      style: CommonStyles.preferencesLabel(context),
                    ),
                    icon: Icon(entry.value['icon'], size: 16),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripDurationSelector() {
    Map<TripDurationPreference, Map<String, dynamic>> durationOptions = {
      TripDurationPreference.short: {
        'label': '1-3 DAYS',
        'icon': Icons.looks_one,
      },
      TripDurationPreference.medium: {
        'label': '4-7 DAYS',
        'icon': Icons.looks_two,
      },
      TripDurationPreference.long: {
        'label': '1-2 WEEKS',
        'icon': Icons.looks_3,
      },
      TripDurationPreference.extended: {
        'label': '2+ WEEKS',
        'icon': Icons.looks_4,
      },
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.timelapse,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Preferred Trip Duration',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<TripDurationPreference>(
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                showSelectedIcon: false,
                segments: durationOptions.entries.map((entry) {
                  return ButtonSegment<TripDurationPreference>(
                    value: entry.key,
                    label: Text(
                      entry.value['label'],
                      style: CommonStyles.preferencesLabel(context),
                    ),
                    icon: Icon(entry.value['icon'], size: 16),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.currency_exchange,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Preferred Currency',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<Currency>(
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                showSelectedIcon: false,
                segments: Currency.values.map((currency) {
                  return ButtonSegment<Currency>(
                    value: currency,
                    label: Text(
                      '${CurrencyService.currencySymbols[currency]} ${currency.toString().split('.').last}',
                      style: CommonStyles.preferencesLabel(context),
                    ),
                  );
                }).toList(),
                selected: {CurrencyService.currentCurrency},
                onSelectionChanged: (Set<Currency> selection) async {
                  await CurrencyService.setCurrency(selection.first);
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This will change the currency display across the app',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Preferences'),
        centerTitle: true,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('SAVE'),
            onPressed: _updatePreferences,
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.05),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrencySelector(),
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
              _buildBudgetPreferenceSelector(),
              _buildTripDurationSelector(),
              _buildMultiSelectSection(
                'Activities',
                _preferences.activities,
                TravelPreferences.activityTypes,
              ),
              _buildMultiSelectSection(
                'Cuisine Preferences',
                _preferences.cuisinePreferences,
                [
                  'Local Cuisine',
                  'Street Food',
                  'Fine Dining',
                  'Vegetarian',
                  'Vegan',
                  'Seafood',
                  'Organic',
                  'International',
                  'Fast Food',
                  'Food Markets',
                ],
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.privacy_tip,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Privacy Settings',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      SwitchListTile(
                        title: const Text(
                          'Make Preferences Public',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: const Text('Allow other travelers to see your preferences'),
                        value: _preferences.isPublic,
                        activeColor: Theme.of(context).colorScheme.primary,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
} 