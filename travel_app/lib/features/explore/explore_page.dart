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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              itinerary.images.first,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itinerary.destination,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${CurrencyService.formatAmount(itinerary.totalCost)} • ${itinerary.numberOfPeople} people',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _isLoading
        ? Center(
            child: SpinKitPulse(
              color: Theme.of(context).colorScheme.primary,
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Popular Destinations',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _popularDestinations.length,
                    itemBuilder: (context, index) {
                      final destination = _popularDestinations[index];
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  destination['image'] as String,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                left: 8,
                                right: 8,
                                child: Text(
                                  destination['name'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Suggested Itineraries',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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