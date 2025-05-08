import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_styles.dart';
import '../../core/widgets/app_components.dart';
import '../../core/widgets/bottom_nav_spacer.dart';
import '../../core/widgets/brand_logo.dart';
import '../../core/widgets/global_app_bar.dart';
import '../../core/theme/app_icons.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin {
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

  // Travel moment details controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedType = 'Adventure';
  List<XFile> _selectedImages = [];

  // Experience details controllers
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  final TextEditingController _bestTimeController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final List<TextEditingController> _tipsControllers = [TextEditingController()];

  final ScrollController _scrollController = ScrollController();
  bool _isLiked = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  void _generateMockData() {
    _moments.addAll([
      TravelMoment(
        id: '1',
        type: 'Adventure',
        caption: 'Epic sunrise trek to Mount Batur with the gang! 🌋 Still can\'t believe we made it to the top in time to catch this incredible view. Worth every step of that 2AM start. Special shoutout to our amazing guide @baliguide for keeping our spirits high (and keeping us from getting lost 😅)',
        images: [
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4',
          'https://images.unsplash.com/photo-1537997322377-89e764fd7f10',
          'https://images.unsplash.com/photo-1542332213-1d277bf3d6c6',
        ],
        location: 'Mount Batur, Bali, Indonesia',
        creator: TravelCreator(
          name: 'Sarah Chen',
          avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
          expertise: 'Adventure Expert',
          verified: true,
        ),
        taggedUsers: [
          TravelCreator(
            name: 'Mike Ross',
            avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
            expertise: 'Photography Enthusiast',
            verified: false,
          ),
          TravelCreator(
            name: 'Emma Wilson',
            avatar: 'https://randomuser.me/api/portraits/women/44.jpg',
            expertise: 'Travel Blogger',
            verified: true,
          ),
        ],
        hashtags: [
          'sunrise',
          'balilife',
          'mountbatur',
          'trekkingadventures',
          'volcanoviews',
          'wanderlust',
          'travelgang',
        ],
        details: TravelDetails(
          duration: '4 hours',
          difficulty: 'Moderate',
          bestTime: 'Early Morning',
          cost: '\$30',
        ),
        tips: [
          'Start early at 3:30 AM to catch the sunrise',
          'Bring warm clothes - it\'s chilly at the top!',
          'Wear good hiking shoes with grip',
          'Pack snacks and plenty of water',
          'Bring a headlamp or flashlight',
        ],
        engagement: const Engagement(likes: 1234, comments: 89, saves: 456, shares: 78),
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      TravelMoment(
        id: '2',
        type: 'Cultural',
        caption: 'Immersed in the ancient art of Japanese tea ceremony today 🍵 Such a peaceful and mindful experience learning about this beautiful tradition. Every movement has meaning, every moment is precious. Huge thanks to @teamaster.kyoto for this authentic experience! 🇯🇵 ✨',
        images: [
          'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9',
          'https://images.unsplash.com/photo-1528207776546-365bb710ee93',
          'https://images.unsplash.com/photo-1531983412531-426dde7a8b6f',
        ],
        location: 'Traditional Tea House, Kyoto, Japan',
        creator: TravelCreator(
          name: 'Yuki Tanaka',
          avatar: 'https://randomuser.me/api/portraits/women/2.jpg',
          expertise: 'Culture Guide',
          verified: true,
        ),
        taggedUsers: [
          TravelCreator(
            name: 'Tea Master Hiroshi',
            avatar: 'https://randomuser.me/api/portraits/men/42.jpg',
            expertise: 'Tea Ceremony Master',
            verified: true,
          ),
        ],
        hashtags: [
          'teaceremony',
          'japaneseculture',
          'kyotolife',
          'mindfulness',
          'culturalexperience',
          'teatradition',
          'zen',
        ],
        details: TravelDetails(
          duration: '2 hours',
          difficulty: 'Easy',
          bestTime: 'Afternoon',
          cost: '\$45',
        ),
        tips: [
          'Wear comfortable clothes that allow sitting on tatami',
          'Remove shoes before entering the tea room',
          'Arrive 10-15 minutes early',
          'Photos only allowed at specific times',
          'Be prepared to sit in seiza position',
        ],
        engagement: const Engagement(likes: 892, comments: 56, saves: 345, shares: 67),
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ]);
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('MMMM d').format(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBody: true,
      appBar: const GlobalAppBar(),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _moments.length,
        itemBuilder: (context, index) {
          final moment = _moments[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: CachedNetworkImageProvider(moment.creator.avatar),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                moment.creator.name,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (moment.creator.verified)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.verified,
                                    size: 14,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                          Text(
                            moment.location,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onBackground.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // View Itinerary Button
                    IconButton(
                      onPressed: () {
                        // TODO: Navigate to itinerary view
                      },
                      icon: Icon(
                        AppIcons.calendar,
                        color: theme.colorScheme.onBackground,
                        size: 22,
                      ),
                    ),
                    // Save Button and Count
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isSaved = !_isSaved;
                            });
                          },
                          icon: Icon(
                            _isSaved ? AppIcons.bookmarkFilled : AppIcons.bookmark,
                            color: theme.colorScheme.onBackground,
                            size: 24,
                          ),
                        ),
                        Text(
                          NumberFormat.compact().format(moment.engagement.saves),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: theme.colorScheme.onBackground,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              child: SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 4,
                                      width: 40,
                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        AppIcons.close,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                      title: Text(
                                        'Hide this post',
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                      onTap: () {
                                        // TODO: Implement hide post
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        AppIcons.error,
                                        color: theme.colorScheme.error,
                                      ),
                                      title: Text(
                                        'Report this post',
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                      onTap: () {
                                        // TODO: Implement report post
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        AppIcons.error,
                                        color: theme.colorScheme.error,
                                      ),
                                      title: Text(
                                        'Report ${moment.creator.name}',
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                      onTap: () {
                                        // TODO: Implement report user
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        AppIcons.close,
                                        color: theme.colorScheme.error,
                                      ),
                                      title: Text(
                                        'Block ${moment.creator.name}',
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                      onTap: () {
                                        // TODO: Implement block user
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            );
                          },
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Image Gallery
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  height: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    itemCount: moment.images.length,
                    itemBuilder: (context, index) {
                      final imagePath = moment.images[index];
                      final bool isNetworkImage = imagePath.startsWith('http');
                      
                      return Stack(
                        children: [
                          if (isNetworkImage)
                            CachedNetworkImage(
                              imageUrl: imagePath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          else
                            Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          // Image counter indicator
                          if (moment.images.length > 1)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${index + 1}/${moment.images.length}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              // Caption and details
              Padding(
                padding: EdgeInsets.fromLTRB(
                  theme.cardTheme.margin?.horizontal ?? AppTheme.spacingMedium,
                  16,
                  theme.cardTheme.margin?.horizontal ?? AppTheme.spacingMedium,
                  theme.visualDensity.vertical * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Caption with tags
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onBackground,
                        ),
                        children: [
                          TextSpan(
                            text: moment.creator.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(text: moment.caption),
                        ],
                      ),
                    ),
                    if (moment.taggedUsers.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 16,
                          ),
                          ...moment.taggedUsers.map((user) => Text(
                            '@${user.name.toLowerCase().replaceAll(' ', '')}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                        ],
                      ),
                    ],
                    if (moment.hashtags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: moment.hashtags.map((tag) => Text(
                          '#$tag',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        )).toList(),
                      ),
                    ],
                    const SizedBox(height: 12),
                    // Trip Type Row
                    Row(
                      children: [
                        Icon(
                          _getTripTypeIcon(moment.type),
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          moment.type,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Trip Details Row
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _buildTripDetailItemNew(
                          context: context,
                          icon: Icons.schedule,
                          label: 'Duration',
                          value: moment.details.duration,
                        ),
                        _buildTripDetailItemNew(
                          context: context,
                          icon: Icons.trending_up,
                          label: 'Difficulty',
                          value: moment.details.difficulty,
                        ),
                        _buildTripDetailItemNew(
                          context: context,
                          icon: Icons.wb_sunny_outlined,
                          label: 'Best Time',
                          value: moment.details.bestTime,
                        ),
                        _buildTripDetailItemNew(
                          context: context,
                          icon: Icons.attach_money,
                          label: 'Cost',
                          value: moment.details.cost,
                        ),
                      ],
                    ),
                    // Tips Section
                    if (moment.tips.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 16,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tips',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: moment.tips.map((tip) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check,
                              size: 14,
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tip,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        )).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              // Time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  _getTimeAgo(moment.timestamp),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // Like Button and Count
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isLiked = !_isLiked;
                            });
                          },
                          icon: Icon(
                            _isLiked ? AppIcons.likeFilled : AppIcons.like,
                            color: _isLiked ? Colors.red : theme.colorScheme.onBackground,
                            size: 24,
                          ),
                        ),
                        Text(
                          NumberFormat.compact().format(moment.engagement.likes),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Comment Button and Count
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // TODO: Show comments
                          },
                          icon: Icon(
                            AppIcons.chat,
                            color: theme.colorScheme.onBackground,
                            size: 22,
                          ),
                        ),
                        Text(
                          NumberFormat.compact().format(moment.engagement.comments),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Share Button and Count
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // TODO: Show share options
                          },
                          icon: Icon(
                            AppIcons.share,
                            color: theme.colorScheme.onBackground,
                            size: 22,
                          ),
                        ),
                        Text(
                          NumberFormat.compact().format(moment.engagement.shares),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Subtle divider with gradient fade
              Container(
                height: 16,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.surfaceVariant.withOpacity(0.05),
                      theme.colorScheme.surfaceVariant.withOpacity(0.1),
                      theme.colorScheme.surfaceVariant.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getTripTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'adventure':
        return Icons.landscape;
      case 'cultural':
        return Icons.museum;
      case 'food':
        return Icons.restaurant;
      case 'nature':
        return Icons.park;
      case 'urban':
        return Icons.location_city;
      case 'wellness':
        return Icons.spa;
      default:
        return Icons.travel_explore;
    }
  }

  Widget _buildTripDetailItemNew({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    final theme = Theme.of(context);
    
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline,
            width: 0.5,
          ),
        ),
      ),
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
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected 
                      ? theme.colorScheme.onPrimary 
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
              },
              backgroundColor: theme.colorScheme.surfaceVariant,
              selectedColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailChip({required IconData icon, required String label}) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
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

  void _showAddExperienceSheet() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.outline,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(AppIcons.close, color: theme.colorScheme.onSurface),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            'Share Experience',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
                          onPressed: _selectedImages.isEmpty ? null : () {
                            _submitExperience();
                          },
                          child: Text(
                            'Share',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: _selectedImages.isEmpty 
                                ? theme.colorScheme.primary.withOpacity(0.5) 
                                : theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Selection
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _selectedImages.isEmpty
                              ? InkWell(
                                  onTap: () async {
                                    final List<XFile>? images = await _picker.pickMultiImage();
                                    if (images != null && images.isNotEmpty) {
                                      setState(() {
                                        _selectedImages = images;
                                      });
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        AppIcons.gallery,
                                        size: 48,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Add Photos',
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Up to 10 photos',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : PageView.builder(
                                  itemCount: _selectedImages.length,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.file(
                                          File(_selectedImages[index].path),
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: IconButton.filledTonal(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              setState(() {
                                                _selectedImages.removeAt(index);
                                              });
                                            },
                                            style: IconButton.styleFrom(
                                              backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.7),
                                              foregroundColor: theme.colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                        if (_selectedImages.length > 1)
                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.7),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '${index + 1}/${_selectedImages.length}',
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                          ),
                          const SizedBox(height: 16),
                          // Caption Field
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.12),
                                width: 1,
                              ),
                              color: theme.colorScheme.surfaceVariant.withOpacity(0.06),
                            ),
                            child: TextField(
                              controller: _captionController,
                              maxLines: 5,
                              maxLength: 500,
                              decoration: InputDecoration(
                                hintText: 'Write a caption... Share your experience!',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.08),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Location Field
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.12),
                                width: 1,
                              ),
                              color: theme.colorScheme.surfaceVariant.withOpacity(0.06),
                            ),
                            child: TextField(
                              controller: _locationController,
                              decoration: InputDecoration(
                                hintText: 'Add location',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(
                                    AppIcons.location,
                                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                    size: 20,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.08),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Trip Type Selection
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.shadow.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, -2),
                                ),
                                BoxShadow(
                                  color: theme.colorScheme.shadow.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedType,
                              decoration: InputDecoration(
                                labelText: 'Trip Type',
                                labelStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(
                                    AppIcons.activity,
                                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                    size: 20,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              items: _categories.map((String type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(
                                    type,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedType = newValue;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                              ),
                              dropdownColor: theme.colorScheme.surface,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Trip Details Section
                          Text(
                            'Trip Details',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Duration Field
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.12),
                                width: 1,
                              ),
                              color: theme.colorScheme.surfaceVariant.withOpacity(0.06),
                            ),
                            child: TextField(
                              controller: _durationController,
                              decoration: InputDecoration(
                                labelText: 'Duration',
                                hintText: 'e.g., 2 hours, 3 days',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                                labelStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(
                                    AppIcons.time,
                                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                    size: 20,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Difficulty Field
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.12),
                                width: 1,
                              ),
                              color: theme.colorScheme.surfaceVariant.withOpacity(0.06),
                            ),
                            child: TextField(
                              controller: _difficultyController,
                              decoration: InputDecoration(
                                labelText: 'Difficulty Level',
                                hintText: 'e.g., Easy, Moderate, Challenging',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                                labelStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(
                                    Icons.trending_up_rounded,
                                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                    size: 20,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Best Time Field
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.12),
                                width: 1,
                              ),
                              color: theme.colorScheme.surfaceVariant.withOpacity(0.06),
                            ),
                            child: TextField(
                              controller: _bestTimeController,
                              decoration: InputDecoration(
                                labelText: 'Best Time',
                                hintText: 'e.g., Early Morning, Sunset, Spring',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                                labelStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(
                                    AppIcons.time,
                                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                    size: 20,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Cost Field
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.12),
                                width: 1,
                              ),
                              color: theme.colorScheme.surfaceVariant.withOpacity(0.06),
                            ),
                            child: TextField(
                              controller: _costController,
                              decoration: InputDecoration(
                                labelText: 'Cost',
                                hintText: 'e.g., \$30, Free',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                                labelStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(
                                    AppIcons.money,
                                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                    size: 20,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Tips Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tips for Visitors',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _tipsControllers.add(TextEditingController());
                                  });
                                },
                                icon: Icon(AppIcons.add, size: 18),
                                label: const Text('Add Tip'),
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _tipsControllers.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: theme.colorScheme.shadow.withOpacity(0.08),
                                            width: 1,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _tipsControllers[index],
                                          decoration: InputDecoration(
                                            hintText: 'Add a helpful tip',
                                            hintStyle: TextStyle(
                                              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                              fontSize: 16,
                                            ),
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              child: Icon(
                                                AppIcons.info,
                                                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                                size: 20,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(16),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(16),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(16),
                                              borderSide: BorderSide(
                                                color: theme.colorScheme.primary.withOpacity(0.5),
                                                width: 1,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                                            contentPadding: const EdgeInsets.all(16),
                                          ),
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (index > 0)
                                      IconButton(
                                        icon: Icon(
                                          AppIcons.close,
                                          size: 20,
                                          color: theme.colorScheme.error.withOpacity(0.7),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _tipsControllers.removeAt(index);
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _submitExperience() {
    final theme = Theme.of(context);
    // Validate inputs
    if (_selectedImages.isEmpty ||
        _captionController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all required fields and add at least one image',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onError,
            ),
          ),
          backgroundColor: theme.colorScheme.error,
        ),
      );
      return;
    }

    // Convert XFile paths to strings
    final List<String> imagePaths = _selectedImages.map((xFile) => xFile.path).toList();

    // Create new travel moment
    final newMoment = TravelMoment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      caption: _captionController.text,
      images: imagePaths, // Use the converted image paths
      location: _locationController.text,
      creator: TravelCreator(
        name: 'Current User', // In real app, get from user profile
        avatar: 'https://randomuser.me/api/portraits/women/1.jpg', // In real app, get from user profile
        expertise: 'Travel Enthusiast', // In real app, get from user profile
        verified: false,
      ),
      taggedUsers: const [], // Initialize with empty list
      hashtags: const [], // Initialize with empty list
      details: TravelDetails(
        duration: _durationController.text.isEmpty ? 'Not specified' : _durationController.text,
        difficulty: _difficultyController.text.isEmpty ? 'Not specified' : _difficultyController.text,
        bestTime: _bestTimeController.text.isEmpty ? 'Not specified' : _bestTimeController.text,
        cost: _costController.text.isEmpty ? 'Not specified' : _costController.text,
      ),
      tips: _tipsControllers
          .map((controller) => controller.text)
          .where((text) => text.isNotEmpty)
          .toList(),
      engagement: Engagement.empty(),
      timestamp: DateTime.now(),
    );

    // Add to moments list
    setState(() {
      _moments.insert(0, newMoment);
    });

    // Clear form
    _clearForm();

    // Close sheet
    Navigator.pop(context);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Experience shared successfully!',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }

  void _clearForm() {
    _selectedImages.clear();
    _captionController.clear();
    _locationController.clear();
    _durationController.clear();
    _difficultyController.clear();
    _bestTimeController.clear();
    _costController.clear();
    _tipsControllers.forEach((controller) => controller.clear());
    _selectedType = 'Adventure';
  }

  void showAddExperienceSheet() {
    _showAddExperienceSheet();
  }
}

class TravelMoment {
  final String id;
  final String type;
  final String caption;
  final List<String> images;
  final String location;
  final TravelCreator creator;
  final List<TravelCreator> taggedUsers;
  final List<String> hashtags;
  final TravelDetails details;
  final List<String> tips;
  final Engagement engagement;
  final DateTime timestamp;

  TravelMoment({
    required this.id,
    required this.type,
    required this.caption,
    required this.images,
    required this.location,
    required this.creator,
    this.taggedUsers = const [],
    this.hashtags = const [],
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
  final int comments;
  final int saves;
  final int shares;

  const Engagement({
    required this.likes,
    required this.comments,
    required this.saves,
    required this.shares,
  });

  // Add a convenient constructor for new/empty engagements
  static Engagement empty() {
    return const Engagement(likes: 0, comments: 0, saves: 0, shares: 0);
  }
} 