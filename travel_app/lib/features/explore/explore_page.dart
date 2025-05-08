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
import '../../core/widgets/brand_logo.dart';
import '../../core/widgets/global_app_bar.dart';

class ExplorePage extends StatefulWidget {
  final ItineraryService itineraryService;

  const ExplorePage({
    super.key,
    required this.itineraryService,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with SingleTickerProviderStateMixin {
  late final ItineraryService _itineraryService;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  List<Map<String, dynamic>> _recommendedItineraries = [];
  String? _selectedDestination;
  
  // Chat related variables
  final List<ChatMessage> _messages = [];
  bool _isChatOpen = false;
  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;
  
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
    _initializeAnimations();
    _addBotMessage("Hi! I'm your travel assistant. How can I help you explore destinations today?");
  }
  
  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOut,
    ));
  }
  
  void _toggleChat() {
    if (_animationController == null) return;
    
    setState(() {
      _isChatOpen = !_isChatOpen;
      if (_isChatOpen) {
        _animationController!.forward();
      } else {
        _animationController!.reverse();
      }
    });
  }
  
  void _addBotMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: false,
      ));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
      ));
      _messageController.clear();
    });
    _scrollToBottom();
    
    // Add mock response after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (message.toLowerCase().contains('beach')) {
        _addBotMessage("Here are some popular beach destinations: Goa, Andaman, Lakshadweep, and Kerala. Would you like more specific recommendations?");
      } else if (message.toLowerCase().contains('mountain')) {
        _addBotMessage("Great choice! Manali, Shimla, Darjeeling, and Ladakh are amazing mountain destinations. What kind of activities are you interested in?");
      } else {
        _addBotMessage("Thanks for your query! I'll help you find the perfect destination based on your interests. Can you tell me more about what you're looking for?");
      }
    });
  }
  
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  void _processUserMessage(String text) {
    if (text.trim().isEmpty) return;
    _addUserMessage(text);
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
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBody: true,
      appBar: const GlobalAppBar(),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.15),
                            offset: const Offset(0, 6),
                            blurRadius: 16,
                            spreadRadius: -4,
                          ),
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.08),
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Search destinations...',
                          hintStyle: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Small spacer
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                
                // Section Titles
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popular Destinations',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // View all destinations
                          },
                          child: Text(
                            'View All',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Destination Cards Text
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 180,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      itemCount: _popularDestinations.length,
                      itemBuilder: (context, index) {
                        final destination = _popularDestinations[index];
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: Card(
                            elevation: 4,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                AppComponents.cachedImage(
                                  imageUrl: destination['image'] as String,
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
                                  left: 12,
                                  right: 12,
                                  bottom: 12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        destination['name'] as String,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        destination['subtitle'] as String,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _selectDestination(destination['name'] as String),
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
                
                // Recommended Itineraries
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recommended Itineraries',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onBackground,
                          ),
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
                
                // Itineraries Grid or List
                _isLoading
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final itinerary = _recommendedItineraries[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildItineraryCard(itinerary),
                              );
                            },
                            childCount: _recommendedItineraries.length,
                          ),
                        ),
                      ),
                
                BottomNavSpacer.sliverDynamic(context),
              ],
            ),
            
            // Chat Interface
            if (_isChatOpen)
              Positioned.fill(
                bottom: 0,
                child: SlideTransition(
                  position: _slideAnimation!,
                  child: Container(
                    color: theme.colorScheme.background,
                    child: Column(
                      children: [
                        // Chat header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: theme.colorScheme.onPrimary,
                                child: Icon(
                                  Icons.explore,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Glint Assistant',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: theme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Ask me anything about travel',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: theme.colorScheme.onPrimary,
                                ),
                                onPressed: _toggleChat,
                              ),
                            ],
                          ),
                        ),
                        
                        // Messages List
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              return _buildChatMessage(message);
                            },
                          ),
                        ),
                        
                        // Suggested Prompts
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: theme.colorScheme.primaryContainer.withOpacity(0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Try asking:',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _suggestedPrompts.map((prompt) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ActionChip(
                                      label: Text(
                                        prompt,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onPrimary,
                                        ),
                                      ),
                                      backgroundColor: theme.colorScheme.primary.withOpacity(0.7),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      onPressed: () {
                                        _messageController.text = prompt;
                                        _processUserMessage(prompt);
                                      },
                                    ),
                                  )).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Message Input
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom + 56,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              border: Border(
                                top: BorderSide(
                                  color: theme.colorScheme.outline.withOpacity(0.2),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: theme.colorScheme.outline.withOpacity(0.1),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _messageController,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: theme.colorScheme.onSurface,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Ask about destinations...',
                                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(24),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      onSubmitted: _processUserMessage,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    Icons.send_rounded,
                                    color: theme.colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    final message = _messageController.text.trim();
                                    if (message.isNotEmpty) {
                                      _processUserMessage(message);
                                      _messageController.clear();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _isChatOpen ? null : Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 56), // 56 is navbar height
        child: FloatingActionButton(
          onPressed: _toggleChat,
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.chat_bubble_outline_rounded),
        ),
      ),
    );
  }
  
  Widget _buildChatMessage(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildItineraryCard(Map<String, dynamic> itineraryData) {
    final itinerary = Itinerary.fromJson(itineraryData['itinerary']);
    final duration = itinerary.endDate.difference(itinerary.startDate).inDays + 1;
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
                  AppComponents.cachedImage(
                    imageUrl: itinerary.images.isNotEmpty
                      ? itinerary.images.first
                      : 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
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
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: theme.colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.5',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itinerary.destination,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildChip(
                              icon: Icons.calendar_today_rounded,
                              label: '$duration days',
                            ),
                            const SizedBox(width: 8),
                            _buildChip(
                              icon: Icons.group_rounded,
                              label: '${itinerary.numberOfPeople} people',
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildChip({
    required IconData icon,
    required String label,
  }) {
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
            color: Colors.white,
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
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
} 