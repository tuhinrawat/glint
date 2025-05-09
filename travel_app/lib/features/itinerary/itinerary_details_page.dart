import 'package:flutter/material.dart';
import '../../models/itinerary.dart';

// Add these classes at the top level
class MemberCostAdjustment {
  bool includeHotel;
  bool includeCab;
  bool includeFlight;
  String? hotelPreference; // 'shared' or 'single'
  String? cabPreference; // 'shared' or 'own'
  num additionalCharges;
  String? notes;

  MemberCostAdjustment({
    this.includeHotel = true,
    this.includeCab = true,
    this.includeFlight = true,
    this.hotelPreference = 'shared',
    this.cabPreference = 'shared',
    this.additionalCharges = 0,
    this.notes,
  });

  num calculateAdjustedCost(num baseCost, num hotelCost, num cabCost, num flightCost, int totalMembers) {
    num adjustedCost = baseCost;

    // Adjust hotel cost
    if (!includeHotel) {
      adjustedCost -= hotelCost / totalMembers;
    } else if (hotelPreference == 'single') {
      adjustedCost += hotelCost; // Add full room cost instead of shared
    }

    // Adjust cab cost
    if (!includeCab) {
      adjustedCost -= cabCost / totalMembers;
    }

    // Adjust flight cost
    if (!includeFlight) {
      adjustedCost -= flightCost;
    }

    // Add any additional charges
    adjustedCost += additionalCharges;

    return adjustedCost;
  }
}

class PaymentStatus {
  final String memberId;
  final String gangId;
  final num amount;
  final String payTo;
  final bool isPaid;
  final DateTime? paidDate;

  PaymentStatus({
    required this.memberId,
    required this.gangId,
    required this.amount,
    required this.payTo,
    this.isPaid = false,
    this.paidDate,
  });
}

// Add CostItem class at the top level, before the ItineraryDetailsPage class
class CostItem {
  final String title;
  final num amount;
  final VoidCallback? onEdit;
  final String? subtitle;

  CostItem(this.title, this.amount, {this.onEdit, this.subtitle});
}

class ItineraryDetailsPage extends StatefulWidget {
  final Itinerary itinerary;
  final String heroTag;

  const ItineraryDetailsPage({
    super.key,
    required this.itinerary,
    required this.heroTag,
  });

  @override
  State<ItineraryDetailsPage> createState() => _ItineraryDetailsPageState();
}

class _ItineraryDetailsPageState extends State<ItineraryDetailsPage> {
  // Add class properties
  final List<String> _selectedMembers = ['You'];
  final List<String> _selectedGangs = [];
  final Map<String, MemberCostAdjustment> _memberAdjustments = {};
  
  final Map<String, List<String>> _gangMembers = const {
    'College Friends': ['Alice', 'Bob', 'Charlie', 'David', 'Eve'],
    'Hiking Group': ['Frank', 'Grace', 'Henry', 'Isabel'],
    'Family': ['Mom', 'Dad', 'Sister', 'Brother', 'Grandma', 'Grandpa'],
  };

  int get _totalMemberCount {
    // Count individual members
    int count = _selectedMembers.length;
    // Add gang members (assuming average gang size of 4)
    count += _selectedGangs.length * 4;
    return count;
  }

  // Add this method to generate payment records
  List<PaymentStatus> _generatePaymentRecords() {
    final List<PaymentStatus> payments = [];

    // Handle individual members
    for (final member in _selectedMembers) {
      if (member == 'You') continue; // Skip the host

      final amount = _calculateAdjustedCostForMember(
        member,
        _memberAdjustments[member] ?? MemberCostAdjustment(),
      );

      payments.add(PaymentStatus(
        memberId: member,
        gangId: 'individual',
        amount: amount,
        payTo: 'You', // Host
      ));
    }

    // Handle gang members
    for (final gang in _selectedGangs) {
      final gangMembers = _gangMembers[gang] ?? [];
      for (final member in gangMembers) {
        final amount = _calculatePerPersonCost(); // Use standard cost for gang members

        payments.add(PaymentStatus(
          memberId: member,
          gangId: gang,
          amount: amount,
          payTo: 'You', // Host
        ));
      }
    }

    return payments;
  }

