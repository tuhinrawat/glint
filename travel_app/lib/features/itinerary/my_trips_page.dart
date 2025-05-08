import 'package:flutter/material.dart';
import '../../models/itinerary.dart';
import '../../services/itinerary_service.dart';
import '../planning/trip_planner_page.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_styles.dart';
import '../../core/widgets/app_components.dart';
import '../../core/widgets/bottom_nav_spacer.dart';

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
          'cost': '120,000',
          'activities': ['Beach', 'Temple Visit', 'Surfing'],
          'companions': 3,
          'hasPayments': true, // Some payments have been made
          'payments': [
            {
              'description': 'Hotel Booking',
              'amount': '50,000',
              'paidBy': 'Rahul',
              'date': '2024-02-15',
            },
            {
              'description': 'Flight Tickets',
              'amount': '40,000',
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
          'cost': '250,000',
          'activities': ['Skiing', 'Hiking', 'Photography'],
          'companions': 2,
          'hasPayments': false, // No payments made yet
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
          'cost': '180,000',
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
          'cost': '200,000',
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Trip'),
        content: Text(
          'Are you sure you want to cancel your trip to ${trip['destination']}?\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep Trip'),
          ),
          ElevatedButton(
            onPressed: () {
              // In a real app, call API to cancel trip
              Navigator.pop(context);
              setState(() {
                _upcomingTrips.removeWhere((t) => t['destination'] == trip['destination']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Trip cancelled successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          'My Trips',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: AppTheme.fontSizeXLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondaryColor,
          indicatorColor: AppTheme.primaryColor,
        ),
      ),
      body: SafeArea(
        bottom: false, 
        child: _isLoading
            ? Center(child: AppComponents.loadingIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildTripsList(_upcomingTrips, isUpcoming: true),
                  _buildTripsList(_pastTrips, isUpcoming: false),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TripPlannerPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Plan New Trip'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildTripsList(List<Map<String, dynamic>> trips, {required bool isUpcoming}) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final trip = trips[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacingLarge),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium)
                  ),
                  color: AppTheme.surfaceColor,
                  elevation: 4,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          image: DecorationImage(
                            image: NetworkImage(trip['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(trip['status']),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  trip['status'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  trip['destination'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (!isUpcoming)
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 20),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${trip['rating']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 8),
                                Text('${trip['startDate']} - ${trip['endDate']}'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.people_outline, size: 16),
                                const SizedBox(width: 8),
                                Text('${trip['companions']} people'),
                                const Spacer(),
                                const Icon(Icons.currency_rupee, size: 16),
                                const SizedBox(width: 4),
                                Text(trip['cost']),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: (trip['activities'] as List<String>)
                                  .map((activity) => Chip(
                                        label: Text(activity),
                                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                      ))
                                  .toList(),
                            ),
                            if (isUpcoming) ...[
                              if (trip['hasPayments'] == true) ...[
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Recent Payments',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...List.generate(
                                        (trip['payments'] as List).take(2).length,
                                        (i) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.payment, size: 16),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  '${trip['payments'][i]['description']}',
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                              ),
                                              Text(
                                                '₹${trip['payments'][i]['amount']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                    icon: Icons.edit_outlined,
                                    label: 'Edit',
                                    onTap: () => _handleTripAction(trip, 'edit'),
                                  ),
                                  _buildActionButton(
                                    icon: Icons.share_outlined,
                                    label: 'Share',
                                    onTap: () => _handleTripAction(trip, 'share'),
                                  ),
                                  _buildActionButton(
                                    icon: Icons.delete_outline,
                                    label: 'Cancel',
                                    onTap: () => _handleTripAction(trip, 'cancel'),
                                    isDestructive: true,
                                    isDisabled: trip['hasPayments'] == true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: trips.length,
            ),
          ),
        ),
        
        BottomNavSpacer.sliverDynamic(context),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
    bool isDisabled = false,
  }) {
    final color = isDestructive ? Colors.red : Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isDisabled ? Colors.grey : color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isDisabled ? Colors.grey : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'planning':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
} 