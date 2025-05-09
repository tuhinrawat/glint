import 'package:flutter/material.dart';
import '../../models/itinerary.dart';
import '../../services/itinerary_service.dart';
import '../itinerary/itinerary_details_page.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_styles.dart';
import '../../core/widgets/app_components.dart';
import '../../core/widgets/bottom_nav_spacer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../core/theme/app_icons.dart';
import '../../core/services/currency_service.dart';

class ExplorePage extends StatefulWidget {
  final ItineraryService itineraryService;

  const ExplorePage({
    super.key,
    required this.itineraryService,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final ItineraryService _itineraryService;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  List<Itinerary> _suggestedItineraries = [];
  String? _selectedDestination;
  
  final List<String> _suggestedPrompts = [
    "Show me popular beach destinations",
    "What are the best places for a weekend trip?",
    "Find me budget-friendly destinations",
    "Recommend family-friendly vacation spots",
    "What are trending adventure destinations?"
  ];
  
  final List<Map<String, dynamic>> _popularDestinations = [
    {
      'name': 'Goa',
      'subtitle': 'Beaches & Nightlife',
      'image': 'https://images.unsplash.com/photo-1582972236019-ea4af5ffe587'
    },
    {
      'name': 'Manali',
      'subtitle': 'Mountains & Adventure',
      'image': 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23'
    },
    {
      'name': 'Kerala',
      'subtitle': 'Backwaters & Culture',
      'image': 'https://images.unsplash.com/photo-1593693397690-362cb9666fc2'
    },
    {
      'name': 'Ladakh',
      'subtitle': 'High Altitude & Serenity',
      'image': 'https://images.unsplash.com/photo-1589556264800-08294b7d5337'
    },
    {
      'name': 'Rajasthan',
      'subtitle': 'Desert & Heritage',
      'image': 'https://images.unsplash.com/photo-1599661046289-e31897846e41'
    },
    {
      'name': 'Andaman',
      'subtitle': 'Islands & Beaches',
      'image': 'https://images.unsplash.com/photo-1517299321609-52687d1bc55a'
    }
  ];

  @override
  void initState() {
    super.initState();
    _itineraryService = widget.itineraryService;
    _loadSuggestedItineraries();
  }

  Future<void> _loadSuggestedItineraries() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _suggestedItineraries = [
        Itinerary(
          id: '1',
          destination: 'Goa',
          startDate: DateTime.now().add(const Duration(days: 5)),
          endDate: DateTime.now().add(const Duration(days: 10)),
          totalCost: 35000.0,
          numberOfPeople: 2,
          travelType: 'leisure',
          images: ['https://images.unsplash.com/photo-1587922546307-776227941871'],
          suggestedFlightCost: 14000.0,
          suggestedHotelCostPerNight: 2800.0,
          suggestedCabCostPerDay: 1400.0,
          rating: 4.8,
          creatorName: 'Travel Assistant',
          tags: ['beach', 'nightlife', 'leisure'],
          status: TripStatus.planning,
          dayPlans: [
            DayPlan(
              day: 1,
              date: DateTime.now().add(const Duration(days: 5)),
              activities: [
                Activity(
                  name: 'Beach Day',
                  description: 'Relax at Calangute Beach',
                  cost: 1500.0,
                  location: 'Calangute Beach',
                  startTime: TimeOfDay(hour: 9, minute: 0),
                  endTime: TimeOfDay(hour: 17, minute: 0),
                  tags: ['beach', 'relaxation'],
                ),
              ],
              totalCost: 1500.0,
            ),
          ],
        ),
        Itinerary(
          id: '2',
          destination: 'Manali',
          startDate: DateTime.now().add(const Duration(days: 10)),
          endDate: DateTime.now().add(const Duration(days: 15)),
          totalCost: 40000.0,
          numberOfPeople: 2,
          travelType: 'adventure',
          images: ['https://images.unsplash.com/photo-1626621341517-bbf3d9990a23'],
          suggestedFlightCost: 16000.0,
          suggestedHotelCostPerNight: 3200.0,
          suggestedCabCostPerDay: 1600.0,
          rating: 4.9,
          creatorName: 'Travel Assistant',
          tags: ['mountains', 'adventure'],
          status: TripStatus.planning,
          dayPlans: [
            DayPlan(
              day: 1,
              date: DateTime.now().add(const Duration(days: 10)),
              activities: [
                Activity(
                  name: 'Hiking',
                  description: 'Hiking in Solang Valley',
                  cost: 2000.0,
                  location: 'Solang Valley',
                  startTime: TimeOfDay(hour: 8, minute: 0),
                  endTime: TimeOfDay(hour: 16, minute: 0),
                  tags: ['hiking', 'adventure'],
                ),
              ],
              totalCost: 2000.0,
            ),
          ],
        ),
      ];
      _isLoading = false;
    });
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search destinations...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Widget _buildItineraryCard(Itinerary itinerary) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItineraryDetailsPage(
                itinerary: itinerary,
                heroTag: 'itinerary_${itinerary.id}',
              ),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Itinerary Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'itinerary_${itinerary.id}',
                    child: Image.network(
                      itinerary.images.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Cost and Details Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Cost',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${itinerary.totalCost.toStringAsFixed(0)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItineraryDetailsPage(
                                itinerary: itinerary,
                                heroTag: 'itinerary_${itinerary.id}',
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        label: Text(
                          'View Details',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: _isLoading
        ? Center(
            child: SpinKitPulse(
              color: theme.colorScheme.primary,
              size: 50.0,
            ),
          )
        : CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: _buildSearchBar(),
                ),
              ),
              // Recommended Itineraries
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AI Recommended Itineraries',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Filter or sort itineraries
                        },
                        child: Text(
                          'Filter',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildItineraryCard(_suggestedItineraries[index]),
                  childCount: _suggestedItineraries.length,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: kBottomNavigationBarHeight + 16),
              ),
            ],
          ),
    );
  }
} 