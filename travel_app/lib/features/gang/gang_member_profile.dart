import 'package:flutter/material.dart';
import '../../models/travel_preferences.dart';
import '../profile/preferences_viewer.dart';

class GangMemberProfile extends StatelessWidget {
  final String name;
  final String avatar;
  final String location;
  final String bio;
  final TravelPreferences preferences;
  final Map<String, int> stats;

  const GangMemberProfile({
    super.key,
    required this.name,
    required this.avatar,
    required this.location,
    required this.bio,
    required this.preferences,
    required this.stats,
  });

  Widget _buildStat(BuildContext context, String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(avatar),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Text(location),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Stats
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(context, 'Trips', stats['trips'] ?? 0),
                  _buildStat(context, 'Countries', stats['countries'] ?? 0),
                  _buildStat(context, 'Reviews', stats['reviews'] ?? 0),
                ],
              ),
            ),

            const Divider(),

            // Travel Preferences
            if (preferences.isPublic) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Travel Preferences',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    TextButton.icon(
                      icon: const Icon(Icons.compare_arrows),
                      label: const Text('Compare'),
                      onPressed: () {
                        // TODO: Implement preference comparison
                      },
                    ),
                  ],
                ),
              ),
              PreferencesViewer(
                preferences: preferences,
                isEditable: false,
              ),
            ] else
              const Padding(
                padding: EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.lock),
                        SizedBox(width: 8),
                        Text('This member\'s preferences are private'),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
} 