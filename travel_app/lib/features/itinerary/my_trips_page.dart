import 'package:flutter/material.dart';
import '../../models/itinerary.dart';
import '../../services/itinerary_service.dart';
import '../planning/trip_planner_page.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_styles.dart';
import '../../core/widgets/app_components.dart';
import '../../core/widgets/bottom_nav_spacer.dart';
import '../../core/services/currency_service.dart';
import '../../core/widgets/brand_logo.dart';
import '../../core/widgets/global_app_bar.dart';

class MyTripsPage extends StatefulWidget {
  final ItineraryService service;

  const MyTripsPage({super.key, required this.service});

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _upcomingTrips = [];
  List<Map<String, dynamic>> _pastTrips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    // In a real app, this would fetch from a backend
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    setState(() {
      _upcomingTrips = [
        {
          'destination': 'Bali, Indonesia',
          'startDate': '15 Mar 2024',
          'endDate': '22 Mar 2024',
          'status': 'Confirmed',
          'image': 'https://images.unsplash.com/photo-1537996194471-e657df975ab4',
          'cost': 120000.0,
          'activities': ['Beach', 'Temple Visit', 'Surfing'],
          'companions': 3,
          'hasPayments': true,
          'payments': [
            {
              'description': 'Hotel Booking',
              'amount': 50000.0,
              'paidBy': 'Rahul',
              'date': '2024-02-15',
            },
            {
              'description': 'Flight Tickets',
              'amount': 40000.0,
              'paidBy': 'Priya',
              'date': '2024-02-16',
            },
          ],
        },
        {
          'destination': 'Swiss Alps',
          'startDate': '5 Apr 2024',
          'endDate': '12 Apr 2024',
          'status': 'Planning',
          'image': 'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a',
          'cost': 250000.0,
          'activities': ['Skiing', 'Hiking', 'Photography'],
          'companions': 2,
          'hasPayments': false,
          'payments': [],
        },
      ];

      _pastTrips = [
        {
          'destination': 'Santorini, Greece',
          'startDate': '10 Jan 2024',
          'endDate': '17 Jan 2024',
          'status': 'Completed',
          'image': 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff',
          'cost': 180000.0,
          'activities': ['Island Tour', 'Wine Tasting', 'Sunset Watch'],
          'rating': 4.8,
          'companions': 4,
        },
        {
          'destination': 'Tokyo, Japan',
          'startDate': '5 Dec 2023',
          'endDate': '12 Dec 2023',
          'status': 'Completed',
          'image': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf',
          'cost': 200000.0,
          'activities': ['City Tour', 'Temple Visit', 'Food Tour'],
          'rating': 4.9,
          'companions': 2,
        },
      ];

      _isLoading = false;
    });
  }

  void _handleTripAction(Map<String, dynamic> trip, String action) {
    switch (action) {
      case 'edit':
        // Handle edit action
        break;
      case 'share':
        // Handle share action
        break;
      case 'cancel':
        if (trip['hasPayments'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot cancel trip - payments have already been made'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        _showCancelConfirmation(trip);
        break;
    }
  }

  void _showCancelConfirmation(Map<String, dynamic> trip) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Trip',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to cancel your trip to ${trip['destination']}?\n\n'
          'This action cannot be undone.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No, Keep Trip',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // In a real app, call API to cancel trip
              Navigator.pop(context);
              setState(() {
                _upcomingTrips.removeWhere((t) => t['destination'] == trip['destination']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Trip cancelled successfully'),
                  backgroundColor: theme.colorScheme.tertiary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: const Text('Yes, Cancel Trip'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBody: true,
      appBar: GlobalAppBar(
        title: 'My Trips',
        showLogo: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
            padding: const EdgeInsets.only(top: 8),
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? Center(child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildTripsList(_upcomingTrips, isUpcoming: true),
                  _buildTripsList(_pastTrips, isUpcoming: false),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TripPlannerPage(),
            ),
          );
        },
        backgroundColor: theme.colorScheme.primary.withGreen(150),
        child: Icon(
          Icons.add,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildTripsList(List<Map<String, dynamic>> trips, {required bool isUpcoming}) {
    final theme = Theme.of(context);
    
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, kBottomNavigationBarHeight + 16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    trip['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: theme.colorScheme.surfaceVariant,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trip['destination'],
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(trip['status']),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            trip['status'],
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${trip['startDate']} - ${trip['endDate']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    if (trip['rating'] != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 20,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            trip['rating'].toString(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    if (isUpcoming)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => _handleTripAction(trip, 'edit'),
                            child: Text(
                              'Edit',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _handleTripAction(trip, 'share'),
                            child: Text(
                              'Share',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _handleTripAction(trip, 'cancel'),
                            child: Text(
                              'Cancel',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    final theme = Theme.of(context);
    switch (status.toLowerCase()) {
      case 'confirmed':
        return theme.colorScheme.tertiary;
      case 'planning':
        return theme.colorScheme.secondary;
      case 'completed':
        return theme.colorScheme.primary;
      case 'cancelled':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.secondary;
    }
  }
} 