import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_styles.dart';
import '../../core/widgets/app_components.dart';
import '../../core/widgets/bottom_nav_spacer.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin {
  final List<TravelMoment> _moments = [];
  final List<String> _categories = [
    'All',
    'Adventure',
    'Cultural',
    'Food',
    'Nature',
    'Urban',
    'Wellness'
  ];
  String _selectedCategory = 'All';
  bool _isCreatingMoment = false;
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  void _generateMockData() {
    // Add moments data
    _moments.addAll([
      TravelMoment(
        id: '1',
        type: 'Adventure',
        title: 'Sunrise Trek to Mount Batur',
        location: 'Bali, Indonesia',
        imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4',
        creator: TravelCreator(
          name: 'Sarah Chen',
          avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
          expertise: 'Adventure Expert',
          verified: true,
        ),
        details: TravelDetails(
          duration: '4 hours',
          difficulty: 'Moderate',
          bestTime: 'Early Morning',
          cost: '\$30',
        ),
        tips: [
          'Start early at 3:30 AM',
          'Bring warm clothes',
          'Wear good hiking shoes',
        ],
        engagement: Engagement(likes: 1234, saves: 456, shares: 89),
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      TravelMoment(
        id: '2',
        type: 'Cultural',
        title: 'Traditional Tea Ceremony Experience',
        location: 'Kyoto, Japan',
        imageUrl: 'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9',
        creator: TravelCreator(
          name: 'Yuki Tanaka',
          avatar: 'https://randomuser.me/api/portraits/women/2.jpg',
          expertise: 'Culture Guide',
          verified: true,
        ),
        details: TravelDetails(
          duration: '2 hours',
          difficulty: 'Easy',
          bestTime: 'Afternoon',
          cost: '\$45',
        ),
        tips: [
          'Wear socks as shoes are removed',
          'Arrive 10 minutes early',
          'Photography is limited',
        ],
        engagement: Engagement(likes: 892, saves: 345, shares: 67),
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ]);
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              title: const Text(
                'Glint Feed',
                style: TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: AppTheme.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_box_outlined, size: AppTheme.iconSizeMedium),
                  onPressed: _createMoment,
                  tooltip: 'Share your travel moment',
                  padding: const EdgeInsets.all(AppTheme.spacingSmall),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: _buildCategorySelector(),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final moment = _moments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spacingLarge),
                      child: _buildMomentCard(moment),
                    );
                  },
                  childCount: _moments.length,
                ),
              ),
            ),
            
            BottomNavSpacer.sliverDynamic(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMomentCard(TravelMoment moment) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with creator info
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(moment.creator.avatar),
              radius: 20,
            ),
            title: Row(
              children: [
                Text(
                  moment.creator.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (moment.creator.verified)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.verified,
                      size: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
            subtitle: Text(
              moment.creator.expertise,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
            ),
            trailing: Text(
              _getTimeAgo(moment.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            dense: true,
          ),

          // Image with location overlay
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 4/3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    moment.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.white),
                      const SizedBox(width: 2),
                      Text(
                        moment.location,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Title and details
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        moment.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.map_outlined, size: 20),
                      onPressed: () {
                        // Show itinerary dialog
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => DraggableScrollableSheet(
                            initialChildSize: 0.7,
                            minChildSize: 0.5,
                            maxChildSize: 0.95,
                            builder: (_, controller) => Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Trip Itinerary',
                                          style: Theme.of(context).textTheme.titleLarge,
                                        ),
                                        const Spacer(),
                                        TextButton.icon(
                                          icon: const Icon(Icons.bookmark_border),
                                          label: const Text('Save Itinerary'),
                                          onPressed: () {
                                            // TODO: Implement save itinerary
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Itinerary saved! You can find it in My Trips.'),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  Expanded(
                                    child: ListView(
                                      controller: controller,
                                      padding: const EdgeInsets.all(16),
                                      children: [
                                        _buildItineraryDay(
                                          context,
                                          dayNumber: 1,
                                          activities: [
                                            'Early morning trek start (3:30 AM)',
                                            'Reach summit for sunrise',
                                            'Breakfast at mountain cafe',
                                            'Guided tour of volcanic features',
                                            'Return trek with photo stops',
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      tooltip: 'View Trip Itinerary',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailChip(Icons.timer, moment.details.duration),
                    _buildDetailChip(Icons.hiking, moment.details.difficulty),
                    _buildDetailChip(Icons.wb_sunny, moment.details.bestTime),
                    _buildDetailChip(Icons.attach_money, moment.details.cost),
                  ],
                ),
              ],
            ),
          ),

          // Quick tips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Tips',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                ...moment.tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          tip,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),

          // Engagement buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEngagementButton(
                  Icons.favorite_border,
                  '${NumberFormat.compact().format(moment.engagement.likes)}',
                  () {},
                ),
                _buildEngagementButton(
                  Icons.bookmark_border,
                  '${NumberFormat.compact().format(moment.engagement.saves)}',
                  () {},
                ),
                _buildEngagementButton(
                  Icons.share,
                  '${NumberFormat.compact().format(moment.engagement.shares)}',
                  () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12),
          const SizedBox(width: 3),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementButton(IconData icon, String count, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 3),
          Text(
            count,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  void _createMoment() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _isCreatingMoment = true;
      });
      // Show moment creation dialog
    }
  }

  Widget _buildItineraryDay(BuildContext context, {
    required int dayNumber,
    required List<String> activities,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Day $dayNumber',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...activities.map((activity) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.circle, size: 8),
              const SizedBox(width: 8),
              Expanded(
                child: Text(activity),
              ),
            ],
          ),
        )).toList(),
        const SizedBox(height: 16),
      ],
    );
  }
}

class TravelMoment {
  final String id;
  final String type;
  final String title;
  final String location;
  final String imageUrl;
  final TravelCreator creator;
  final TravelDetails details;
  final List<String> tips;
  final Engagement engagement;
  final DateTime timestamp;

  TravelMoment({
    required this.id,
    required this.type,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.creator,
    required this.details,
    required this.tips,
    required this.engagement,
    required this.timestamp,
  });
}

class TravelCreator {
  final String name;
  final String avatar;
  final String expertise;
  final bool verified;

  TravelCreator({
    required this.name,
    required this.avatar,
    required this.expertise,
    required this.verified,
  });
}

class TravelDetails {
  final String duration;
  final String difficulty;
  final String bestTime;
  final String cost;

  TravelDetails({
    required this.duration,
    required this.difficulty,
    required this.bestTime,
    required this.cost,
  });
}

class Engagement {
  final int likes;
  final int saves;
  final int shares;

  Engagement({
    required this.likes,
    required this.saves,
    required this.shares,
  });
} 