  @override
  Widget build(BuildContext context) {
    final duration = widget.itinerary.endDate.difference(widget.itinerary.startDate).inDays + 1;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          widget.itinerary.destination,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
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
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Save feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            SizedBox(
              height: 240,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.heroTag,
                    child: Image.network(
                      widget.itinerary.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 48,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Image not available',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
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
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                              '$duration days',
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
            ),
            
            // Overview
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context, 
                          'Total Cost', 
                          '₹${widget.itinerary.totalCost.round()}',
                          Icons.currency_rupee,
                        ),
                        Divider(
                          height: 24,
                          thickness: 1,
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
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
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
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
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
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
            
            const SizedBox(height: 24),
            
            // Book Now Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Group Members Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.group_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Trip Members',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => _showAddMembersDialog(context),
                              child: Text(
                                'Add Members',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildMemberChip(
                                context,
                                'You',
                                isHost: true,
                              ),
                              const SizedBox(width: 8),
                              _buildMemberChip(
                                context,
                                'Add Gang',
                                isAddGang: true,
                                onTap: () => _showGangSelectionDialog(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Total Cost Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Total Cost',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '₹${widget.itinerary.totalCost.round()}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Per Person',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '₹${(widget.itinerary.totalCost / widget.itinerary.numberOfPeople).round()}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Book Now Button
                  ElevatedButton(
                    onPressed: () => _showFullItineraryBookingDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Book Full Itinerary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderChip(BuildContext context, IconData icon, String label, {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String value, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayPlanCard(BuildContext context, DayPlan dayPlan, int dayNumber) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Day $dayNumber',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${dayPlan.date.day}/${dayPlan.date.month}/${dayPlan.date.year}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '₹${dayPlan.totalCost.round()}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(dayPlan.activities.length, (index) {
              final activity = dayPlan.activities[index];
              return _buildActivityItem(context, activity, index);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, Activity activity, int index) {
    final theme = Theme.of(context);
    final bookingType = _getActivityBookingType(activity);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (index < activity.tags.length - 1)
                Container(
                  width: 2,
                  height: 32,
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (bookingType != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _showBookingDialog(context, activity, bookingType),
                        icon: Icon(
                          _getActivityBookingIcon(activity),
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                          padding: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      activity.location,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${activity.startTime.format(context)} - ${activity.endTime.format(context)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (activity.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: activity.tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${activity.cost.round()}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (activity.rating > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      activity.rating.toString(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  BookingType? _getActivityBookingType(Activity activity) {
    final name = activity.name.toLowerCase();
    final description = activity.description.toLowerCase();
    
    if (name.contains('flight') || name.contains('airport') || 
        description.contains('flight') || description.contains('airport')) {
      return BookingType.flight;
    }
    
    if (name.contains('hotel') || name.contains('resort') || name.contains('stay') ||
        description.contains('hotel') || description.contains('resort') || 
        description.contains('stay') || description.contains('accommodation')) {
      return BookingType.hotel;
    }
    
    if (name.contains('cab') || name.contains('taxi') || name.contains('transfer') ||
        description.contains('cab') || description.contains('taxi') || 
        description.contains('transfer')) {
      return BookingType.cab;
    }
    
    if (activity.tags.any((tag) => tag.toLowerCase().contains('activity')) ||
        name.contains('visit') || name.contains('tour') || 
        description.contains('visit') || description.contains('tour')) {
      return BookingType.activity;
    }
    
    return null;
  }

  IconData _getActivityBookingIcon(Activity activity) {
    switch (_getActivityBookingType(activity)) {
      case BookingType.flight:
        return Icons.flight;
      case BookingType.hotel:
        return Icons.hotel;
      case BookingType.cab:
        return Icons.local_taxi;
      case BookingType.activity:
        return Icons.event;
      default:
        return Icons.bookmark;
    }
  }

  void _showBookingDialog(BuildContext context, Activity activity, BookingType bookingType) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getActivityBookingIcon(activity),
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _getBookingTitle(bookingType),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            Expanded(
              child: _buildBookingContent(context, bookingType, activity),
            ),
          ],
        ),
      ),
    );
  }

  String _getBookingTitle(BookingType type) {
    switch (type) {
      case BookingType.flight:
        return 'Book Flight';
      case BookingType.hotel:
        return 'Book Hotel';
      case BookingType.cab:
        return 'Book Cab';
      case BookingType.activity:
        return 'Book Activity';
      default:
        return 'Book Now';
    }
  }

  Widget _buildBookingContent(BuildContext context, BookingType type, Activity activity) {
    final theme = Theme.of(context);
    
    switch (type) {
      case BookingType.flight:
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Suggested Flights',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Mock flight options
            ...List.generate(3, (index) => _buildFlightOption(context, index)),
          ],
        );
        
      case BookingType.hotel:
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Suggested Hotels',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Mock hotel options
            ...List.generate(3, (index) => _buildHotelOption(context, index)),
          ],
        );
        
      case BookingType.cab:
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Available Cab Services',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Mock cab options
            ...List.generate(3, (index) => _buildCabOption(context, index)),
          ],
        );
        
      case BookingType.activity:
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Activity Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Activity booking details
            _buildActivityBookingDetails(context, activity),
          ],
        );
        
      default:
        return const Center(
          child: Text('No booking options available'),
        );
    }
  }

  Widget _buildFlightOption(BuildContext context, int index) {
    final theme = Theme.of(context);
    final airlines = ['IndiGo', 'Air India', 'SpiceJet'];
    final times = ['09:00 AM', '02:30 PM', '07:45 PM'];
    final prices = [4999, 6299, 5499];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Icon(
              Icons.flight,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              airlines[index],
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Departure: ${times[index]}',
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              '₹${prices[index]}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Handle flight booking
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Flight booking initiated')),
            );
          },
          child: const Text('Book'),
        ),
      ),
    );
  }

