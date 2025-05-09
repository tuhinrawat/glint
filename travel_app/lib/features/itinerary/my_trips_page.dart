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
import '../itinerary/itinerary_details_page.dart';

class MyTripsPage extends StatefulWidget {
  final ItineraryService service;

  const MyTripsPage({super.key, required this.service});

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Itinerary> _upcomingTrips = [];
  List<Itinerary> _pastTrips = [];
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
        Itinerary(
          id: '1',
          destination: 'Bali, Indonesia',
          startDate: DateTime(2024, 3, 15),
          endDate: DateTime(2024, 3, 22),
          status: TripStatus.confirmed,
          images: ['https://images.unsplash.com/photo-1537996194471-e657df975ab4'],
          totalCost: 120000.0,
          numberOfPeople: 3,
          creatorName: 'You',
          rating: 4.8,
          travelType: 'leisure',
          suggestedFlightCost: 48000.0,
          suggestedHotelCostPerNight: 9600.0,
          suggestedCabCostPerDay: 4800.0,
          tags: ['leisure', 'beach', 'luxury'],
          dayPlans: [
            DayPlan(
              day: 1,
              date: DateTime(2024, 3, 15),
              activities: [
                Activity(
                  name: 'Beach Visit',
                  description: 'Visit the beautiful Nusa Dua beach',
                  cost: 1000.0,
                  location: 'Nusa Dua',
                  startTime: const TimeOfDay(hour: 9, minute: 0),
                  endTime: const TimeOfDay(hour: 14, minute: 0),
                  tags: ['beach', 'relaxation'],
                ),
              ],
              totalCost: 1000.0,
            ),
          ],
        ),
        Itinerary(
          id: '2',
          destination: 'Swiss Alps',
          startDate: DateTime(2024, 4, 5),
          endDate: DateTime(2024, 4, 12),
          status: TripStatus.planning,
          images: ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4'],
          totalCost: 250000.0,
          numberOfPeople: 2,
          creatorName: 'You',
          rating: 4.9,
          travelType: 'adventure',
          suggestedFlightCost: 100000.0,
          suggestedHotelCostPerNight: 20000.0,
          suggestedCabCostPerDay: 10000.0,
          tags: ['adventure', 'skiing', 'nature'],
          dayPlans: [
            DayPlan(
              day: 1,
              date: DateTime(2024, 4, 5),
              activities: [
                Activity(
                  name: 'Skiing',
                  description: 'Skiing at the Swiss Alps',
                  cost: 5000.0,
                  location: 'Swiss Alps',
                  startTime: TimeOfDay(hour: 9, minute: 0),
                  endTime: TimeOfDay(hour: 16, minute: 0),
                  rating: 4.9,
                  tags: ['skiing', 'adventure'],
                ),
              ],
              totalCost: 5000.0,
            ),
          ],
        ),
      ];

      _pastTrips = [
        Itinerary(
          id: '3',
          destination: 'Santorini, Greece',
          startDate: DateTime(2024, 1, 10),
          endDate: DateTime(2024, 1, 17),
          status: TripStatus.completed,
          images: ['https://images.unsplash.com/photo-1613395877344-13d4a8e0d49e'],
          totalCost: 180000.0,
          numberOfPeople: 4,
          creatorName: 'You',
          rating: 4.8,
          travelType: 'leisure',
          suggestedFlightCost: 72000.0,
          suggestedHotelCostPerNight: 14400.0,
          suggestedCabCostPerDay: 7200.0,
          tags: ['leisure', 'beach', 'culture'],
          dayPlans: [
            DayPlan(
              day: 1,
              date: DateTime(2024, 1, 10),
              activities: [
                Activity(
                  name: 'Island Tour',
                  description: 'Tour around Santorini',
                  cost: 3000.0,
                  location: 'Santorini',
                  startTime: TimeOfDay(hour: 9, minute: 0),
                  endTime: TimeOfDay(hour: 17, minute: 0),
                  rating: 4.8,
                  tags: ['tour', 'sightseeing'],
                ),
              ],
              totalCost: 3000.0,
            ),
          ],
        ),
        Itinerary(
          id: '4',
          destination: 'Tokyo, Japan',
          startDate: DateTime(2023, 12, 5),
          endDate: DateTime(2023, 12, 12),
          status: TripStatus.completed,
          images: ['https://images.unsplash.com/photo-1503899036084-c55cdd92da26'],
          totalCost: 200000.0,
          numberOfPeople: 2,
          creatorName: 'You',
          rating: 4.9,
          travelType: 'cultural',
          suggestedFlightCost: 80000.0,
          suggestedHotelCostPerNight: 16000.0,
          suggestedCabCostPerDay: 8000.0,
          tags: ['cultural', 'city', 'food'],
          dayPlans: [
            DayPlan(
              day: 1,
              date: DateTime(2023, 12, 5),
              activities: [
                Activity(
                  name: 'City Tour',
                  description: 'Tour around Tokyo',
                  cost: 4000.0,
                  location: 'Tokyo',
                  startTime: TimeOfDay(hour: 9, minute: 0),
                  endTime: TimeOfDay(hour: 17, minute: 0),
                  rating: 4.9,
                  tags: ['tour', 'city'],
                ),
              ],
              totalCost: 4000.0,
            ),
          ],
        ),
      ];

      _isLoading = false;
    });
  }

  bool _isActivityEditable(Activity activity) {
    // If the activity has payments, check if it's paid
    if (activity.payments != null && activity.payments!.isNotEmpty) {
      return false; // If there are payments, activity is not editable
    }
    return true; // If no payments, activity is editable
  }

  bool _isTripEditable(Itinerary trip) {
    // Check if all activities are paid
    for (var dayPlan in trip.dayPlans) {
      for (var activity in dayPlan.activities) {
        if (activity.payments != null && activity.payments!.isNotEmpty) {
          return false; // If any activity has payments, trip is not editable
        }
      }
    }
    return true; // If no payments, trip is editable
  }

  void _handleTripAction(Itinerary trip, String action) {
    switch (action) {
      case 'edit':
        if (!_isTripEditable(trip)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot edit trip - all activities are already paid'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItineraryDetailsPage(
              itinerary: trip,
              heroTag: 'itinerary_${trip.id}',
            ),
          ),
        );
        break;
      case 'share':
        // Handle share action
        break;
      case 'cancel':
        if (!_isTripEditable(trip)) {
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

  void _showCancelConfirmation(Itinerary trip) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Trip',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to cancel your trip to ${trip.destination}?\n\n'
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
                _upcomingTrips.removeWhere((t) => t.id == trip.id);
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
      appBar: AppBar(
        title: const BrandLogo(),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              indicatorColor: theme.colorScheme.primary,
              indicatorWeight: 3,
              labelStyle: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: theme.textTheme.titleSmall,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              tabs: [
                Tab(
                  child: Text(
                    'Upcoming',
                    style: TextStyle(
                      color: _tabController.index == 0
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Past',
                    style: TextStyle(
                      color: _tabController.index == 1
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
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

  Widget _buildTripsList(List<Itinerary> trips, {required bool isUpcoming}) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight + 16.0;
    
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        final isEditable = _isTripEditable(trip);
        
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
                    trip.images.first,
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
                            trip.destination,
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(trip.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            trip.status.name.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${trip.startDate.day}/${trip.startDate.month}/${trip.startDate.year} - '
                      '${trip.endDate.day}/${trip.endDate.month}/${trip.endDate.year}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    if (trip.rating > 0) ...[
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
                            trip.rating.toString(),
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
                            onPressed: isEditable ? () => _handleTripAction(trip, 'edit') : null,
                            child: Text(
                              'Edit',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: isEditable ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.38),
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

  Color _getStatusColor(TripStatus status) {
    final theme = Theme.of(context);
    switch (status) {
      case TripStatus.confirmed:
        return theme.colorScheme.tertiary;
      case TripStatus.planning:
        return theme.colorScheme.secondary;
      case TripStatus.completed:
        return theme.colorScheme.primary;
      case TripStatus.cancelled:
        return theme.colorScheme.error;
    }
  }
} 