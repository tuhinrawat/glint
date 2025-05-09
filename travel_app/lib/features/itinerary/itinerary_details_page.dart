import 'package:flutter/material.dart';
import '../../models/itinerary.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_styles.dart';
import '../../core/services/currency_service.dart';
import 'edit_activity_dialog.dart';
import 'dart:math';

class ItineraryDetailsPage extends StatefulWidget {
  final Itinerary itinerary;
  final bool isEditing;
  final bool onlyUnpaidActivities;
  final String? heroTag;

  const ItineraryDetailsPage({
    Key? key,
    required this.itinerary,
    this.isEditing = false,
    this.onlyUnpaidActivities = false,
    this.heroTag,
  }) : super(key: key);

  @override
  State<ItineraryDetailsPage> createState() => _ItineraryDetailsPageState();
}

class _ItineraryDetailsPageState extends State<ItineraryDetailsPage> {
  late List<Activity> _activities;
  late Map<String, bool> _editableActivities;
  bool _isAddingNewActivity = false;
  final List<String> _selectedMembers = ['You'];
  final List<String> _selectedGangs = [];

  @override
  void initState() {
    super.initState();
    _initializeActivities();
  }

  void _initializeActivities() {
    _activities = [];
    _editableActivities = {};
    
    // Initialize activities from day plans
    for (var dayPlan in widget.itinerary.dayPlans) {
      for (var activity in dayPlan.activities) {
        _activities.add(activity);
        // For now, all activities are editable unless they have payments
        _editableActivities[activity.name] = true;
      }
    }
  }

  void _editActivity(Activity activity) async {
    final result = await showDialog<Activity>(
      context: context,
      builder: (context) => EditActivityDialog(
        activity: activity,
        availableSeats: _checkAvailableCapacity(),
        existingBookings: widget.itinerary.toJson(),
      ),
    );

    if (result != null) {
      setState(() {
        final index = _activities.indexWhere((a) => a.name == activity.name);
        if (index != -1) {
          _activities[index] = result;
        }
      });
    }
  }

  void _deleteActivity(Activity activity) {
    setState(() {
      _activities.removeWhere((a) => a.name == activity.name);
    });
  }