  Widget _buildHotelOption(BuildContext context, int index) {
    final theme = Theme.of(context);
    final hotels = ['Taj Hotel', 'Marriott', 'Hyatt'];
    final ratings = [4.8, 4.6, 4.7];
    final prices = [12999, 9999, 11499];
    final hotelImages = [
      'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb',  // Luxury hotel room
      'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9',  // Hotel exterior
      'https://images.unsplash.com/photo-1566073771259-6a8506099945',  // Hotel lobby
    ];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                hotelImages[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 32,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Image not available',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                        hotels[index],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ratings[index].toString(),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${prices[index]} per night',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Handle hotel booking
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Hotel booking initiated')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCabOption(BuildContext context, int index) {
    final theme = Theme.of(context);
    final services = ['Uber', 'Ola', 'Local Taxi'];
    final ratings = [4.5, 4.3, 4.4];
    final prices = ['₹15/km', '₹14/km', '₹18/km'];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.local_taxi,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(
          services[index],
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  ratings[index].toString(),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            Text(
              prices[index],
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Handle cab booking
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cab booking initiated')),
            );
          },
          child: const Text('Book'),
        ),
      ),
    );
  }

  Widget _buildActivityBookingDetails(BuildContext context, Activity activity) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              activity.description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${activity.startTime.format(context)} - ${activity.endTime.format(context)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  activity.location,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '₹${activity.cost.round()}',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle activity booking
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Activity booking initiated')),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberChip(
    BuildContext context,
    String name, {
    bool isHost = false,
    bool isAddGang = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isAddGang 
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: isAddGang ? Border.all(
            color: theme.colorScheme.primary,
            width: 1,
          ) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isHost)
              Icon(
                Icons.star_rounded,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            if (isAddGang)
              Icon(
                Icons.group_add_rounded,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            if (isHost || isAddGang)
              const SizedBox(width: 4),
            Text(
              name,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isAddGang 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSecondaryContainer,
                fontWeight: isHost ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMembersDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.group_add,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Add Trip Members',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search friends...',
                        prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(5, (index) => _buildFriendItem(
                      context,
                      index,
                      onAdd: (name) {
                        setState(() {
                          if (!_selectedMembers.contains(name)) {
                            _selectedMembers.add(name);
                          }
                        });
                      },
                    )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Cost Per Person',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${_calculatePerPersonCost().round()}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendItem(BuildContext context, int index, {required Function(String) onAdd}) {
    final theme = Theme.of(context);
    final names = ['John Doe', 'Jane Smith', 'Mike Johnson', 'Sarah Wilson', 'Tom Brown'];
    final name = names[index];
    final isSelected = _selectedMembers.contains(name);
    final hasAdjustments = _memberAdjustments.containsKey(name);
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary,
        child: Text(
          name[0],
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
      ),
      title: Text(name),
      subtitle: hasAdjustments
          ? Text(
              'Custom cost adjustments applied',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 12,
              ),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showMemberCostAdjustmentDialog(context, name),
              tooltip: 'Adjust Costs',
            ),
          OutlinedButton(
            onPressed: isSelected ? null : () => onAdd(name),
            child: Text(isSelected ? 'Added' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _showGangSelectionDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      'Select Gang',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Create new gang feature coming soon')),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('New Gang'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...List.generate(3, (index) => _buildGangItem(
                      context,
                      index,
                      onSelect: (name) {
                        setState(() {
                          if (!_selectedGangs.contains(name)) {
                            _selectedGangs.add(name);
                          }
                        });
                      },
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'Cost Per Person',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${_calculatePerPersonCost().round()}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGangItem(BuildContext context, int index, {required Function(String) onSelect}) {
    final theme = Theme.of(context);
    final gangs = [
      {'name': 'College Friends', 'members': 5},
      {'name': 'Hiking Group', 'members': 4},
      {'name': 'Family', 'members': 6},
    ];
    final gang = gangs[index];
    final isSelected = _selectedGangs.contains(gang['name']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          gang['name'] as String,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${gang['members']} members',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: ElevatedButton(
          onPressed: isSelected ? null : () => onSelect(gang['name'] as String),
          child: Text(isSelected ? 'Selected' : 'Select'),
        ),
      ),
    );
  }

  num _calculatePerPersonCost() {
    final totalMembers = _totalMemberCount;
    if (totalMembers == 0) return 0;

    // Individual costs (not shared)
    final flightCost = 4999;
    final activityCost = _calculateActivitiesCost();
    final individualCosts = flightCost + activityCost;

    // Shared costs
    final hotelCost = 12999;
    final cabCost = 2500;
    final sharedCosts = (hotelCost + cabCost) / totalMembers;

    return individualCosts + sharedCosts;
  }

  num _calculateActivitiesCost() {
    return widget.itinerary.dayPlans.fold<num>(
      0,
      (sum, day) => sum + day.activities.fold<num>(
        0,
        (activitySum, activity) => activitySum + activity.cost,
      ),
    );
  }

  void _showFullItineraryBookingDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCostBreakdown(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCostBreakdown(BuildContext context) {
    final theme = Theme.of(context);
    final totalMembers = _totalMemberCount;
    
    // Calculate base costs
    final flightCost = 4999.0;
    final hotelCost = 12999.0;
    final cabCost = 2500.0;
    final activitiesCost = _calculateActivitiesCost();
    final subtotal = flightCost + hotelCost + cabCost + activitiesCost;
    
    // Calculate taxes
    final hotelTax = hotelCost * 0.12; // 12% hotel tax
    final serviceTax = subtotal * 0.05; // 5% service tax
    final cityTax = 200.0 * widget.itinerary.dayPlans.length; // ₹200 per night city tax
    final flightTax = 850.0; // Fixed flight taxes and fees
    final totalTaxes = hotelTax + serviceTax + cityTax + flightTax;
    
    // Calculate grand total
    final grandTotal = subtotal + totalTaxes;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Cost Breakdown',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Base Costs
          _buildCostSection(
            context,
            'Base Costs',
            [
              CostItem('Flight Tickets', flightCost, onEdit: () => _showCostAdjustmentDialog(context, 'flight')),
              CostItem('Hotel Stay', hotelCost, onEdit: () => _showCostAdjustmentDialog(context, 'hotel')),
              CostItem('Cab Services', cabCost, onEdit: () => _showCostAdjustmentDialog(context, 'cab')),
              CostItem('Activities', activitiesCost, onEdit: () => _showCostAdjustmentDialog(context, 'activities')),
            ],
          ),
          const SizedBox(height: 24),

          // Taxes & Fees
          _buildCostSection(
            context,
            'Taxes & Fees',
            [
              CostItem('Hotel Tax (12%)', hotelTax),
              CostItem('Service Tax (5%)', serviceTax),
              CostItem('City Tax (₹200/night)', cityTax),
              CostItem('Flight Taxes & Fees', flightTax),
            ],
          ),
          const SizedBox(height: 24),

          // Individual Adjustments
          _buildCostSection(
            context,
            'Individual Adjustments',
            _memberAdjustments.entries.map((entry) {
              final adjustment = entry.value;
              final adjustedCost = _calculateAdjustedCostForMember(entry.key, adjustment);
              return CostItem(
                entry.key,
                adjustedCost,
                onEdit: () => _showMemberCostAdjustmentDialog(context, entry.key),
                subtitle: _getAdjustmentSummary(adjustment),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Total Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                _buildTotalRow(
                  context,
                  'Subtotal',
                  subtotal,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTotalRow(
                  context,
                  'Total Taxes & Fees',
                  totalTaxes,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                _buildTotalRow(
                  context,
                  'Grand Total',
                  grandTotal,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTotalRow(
                  context,
                  'Per Person',
                  grandTotal / totalMembers,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showPaymentDetailsSheet(context);
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('Proceed to Payment'),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostSection(BuildContext context, String title, List<CostItem> items) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildCostRow(context, item)).toList(),
      ],
    );
  }

  Widget _buildCostRow(BuildContext context, CostItem item) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (item.subtitle != null)
                  Text(
                    item.subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '₹${item.amount.round()}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (item.onEdit != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(36, 36),
              ),
              onPressed: item.onEdit,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTotalRow(BuildContext context, String label, num amount, {TextStyle? style}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          '₹${amount.round()}',
          style: style,
        ),
      ],
    );
  }

  String _getAdjustmentSummary(MemberCostAdjustment adjustment) {
    final List<String> summary = [];
    
    if (!adjustment.includeHotel) {
      summary.add('No hotel');
    } else if (adjustment.hotelPreference == 'single') {
      summary.add('Single room');
    }
    
    if (!adjustment.includeCab) {
      summary.add('No cab');
    } else if (adjustment.cabPreference == 'own') {
      summary.add('Own transport');
    }
    
    if (!adjustment.includeFlight) {
      summary.add('No flight');
    }
    
    if (adjustment.additionalCharges > 0) {
      summary.add('+₹${adjustment.additionalCharges.round()} extra');
    }
    
    return summary.join(' • ');
  }

  void _showCostAdjustmentDialog(BuildContext context, String costType) {
    final theme = Theme.of(context);
    final totalMembers = _totalMemberCount;
    
    // State variables for the dialog
    String selectedOption = 'shared';
    num individualCost = costType == 'hotel' ? 12999 / totalMembers : 
                        costType == 'cab' ? 2500 / totalMembers : 
                        costType == 'flight' ? 4999 : 0;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: theme.colorScheme.surface,
          elevation: 8,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getCostTypeIcon(costType),
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Adjust ${costType.capitalize()} Cost',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  if (costType == 'hotel' || costType == 'cab') ...[
                    Text(
                      'Booking Type',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment<String>(
                          value: 'shared',
                          label: Text(costType == 'hotel' ? 'Shared Room' : 'Shared Ride'),
                          icon: Icon(costType == 'hotel' ? Icons.people : Icons.groups),
                        ),
                        ButtonSegment<String>(
                          value: 'individual',
                          label: Text(costType == 'hotel' ? 'Individual Room' : 'Private Ride'),
                          icon: Icon(costType == 'hotel' ? Icons.person : Icons.person_outline),
                        ),
                      ],
                      selected: {selectedOption},
                      onSelectionChanged: (Set<String> selection) {
                        setState(() {
                          selectedOption = selection.first;
                          if (selectedOption == 'shared') {
                            individualCost = costType == 'hotel' ? 12999 / totalMembers : 2500 / totalMembers;
                          } else {
                            individualCost = costType == 'hotel' ? 12999 : 2500;
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return theme.colorScheme.primary;
                            }
                            return theme.colorScheme.surfaceVariant;
                          },
                        ),
                        foregroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return theme.colorScheme.onPrimary;
                            }
                            return theme.colorScheme.onSurfaceVariant;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  Text(
                    selectedOption == 'individual' ? 'Individual Cost' : 'Cost per Person',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(text: individualCost.round().toString())..selection = TextSelection.fromPosition(
                      TextPosition(offset: individualCost.round().toString().length),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: '₹',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.1),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onTap: () {
                      // Clear the text when the field is tapped
                      final controller = TextEditingController();
                      setState(() {
                        individualCost = 0;
                      });
                      controller.clear();
                      // Replace the text field's controller
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        (context as Element).markNeedsBuild();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        individualCost = num.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  
                  if (selectedOption == 'individual' && (costType == 'hotel' || costType == 'cab')) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Assign to Members',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ..._selectedMembers.map((member) => CheckboxListTile(
                            value: _memberAdjustments[member]?.includeHotel ?? true,
                            onChanged: (bool? value) {
                              setState(() {
                                final adjustment = _memberAdjustments[member] ?? MemberCostAdjustment();
                                if (costType == 'hotel') {
                                  adjustment.includeHotel = value ?? true;
                                  adjustment.hotelPreference = value == true ? 'individual' : 'none';
                                } else {
                                  adjustment.includeCab = value ?? true;
                                  adjustment.cabPreference = value == true ? 'individual' : 'none';
                                }
                                _memberAdjustments[member] = adjustment;
                              });
                            },
                            title: Text(member),
                            subtitle: Text(
                              costType == 'hotel' 
                                  ? (_memberAdjustments[member]?.includeHotel ?? true 
                                      ? 'Individual room - ₹${individualCost.round()}'
                                      : 'No room assigned')
                                  : (_memberAdjustments[member]?.includeCab ?? true
                                      ? 'Private ride - ₹${individualCost.round()}'
                                      : 'No ride assigned'),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  if (selectedOption == 'individual') ...[
                    Text(
                      'Total Cost: ₹${(individualCost * (_selectedMembers.length)).round()}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: theme.colorScheme.primary),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Update member adjustments
                            if (selectedOption == 'individual') {
                              for (final member in _selectedMembers) {
                                final adjustment = _memberAdjustments[member] ?? MemberCostAdjustment();
                                if (costType == 'hotel') {
                                  adjustment.hotelPreference = 'individual';
                                  adjustment.additionalCharges = individualCost - (12999 / totalMembers);
                                } else if (costType == 'cab') {
                                  adjustment.cabPreference = 'individual';
                                  adjustment.additionalCharges = individualCost - (2500 / totalMembers);
                                }
                                _memberAdjustments[member] = adjustment;
                              }
                            }
                            Navigator.pop(context);
                            setState(() {}); // Refresh the UI
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCostTypeIcon(String costType) {
    switch (costType) {
      case 'hotel':
        return Icons.hotel;
      case 'cab':
        return Icons.local_taxi;
      case 'flight':
        return Icons.flight;
      case 'activities':
        return Icons.event;
      default:
        return Icons.attach_money;
    }
  }

  num _calculateAdjustedCostForMember(String memberId, MemberCostAdjustment adjustment) {
    final baseCost = _calculatePerPersonCost();
    final hotelCost = 12999.0;  // Example hotel cost
    final cabCost = 2500.0;     // Example cab cost
    final flightCost = 4999.0;  // Example flight cost
    
    return adjustment.calculateAdjustedCost(
      baseCost,
      hotelCost,
      cabCost,
      flightCost,
      _totalMemberCount,
    );
  }

  void _showMemberCostAdjustmentDialog(BuildContext context, String memberId) {
    final theme = Theme.of(context);
    final adjustment = _memberAdjustments[memberId] ?? MemberCostAdjustment();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Adjust Cost for $memberId',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Included Services',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: adjustment.includeHotel,
                onChanged: (value) {
                  setState(() {
                    adjustment.includeHotel = value ?? true;
                    _memberAdjustments[memberId] = adjustment;
                  });
                },
                title: const Text('Hotel'),
                subtitle: Text(
                  adjustment.hotelPreference ?? 'Shared Room',
                  style: theme.textTheme.bodySmall,
                ),
                secondary: Icon(
                  Icons.hotel,
                  color: theme.colorScheme.primary,
                ),
              ),
              CheckboxListTile(
                value: adjustment.includeCab,
                onChanged: (value) {
                  setState(() {
                    adjustment.includeCab = value ?? true;
                    _memberAdjustments[memberId] = adjustment;
                  });
                },
                title: const Text('Cab'),
                subtitle: Text(
                  adjustment.cabPreference ?? 'Shared Ride',
                  style: theme.textTheme.bodySmall,
                ),
                secondary: Icon(
                  Icons.local_taxi,
                  color: theme.colorScheme.primary,
                ),
              ),
              CheckboxListTile(
                value: adjustment.includeFlight,
                onChanged: (value) {
                  setState(() {
                    adjustment.includeFlight = value ?? true;
                    _memberAdjustments[memberId] = adjustment;
                  });
                },
                title: const Text('Flight'),
                secondary: Icon(
                  Icons.flight,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Additional Charges',
                  prefixText: '₹',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.1),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    adjustment.additionalCharges = num.tryParse(value) ?? 0;
                    _memberAdjustments[memberId] = adjustment;
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: theme.colorScheme.primary),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    final theme = Theme.of(context);
    final payments = _generatePaymentRecords();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: theme.colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Payment Details',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.colorScheme.onPrimary),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Summary',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...payments.map((payment) => _buildPaymentItem(context, payment)),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment initiated')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Proceed to Payment'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentItem(BuildContext context, PaymentStatus payment) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                payment.memberId,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: payment.isPaid
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : theme.colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  payment.isPaid ? 'Paid' : 'Pending',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: payment.isPaid
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Amount: ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '₹${payment.amount.round()}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (payment.gangId != 'individual') ...[
            const SizedBox(height: 4),
            Text(
              'Gang: ${payment.gangId}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (payment.paidDate != null) ...[
            const SizedBox(height: 4),
            Text(
              'Paid on: ${payment.paidDate!.day}/${payment.paidDate!.month}/${payment.paidDate!.year}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBookingSummaryItem(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDetailsSheet(BuildContext context) {
    final theme = Theme.of(context);
    final payments = _generatePaymentRecords();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: theme.colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Payment Details',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.colorScheme.onPrimary),
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Summary',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...payments.map((payment) => _buildPaymentItem(context, payment)),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment initiated')),
                        );
                      },
                      icon: const Icon(Icons.payment),
                      label: const Text('Proceed to Payment'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

enum BookingType {
  flight,
  hotel,
  cab,
  activity,
} 