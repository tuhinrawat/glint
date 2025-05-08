import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
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
import 'features/onboarding/onboarding_page.dart';
import 'services/auth_service.dart';
import 'core/widgets/brand_logo.dart';

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
    // Get the bottom padding (for notches, home indicators, etc.)
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      body: Material(
        type: MaterialType.transparency,
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        heroTag: 'mainNavFAB',
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add experience feature coming soon!')),
          );
        },
        child: const Icon(Icons.add_photo_alternate),
      ) : null,
      extendBody: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: bottomPadding),
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
          // Fixed height for the navbar itself (excluding system padding)
          height: 60,
          backgroundColor: AppTheme.surfaceColor,
          elevation: 0,
          selectedIndex: _currentIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, size: AppTheme.iconSizeMedium),
              selectedIcon: Icon(Icons.home, size: AppTheme.iconSizeMedium),
              label: 'Feed',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined, size: AppTheme.iconSizeMedium),
              selectedIcon: Icon(Icons.explore, size: AppTheme.iconSizeMedium),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined, size: AppTheme.iconSizeMedium),
              selectedIcon: Icon(Icons.map, size: AppTheme.iconSizeMedium),
              label: 'My Trips',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, size: AppTheme.iconSizeMedium),
              selectedIcon: Icon(Icons.person, size: AppTheme.iconSizeMedium),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

/// App root widget that checks auth state and provides services
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final AuthService _authService = AuthService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _authService.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Consumer<AuthService>(
      builder: (context, authService, _) {
        final initialRoute = authService.isLoggedIn
            ? '/home'
            : '/onboarding';

        return MaterialApp(
          title: 'Glint Travel',
          theme: AppTheme.darkTheme,
          initialRoute: initialRoute,
          routes: {
            '/onboarding': (context) => const OnboardingPage(),
            '/home': (context) => const MainNavigationPage(),
            '/itinerary': (context) => const MainNavigationPage(),
            '/profile': (context) => const MainNavigationPage(),
            '/booking': (context) => const BookingPage(),
          },
        );
      },
    );
  }
}

void main() async {
  // Ensure widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const AppRoot(),
    ),
  );
}
