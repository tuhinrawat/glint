import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../core/widgets/nav_bar.dart';
import '../../core/theme/color_schemes.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController(text: 'Goa');
  final _service = const BookingService();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;
  Booking? _booking;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _loadLatestBooking();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadLatestBooking() async {
    final booking = await _service.getLatestBooking();
    if (booking != null) {
      setState(() => _booking = booking);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _bookTrip() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _currentStep = 0;
    });

    try {
      final booking = await _service.bookTrip(
        _destinationController.text,
        _selectedDate,
      );

      // Simulate booking steps
      for (int i = 1; i <= 3; i++) {
        await Future.delayed(const Duration(seconds: 1));
        setState(() => _currentStep = i);
      }

      setState(() => _booking = booking);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking successful!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade300,
              Colors.purple.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Book Your Trip',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Destination Input
                  Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Destination',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _destinationController,
                            decoration: InputDecoration(
                              hintText: 'Enter destination',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a destination';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Date Selection
                  Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Travel Date',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedDate.toString().split(' ')[0],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Progress Bar
                  if (_isLoading) ...[
                    Card(
                      color: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStep('Flight', 1),
                                _buildStep('Hotel', 2),
                                _buildStep('Cab', 3),
                              ],
                            ),
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: _currentStep / 3,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Book Now Button
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              HapticFeedback.mediumImpact();
                              await _animationController.forward();
                              await _animationController.reverse();
                              await _bookTrip();
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Book Now',
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Booking Details
                  if (_booking != null) ...[
                    Card(
                      color: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Booking Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildBookingDetail('Flight', _booking!.flight),
                            _buildBookingDetail('Hotel', _booking!.hotel),
                            _buildBookingDetail('Cab', _booking!.cab),
                            const Divider(),
                            _buildBookingDetail(
                              'Total Cost',
                              '₹${_booking!.totalCost.toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 2, // Bookings tab is selected (now Profile is index 2)
        onTap: (index) {
          switch (index) {
            case 0: // Home
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1: // My trips
              Navigator.pushReplacementNamed(context, '/itinerary');
              break;
            case 2: // Profile
              // TODO: Implement profile page
              break;
          }
        },
      ),
    );
  }

  Widget _buildStep(String label, int step) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Icon(
          step == 1
              ? Icons.flight
              : step == 2
                  ? Icons.hotel
                  : Icons.directions_car,
          color: isActive
              ? Theme.of(context).colorScheme.iconActive
              : Theme.of(context).colorScheme.iconInactive,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive
                ? Theme.of(context).colorScheme.iconActive
                : Theme.of(context).colorScheme.iconInactive,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
} 