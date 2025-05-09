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
import 'features/gang_hangout/gang_hangout_page.dart';
import 'core/navigation/bottom_nav_bar.dart';
import 'models/itinerary.dart';
import 'core/widgets/global_app_bar.dart';

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
  Itinerary? _activeTrip;

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
    _checkForActiveTrip();
  }

  void _checkForActiveTrip() {
    // Create a sample active trip
    final sampleTrip = Itinerary(
      id: 'sample-active-trip',
      destination: 'Bali',
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 5)),
      totalCost: 150000.0,
      numberOfPeople: 4,
      travelType: 'leisure',
      images: ['https://images.unsplash.com/photo-1537996194471-e657df975ab4'],
      suggestedFlightCost: 60000.0,
      suggestedHotelCostPerNight: 15000.0,
      suggestedCabCostPerDay: 5000.0,
      rating: 4.9,
      creatorName: 'Travel Assistant',
      tags: ['beach', 'culture', 'relaxation'],
      status: TripStatus.confirmed,
      dayPlans: [
        DayPlan(
          day: 1,
          date: DateTime.now(),
          activities: [
            Activity(
              name: 'Beach Day',
              description: 'Relaxing day at the beach',
              cost: 0.0,
              location: 'Nusa Dua Beach',
              startTime: const TimeOfDay(hour: 9, minute: 0),
              endTime: const TimeOfDay(hour: 17, minute: 0),
              tags: ['beach', 'relaxation'],
            ),
          ],
          totalCost: 0.0,
        ),
      ],
    );

    setState(() {
      _activeTrip = sampleTrip;
    });
  }

  void _openGangHangout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GangHangoutPage(activeTrip: _activeTrip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      appBar: GlobalAppBar(
        activeTrip: _activeTrip,
        onLogout: () {
          // TODO: Implement actual logout through AuthService
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logging out...'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itineraryService: _itineraryService,
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