  int _checkAvailableCapacity() {
    int minAvailable = 999;
    
    // Check each day plan for capacity
    for (var dayPlan in widget.itinerary.dayPlans) {
      if (dayPlan.flight != null) {
        // Assuming each flight has a capacity of 200 by default
        minAvailable = min(minAvailable, 200);
      }
      if (dayPlan.hotel != null) {
        // Assuming each hotel room can accommodate 4 people
        minAvailable = min(minAvailable, 4 * dayPlan.hotel!.name.length);
      }
      if (dayPlan.cab != null) {
        // Assuming each cab can take 4 people
        minAvailable = min(minAvailable, 4);
      }
    }
    
    return minAvailable;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          widget.itinerary.destination,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onSurface,
          size: 24,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              size: 20,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.bookmark_outline,
              size: 20,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Save feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
          children: [
          // Hero image and header
          Stack(
                children: [
                  Hero(
                tag: widget.heroTag ?? 'itinerary_${widget.itinerary.id}',
                    child: Image.network(
                      widget.itinerary.images.first,
                  height: 300,
                  width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                      height: 300,
                      color: theme.colorScheme.surfaceVariant,
                      child: Icon(
                                  Icons.image_not_supported_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.itinerary.destination,
                      style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildHeaderChip(
                              context,
                              Icons.calendar_today,
                          '${widget.itinerary.dayPlans.length} days',
                            ),
                            const SizedBox(width: 12),
                            _buildHeaderChip(
                              context,
                              Icons.person_outline,
                              '${widget.itinerary.numberOfPeople} people',
                            ),
                            const SizedBox(width: 12),
                            _buildHeaderChip(
                              context,
                              Icons.star,
                              widget.itinerary.rating.toStringAsFixed(1),
                              iconColor: Colors.amber,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          // Trip details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context, 
                          'Total Cost', 
                        CurrencyService.formatAmount(widget.itinerary.totalCost),
                          Icons.currency_rupee,
                        ),
                        Divider(
                          height: 24,
                          thickness: 1,
                        color: theme.colorScheme.outline.withOpacity(0.08),
                        ),
                        _buildInfoRow(
                          context, 
                          'Start Date', 
                          '${widget.itinerary.startDate.day}/${widget.itinerary.startDate.month}/${widget.itinerary.startDate.year}',
                          Icons.calendar_today,
                        ),
                        Divider(
                          height: 24,
                          thickness: 1,
                        color: theme.colorScheme.outline.withOpacity(0.08),
                        ),
                        _buildInfoRow(
                          context, 
                          'End Date', 
                          '${widget.itinerary.endDate.day}/${widget.itinerary.endDate.month}/${widget.itinerary.endDate.year}',
                          Icons.event,
                        ),
                        Divider(
                          height: 24,
                          thickness: 1,
                        color: theme.colorScheme.outline.withOpacity(0.08),
                        ),
                        _buildInfoRow(
                          context, 
                          'Created By', 
                          widget.itinerary.creatorName,
                          Icons.person,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Day Plans
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Itinerary',
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(widget.itinerary.dayPlans.length, (index) {
                    final dayPlan = widget.itinerary.dayPlans[index];
                    return _buildDayPlanCard(context, dayPlan, index + 1);
                  }),
                ],
                              ),
                            ),
                          ],
      ),
    );
  }

  Widget _buildHeaderChip(BuildContext context, IconData icon, String label, {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: iconColor ?? Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Row(
        children: [
          Icon(
            icon,
            size: 20,
          color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
          label,
          style: theme.textTheme.bodyLarge,
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
    );
  }

  Widget _buildDayPlanCard(BuildContext context, DayPlan dayPlan, int dayNumber) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Text(
              'Day $dayNumber',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
            if (dayPlan.flight != null) ...[
              _buildTransportationRow(
                context,
              Icons.flight,
                '${dayPlan.flight!.airline} - ${dayPlan.flight!.from} to ${dayPlan.flight!.to}',
                dayPlan.flight!.cost,
              ),
            const SizedBox(height: 8),
            ],
            if (dayPlan.hotel != null) ...[
              _buildTransportationRow(
                context,
                Icons.hotel,
                dayPlan.hotel!.name,
                dayPlan.hotel!.costPerNight,
                          ),
                          const SizedBox(height: 8),
            ],
            if (dayPlan.cab != null) ...[
              _buildTransportationRow(
                context,
            Icons.local_taxi,
                '${dayPlan.cab!.type} - ${dayPlan.cab!.duration ?? "${dayPlan.cab!.from} to ${dayPlan.cab!.to}"}',
                dayPlan.cab!.cost,
            ),
            const SizedBox(height: 8),
            ],
            const Divider(),
            const SizedBox(height: 8),
                Text(
              'Activities:',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
            ...dayPlan.activities.map((activity) => _buildActivityRow(
                      context,
              activity,
              dayPlan.totalCost,
                    )),
                  ],
        ),
      ),
    );
  }

  Widget _buildTransportationRow(BuildContext context, IconData icon, String details, double cost) {
    final theme = Theme.of(context);
    return Row(
            children: [
              Icon(
          icon,
          size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
          child: Text(
            details,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Text(
          CurrencyService.formatAmount(cost),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityRow(BuildContext context, Activity activity, double cost) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
                    children: [
                      Icon(
            Icons.circle,
            size: 8,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  Text(
                  activity.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                  activity.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
            ),
          ),
                Text(
            CurrencyService.formatAmount(activity.cost),
            style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
                    ),
                  ),
                ],
      ),
    );
  }
} 