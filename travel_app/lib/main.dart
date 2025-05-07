import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/home/home_page.dart';
import 'features/itinerary/itinerary_page.dart';
import 'features/booking/booking_page.dart';
import 'features/profile/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    ItineraryPage(),
    const ProfilePage(),
  ];

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
      bottomNavigationBar: NavigationBar(
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
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'My trips',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
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
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF181A20),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF7F5AF0), // blue-violet accent
          secondary: const Color(0xFF2CB67D), // teal accent
          background: const Color(0xFF181A20),
          surface: const Color(0xFF23243B),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        cardColor: const Color(0xFF23243B),
        dialogBackgroundColor: const Color(0xFF23243B),
        textTheme: GoogleFonts.montserratTextTheme(
          ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
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
