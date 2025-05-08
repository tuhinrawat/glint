import 'package:flutter/material.dart';
import '../../models/itinerary.dart';
import '../../services/itinerary_service.dart';
import '../itinerary/itinerary_details_page.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_styles.dart';
import '../../core/widgets/app_components.dart';

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
  bool _isLoading = true;
  List<Map<String, dynamic>> _recommendedItineraries = [];
  String? _selectedDestination;
  
  final List<Map<String, dynamic>> _popularDestinations = [
    {
      'name': 'Goa',
      'subtitle': 'Beaches & Nightlife',
      'image': 'https://images.unsplash.com/photo-1587922546307-776227941871'
    },
    {
      'name': 'Manali',
      'subtitle': 'Mountains & Adventure',
      'image': 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23'
    },
    {
      'name': 'Kerala',
      'subtitle': 'Backwaters & Culture',
      'image': 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944'
    },
    {
      'name': 'Ladakh',
      'subtitle': 'High Altitude & Serenity',
      'image': 'https://images.unsplash.com/photo-1589556264800-08294b7d5337'
    },
    {
      'name': 'Rajasthan',
      'subtitle': 'Desert & Heritage',
      'image': 'https://images.unsplash.com/photo-1580391564590-aeca65c5e2d3'
    },
    {
      'name': 'Andaman',
      'subtitle': 'Islands & Beaches',
      'image': 'https://images.unsplash.com/photo-1501306476490-b818e9a663a3'
    },
  ];

  @override
  void initState() {
    super.initState();
    _itineraryService = widget.itineraryService;
    _loadItineraries();
  }

  Future<void> _loadItineraries() async {
    setState(() => _isLoading = true);
    
    try {
      final itineraries = await _itineraryService.getRecommendedItineraries();
      
      setState(() {
        _recommendedItineraries = itineraries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load itineraries: $e')),
        );
      }
    }
  }

  void _selectDestination(String destination) {
    setState(() {
      _selectedDestination = destination;
    });
    
    // In a real app, you would filter itineraries based on destination
    // For now, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected destination: $destination')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            // App Bar with search
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: AppTheme.backgroundColor,
              title: const Text(
                'Explore Itineraries',
                style: TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: AppTheme.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              bottom: PreferredSize(
                // Increase the height to prevent overflow
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  // Add extra bottom padding to prevent overflow
                  margin: const EdgeInsets.fromLTRB(
                    AppTheme.spacingLarge, 
                    0, 
                    AppTheme.spacingLarge, 
                    AppTheme.spacingMedium // Increased from spacingSmall
                  ),
                  // Set a fixed height for the search bar
                  height: 48,
                  child: AppComponents.searchBar(
                    controller: _searchController,
                    hintText: 'Search destinations, activities...',
                    margin: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            
            // Add a small spacer to fix any overflow
            const SliverToBoxAdapter(
              child: SizedBox(height: 4), // 4px spacer to fix the 2px overflow
            ),
            
            // Popular Destinations
            SliverToBoxAdapter(
              child: AppComponents.sectionTitle(
                title: 'Popular Destinations',
                onViewAll: () {
                  // View all destinations
                },
              ),
            ),
            
            // Horizontal Destinations List
            SliverToBoxAdapter(
              child: AppComponents.horizontalDestinationsList(
                destinations: _popularDestinations,
                onDestinationSelected: _selectDestination,
                selectedDestination: _selectedDestination,
              ),
            ),
            
            // Recommended Itineraries
            SliverToBoxAdapter(
              child: AppComponents.sectionTitle(
                title: 'Recommended Itineraries',
                onViewAll: () {
                  // Filter or sort itineraries
                },
                viewAllText: 'Filter',
              ),
            ),
            
            // Itineraries Grid or List
            _isLoading
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: AppComponents.loadingIndicator(),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLarge,
                      vertical: AppTheme.spacingMedium,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final data = _recommendedItineraries[index];
                          final itinerary = Itinerary.fromJson(data['itinerary']);
                          
                          final isLastItem = index == _recommendedItineraries.length - 1;
                          
                          return Column(
                            children: [
                              ItineraryCard(
                                itinerary: itinerary,
                                tips: data['personalized_tips'],
                                savings: data['estimated_savings'],
                              ),
                              // Add extra padding after the last item
                              if (isLastItem)
                                const SizedBox(height: 100),
                            ],
                          );
                        },
                        childCount: _recommendedItineraries.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class ItineraryCard extends StatelessWidget {
  final Itinerary itinerary;
  final List<dynamic> tips;
  final String savings;

  const ItineraryCard({
    super.key,
    required this.itinerary,
    required this.tips,
    required this.savings,
  });

  @override
  Widget build(BuildContext context) {
    final duration = itinerary.endDate.difference(itinerary.startDate).inDays + 1;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        boxShadow: AppTheme.defaultShadow,
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensure column takes minimum space needed
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Itinerary Image
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Stack(
              fit: StackFit.passthrough, // Use passthrough instead of expand
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: AppComponents.cachedImage(
                    imageUrl: itinerary.images.isNotEmpty
                      ? itinerary.images.first
                      : 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppTheme.borderRadiusMedium),
                      ),
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
                ),
                Positioned(
                  bottom: AppTheme.spacingMedium,
                  left: AppTheme.spacingMedium,
                  right: AppTheme.spacingMedium,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itinerary.destination,
                        style: CommonStyles.headingMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppComponents.iconLabel(
                            icon: Icons.calendar_today,
                            label: '$duration days',
                            iconColor: Colors.white,
                            textColor: Colors.white,
                          ),
                          const SizedBox(width: AppTheme.spacingMedium),
                          AppComponents.iconLabel(
                            icon: Icons.person,
                            label: '${itinerary.numberOfPeople} people',
                            iconColor: Colors.white,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: AppTheme.spacingMedium,
                  right: AppTheme.spacingMedium,
                  child: CommonStyles.badge(
                    text: itinerary.rating.toStringAsFixed(1),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Itinerary Details
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Cost',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: AppTheme.fontSizeSmall,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingXSmall),
                          AppComponents.priceDisplay(
                            itinerary.totalCost,
                            fontSize: AppTheme.fontSizeLarge,
                          ),
                          const SizedBox(height: AppTheme.spacingXSmall),
                          Text(
                            savings,
                            style: TextStyle(
                              color: AppTheme.secondaryColor,
                              fontSize: AppTheme.fontSizeXSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItineraryDetailsPage(
                              itinerary: itinerary,
                            ),
                          ),
                        );
                      },
                      style: CommonStyles.primaryButtonStyle,
                      child: const Text('View Details'),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacingSmall),
                const Divider(height: 1),
                const SizedBox(height: AppTheme.spacingSmall),
                
                // User Reviews and Personalized Tips
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: itinerary.creatorAvatar != null
                          ? NetworkImage(itinerary.creatorAvatar!)
                          : null,
                      child: itinerary.creatorAvatar == null
                          ? Text(itinerary.creatorName[0].toUpperCase(), style: const TextStyle(fontSize: AppTheme.fontSizeXSmall))
                          : null,
                    ),
                    const SizedBox(width: AppTheme.spacingSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Created by ${itinerary.creatorName}',
                            style: const TextStyle(
                              color: AppTheme.textPrimaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: AppTheme.fontSizeSmall,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppTheme.spacingXSmall),
                          Text(
                            tips.isNotEmpty
                                ? tips.first.toString()
                                : 'Personalized itinerary for your trip',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: AppTheme.fontSizeXSmall,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppTheme.spacingSmall),
                          // Use a Row with bounded height instead of Wrap for tags
                          SizedBox(
                            height: 24,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: (itinerary.tags.isNotEmpty ? itinerary.tags : ['Popular'])
                                  .map((tag) => Padding(
                                    padding: const EdgeInsets.only(right: AppTheme.spacingXSmall),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppTheme.spacingSmall,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceColor.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                                      ),
                                      child: Text(
                                        tag,
                                        style: const TextStyle(
                                          fontSize: AppTheme.fontSizeXSmall,
                                        ),
                                      ),
                                    ),
                                  ))
                                  .toList(),
                            ),
                          ),
                        ],
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
  }
} 