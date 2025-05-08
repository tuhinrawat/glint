import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/home/home_page.dart';
import 'features/itinerary/itinerary_page.dart';
import 'features/itinerary/my_trips_page.dart';
import 'features/booking/booking_page.dart';
import 'features/profile/profile_page.dart';
import 'features/explore/explore_page.dart';
import 'services/itinerary_service.dart';
import 'features/social/feed_page.dart';
import 'features/experience/add_experience_page.dart';
import 'core/theme/app_theme.dart';
import 'dart:io' show Platform;

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  late final ItineraryService _itineraryService;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _itineraryService = ItineraryService();
    _pages = [
      const FeedPage(),
      ExplorePage(itineraryService: _itineraryService),
      MyTripsPage(service: _itineraryService),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        type: MaterialType.transparency,
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add experience feature coming soon!')),
          );
        },
        child: const Icon(Icons.add_photo_alternate),
      ) : null,
      extendBody: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: AppTheme.surfaceColor,
          elevation: 0,
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Feed',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'My Trips',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      theme: AppTheme.darkTheme,
      home: const MainNavigationPage(),
      routes: {
        '/home': (context) => const MainNavigationPage(),
        '/itinerary': (context) => const MainNavigationPage(),
        '/profile': (context) => const MainNavigationPage(),
        '/booking': (context) => const BookingPage(),
      },
    );
  }
}
