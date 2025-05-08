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
import 'core/providers/theme_provider.dart';
import 'dart:io' show Platform;
import 'features/onboarding/onboarding_page.dart';
import 'services/auth_service.dart';
import 'core/widgets/brand_logo.dart';
import 'core/services/currency_service.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  late final ItineraryService _itineraryService;
  late final List<Widget> _pages;
  final _feedPageKey = GlobalKey<FeedPageState>();

  @override
  void initState() {
    super.initState();
    _itineraryService = ItineraryService();
    _pages = [
      FeedPage(key: _feedPageKey),
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
          _feedPageKey.currentState?.showAddExperienceSheet();
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add_photo_alternate, color: Colors.white),
      ) : null,
      extendBody: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: bottomPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          selectedIndex: _currentIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 24),
              selectedIcon: Icon(Icons.home, size: 24),
              label: 'Feed',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined, size: 24),
              selectedIcon: Icon(Icons.explore, size: 24),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined, size: 24),
              selectedIcon: Icon(Icons.map, size: 24),
              label: 'My Trips',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, size: 24),
              selectedIcon: Icon(Icons.person, size: 24),
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
    await CurrencyService.initialize();
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

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Glint Travel',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: Consumer<AuthService>(
            builder: (context, authService, _) {
              return authService.isLoggedIn
                ? const MainNavigationPage()
                : const OnboardingPage();
            },
          ),
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
  
  // Initialize services
  await CurrencyService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const AppRoot(),
    ),
  );
}
