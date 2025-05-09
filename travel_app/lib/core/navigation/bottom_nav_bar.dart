import 'package:flutter/material.dart';
import '../../features/explore/explore_page.dart';
import '../../features/itinerary/my_trips_page.dart';
import '../../features/gang_hangout/gang_hangout_page.dart';
import '../../services/itinerary_service.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final ItineraryService itineraryService;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.itineraryService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          height: 64,
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          backgroundColor: Colors.transparent,
          indicatorColor: theme.colorScheme.primaryContainer.withOpacity(0.24),
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.feed_outlined,
                color: currentIndex == 0
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.feed,
                color: theme.colorScheme.primary,
              ),
              label: 'Feed',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.explore_outlined,
                color: currentIndex == 1
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.explore,
                color: theme.colorScheme.primary,
              ),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.map_outlined,
                color: currentIndex == 2
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.map,
                color: theme.colorScheme.primary,
              ),
              label: 'My Trips',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                color: currentIndex == 3
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.person,
                color: theme.colorScheme.primary,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
} 