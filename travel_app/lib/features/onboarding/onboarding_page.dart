import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../auth/auth_page.dart';
import '../../main.dart';
import '../../core/widgets/brand_logo.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  double _pageOffset = 0.0;
  late AnimationController _animController;

  // Travel images for each onboarding page
  final List<String> _backgroundImages = [
    'assets/images/onboarding/travel_1.jpg', // Scenic landscape view
    'assets/images/onboarding/travel_2.jpg', // Planning/map image
    'assets/images/onboarding/travel_3.jpg', // Social/group travel image
    'assets/images/onboarding/travel_4.jpg', // Rewards/achievements image
    'assets/images/onboarding/travel_5.jpg', // Login page background
  ];

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      title: "Intelligent Discovery",
      subtitle: "Unleash your wanderlust with AI-powered recommendations tailored to your passions. From serene Kerala backwaters to vibrant Rajasthan festivals, find unique experiences that match your budget and style in seconds.",
      icon: Icons.explore,
      color: const Color(0xFF6C63FF),
    ),
    OnboardingItem(
      title: "Predictive Planning",
      subtitle: "Say goodbye to hidden fees and booking hassles. Our AI assistant crafts seamless itineraries, verifies real-time deals, and supports you 24/7 in your language—whether it's Hindi, Tamil, or English. Plan your dream trip with transparency and ease.",
      icon: Icons.map,
      color: const Color(0xFF3B82F6),
    ),
    OnboardingItem(
      title: "Enhanced Social Travel",
      subtitle: "Make every journey unforgettable with family, friends, or new travel buddies. Our app simplifies group bookings and curates shared experiences, like temple tours or street food adventures, designed for India's vibrant travel culture.",
      icon: Icons.people,
      color: const Color(0xFF2CB67D),
    ),
    OnboardingItem(
      title: "Smart Rewards Journey",
      subtitle: "Earn points, unlock achievements, and become a Travel Master. From booking eco-friendly stays to exploring hidden gems, every trip brings rewards. Join our loyalty program and elevate your adventures across India and beyond.",
      icon: Icons.emoji_events,
      color: const Color(0xFFF59E0B),
    ),
    OnboardingItem(
      title: "Join the Glint Community",
      subtitle: "Start your journey with Glint today",
      icon: Icons.flight_takeoff,
      color: const Color(0xFF6C63FF),
      isLogin: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageScroll);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
  }

  void _onPageScroll() {
    if (_pageController.hasClients) {
      setState(() {
        _pageOffset = _pageController.page ?? 0;
      });
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Parallax background images
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Stack(
                children: List.generate(_backgroundImages.length, (index) {
                  // Calculate offset based on current page and animation
                  final visibilityFactor = 1.0 - (((_pageOffset - index).abs()) * 0.8).clamp(0.0, 1.0);
                  final parallaxOffset = (_pageOffset - index) * 0.2;
                  
                  return Opacity(
                    opacity: visibilityFactor,
                    child: Container(
                      width: size.width,
                      height: size.height,
                      child: Stack(
                        children: [
                          // Background image with parallax effect
                          Positioned(
                            left: -parallaxOffset * size.width * 0.25 + 
                                  math.sin(_animController.value * math.pi * 2) * 10,
                            right: parallaxOffset * size.width * 0.25,
                            top: -parallaxOffset * size.height * 0.1 + 
                                 math.cos(_animController.value * math.pi * 2) * 10,
                            bottom: 0,
                            child: Image.asset(
                              _backgroundImages[index],
                              fit: BoxFit.cover,
                              width: size.width * 1.2,
                              height: size.height * 1.2,
                            ),
                          ),
                          // Gradient overlay for better readability
                          Container(
                            width: size.width,
                            height: size.height,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                          // Subtle animated particles/floating elements
                          CustomPaint(
                            painter: TravelParticlesPainter(
                              _animController.value,
                              visibilityFactor,
                            ),
                            size: size,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }
          ),
          
          // Page content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _currentPage == index ? 1.0 : 0.5,
                child: _buildPage(context, page),
              );
            },
          ),
          
          // Page indicator
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _currentPage == index 
                        ? _pages[_currentPage].color 
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPage(BuildContext context, OnboardingItem page) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with background
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: page.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                page.icon,
                size: 50,
                color: page.color,
              ),
            ),
            const SizedBox(height: 40),
            
            // Title - If this is the last page, use the brand logo
            page.isLogin
                ? const BrandLogo(fontSize: 32)
                : Text(
                    page.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
            const SizedBox(height: 16),
            
            // Subtitle
            Text(
              page.isLogin ? "Start your journey today" : page.subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (page.isLogin) ...[
              const SizedBox(height: 40),
              _buildLoginButtons(context),
            ],
            
            const Spacer(),
            
            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                _currentPage > 0 
                    ? TextButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Back'),
                      )
                    : const SizedBox(width: 80),
                
                // Next button / Skip button
                _currentPage < _pages.length - 1
                    ? TextButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Next'),
                      )
                    : TextButton(
                        onPressed: () {
                          // Skip to main app without login
                          _navigateToMainApp(context);
                        },
                        child: const Text('Skip'),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoginButtons(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    return Column(
      children: [
        // Demo login button (made more prominent)
        ElevatedButton.icon(
          onPressed: () async {
            await authService.demoLogin();
            _navigateToMainApp(context);
          },
          icon: const Icon(Icons.travel_explore, size: 24),
          label: const Text('Continue in Demo Mode'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        const Text(
          'Firebase authentication is not properly configured.',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        // Google login button (with note that it may not work)
        ElevatedButton.icon(
          onPressed: () async {
            _showLoadingDialog(context);
            try {
              // Try Firebase Google login
              final success = await authService.loginWithGoogle();
              if (success && mounted) {
                Navigator.pop(context); // Dismiss loading dialog
                _navigateToMainApp(context);
              } else if (mounted) {
                // If Firebase fails, use demo login as fallback
                Navigator.pop(context); // Dismiss loading dialog
                await authService.demoLogin();
                _navigateToMainApp(context);
                
                // Show a warning to the user
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Firebase login not configured. Using demo mode.')),
                  );
                }
              }
            } catch (e) {
              if (mounted) {
                Navigator.pop(context); // Dismiss loading dialog
                
                // Fall back to demo login
                await authService.demoLogin();
                _navigateToMainApp(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error with Firebase. Using demo mode.')),
                );
              }
            }
          },
          icon: const Icon(Icons.g_mobiledata, size: 24),
          label: const Text('Continue with Google (May Not Work)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Phone login button
        ElevatedButton.icon(
          onPressed: () {
            // Instead of taking to auth page, just show a message that it's not working
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Phone authentication is not configured. Use Demo Mode.')),
            );
          },
          icon: const Icon(Icons.phone, size: 24),
          label: const Text('Continue with Phone (Not Working)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.withOpacity(0.7),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Terms of service text
        Text(
          'By continuing, you agree to our Terms of Service\nand Privacy Policy',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  void _navigateToMainApp(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationPage()),
    );
  }
}

class TravelParticlesPainter extends CustomPainter {
  final double animation;
  final double opacity;
  final int particleCount = 30;
  
  TravelParticlesPainter(this.animation, this.opacity);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = math.Random(42);
    
    // Draw subtle traveling particles (like dust motes or light flares)
    for (int i = 0; i < particleCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      
      // Particle depth and movement
      final depth = 0.2 + random.nextDouble() * 0.8;
      
      // Movement pattern
      final xMovement = math.sin(animation * math.pi + i) * 15.0;
      final yMovement = math.cos(animation * math.pi * 0.5 + i * 0.5) * 10.0;
      
      // Position with movement
      final posX = (x + xMovement) % size.width;
      final posY = (y + yMovement) % size.height;
      
      // Size and opacity based on depth
      final particleSize = (1.0 + depth * 2.0) * (0.7 + math.sin(animation * 3 + i) * 0.3);
      final particleOpacity = (0.3 + depth * 0.5) * opacity;
      
      // Particles are subtle white/gold light flares
      paint.color = HSVColor.fromAHSV(
        particleOpacity, 
        40, // Gold/amber hue
        0.2, // Low saturation
        1.0, // High brightness
      ).toColor();
      
      // Add a subtle glow to larger particles
      if (depth > 0.7) {
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      } else {
        paint.maskFilter = null;
      }
      
      canvas.drawCircle(Offset(posX, posY), particleSize, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant TravelParticlesPainter oldDelegate) {
    return animation != oldDelegate.animation || opacity != oldDelegate.opacity;
  }
}

class OnboardingItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isLogin;
  
  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isLogin = false,
  });
} 