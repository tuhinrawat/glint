import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/widgets/nav_bar.dart';
import '../../models/itinerary.dart';
import '../../services/itinerary_service.dart';

class HomePage extends StatefulWidget {
  final ItineraryService itineraryService;

  const HomePage({
    super.key,
    required this.itineraryService,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final destinations = [
    {
      'name': 'Goa',
      'subtitle': 'Beaches & Culture',
      'image': 'https://images.unsplash.com/photo-1512100356356-de1b84283e18'
    },
    {
      'name': 'Himachal',
      'subtitle': 'Mountains & Adventure',
      'image': 'https://images.unsplash.com/photo-1512100356356-de1b84283e18'
    },
    {
      'name': 'Kerala',
      'subtitle': 'Backwaters & Nature',
      'image': 'https://images.unsplash.com/photo-1512100356356-de1b84283e18'
    },
    {
      'name': 'Ladakh',
      'subtitle': 'High Altitude & Culture',
      'image': 'https://images.unsplash.com/photo-1512100356356-de1b84283e18'
    },
    {
      'name': 'Rajasthan',
      'subtitle': 'Desert & Heritage',
      'image': 'https://images.unsplash.com/photo-1512100356356-de1b84283e18'
    },
    {
      'name': 'Andaman',
      'subtitle': 'Islands & Adventure',
      'image': 'https://images.unsplash.com/photo-1512100356356-de1b84283e18'
    },
  ];

  late AnimationController _searchController;
  int _currentIndex = 0;

  // Dummy dashboard data
  final Map<String, dynamic> upcomingTrip = {
    'destination': 'Goa',
    'date': DateTime.now().add(const Duration(days: 12)),
    'image': 'https://images.unsplash.com/photo-1512100356356-de1b84283e18',
  };
  final totalTrips = 7;
  final savedPlaces = 4;

  // Dummy feed data
  final List<Map<String, dynamic>> feed = [
    {
      'user': 'Aditi Sharma',
      'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
      'media': [
        {
          'type': 'image',
          'url': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
        },
        {
          'type': 'image',
          'url': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
        },
        {
          'type': 'image',
          'url': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9',
        },
        {
          'type': 'image',
          'url': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308',
        },
        {
          'type': 'image',
          'url': 'https://images.unsplash.com/photo-1465101178521-c1a9136a3b99',
        },
      ],
      'place': 'Manali',
      'text': 'Just finished a trek in Manali! Highly recommend the Solang Valley for adventure lovers. #mountains',
      'likes': 12,
      'dislikes': 1,
      'saved': false,
      'liked': false,
      'disliked': false,
    },
    {
      'user': 'Rahul Verma',
      'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
      'media': [
        {
          'type': 'image',
          'url': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
        },
        {
          'type': 'image',
          'url': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9',
        },
      ],
      'place': 'Goa',
      'text': "Sunsets in Goa are magical. Don't miss the beach shacks for seafood!",
      'likes': 22,
      'dislikes': 0,
      'saved': true,
      'liked': true,
      'disliked': false,
    },
    {
      'user': 'Priya Singh',
      'avatar': 'https://randomuser.me/api/portraits/women/65.jpg',
      'media': [
        {
          'type': 'image',
          'url': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9',
        },
      ],
      'place': 'Jaipur',
      'text': 'Exploring the Pink City! Amber Fort is a must-visit. #heritage',
      'likes': 8,
      'dislikes': 0,
      'saved': false,
      'liked': false,
      'disliked': false,
    },
  ];

  // Add this to your state class
  final Map<int, PageController> _pageControllers = {};
  final Map<int, int> _currentPages = {};

  @override
  void initState() {
    super.initState();
    _searchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    // Dispose all page controllers
    for (var controller in _pageControllers.values) {
      controller.dispose();
    }
    _searchController.dispose();
    super.dispose();
  }

  void _toggleLike(int idx) {
    setState(() {
      if (feed[idx]['liked'] == true) {
        feed[idx]['liked'] = false;
        feed[idx]['likes'] -= 1;
      } else {
        feed[idx]['liked'] = true;
        feed[idx]['likes'] += 1;
        if (feed[idx]['disliked'] == true) {
          feed[idx]['disliked'] = false;
          feed[idx]['dislikes'] -= 1;
        }
      }
    });
  }

  void _toggleDislike(int idx) {
    setState(() {
      if (feed[idx]['disliked'] == true) {
        feed[idx]['disliked'] = false;
        feed[idx]['dislikes'] -= 1;
      } else {
        feed[idx]['disliked'] = true;
        feed[idx]['dislikes'] += 1;
        if (feed[idx]['liked'] == true) {
          feed[idx]['liked'] = false;
          feed[idx]['likes'] -= 1;
        }
      }
    });
  }

  void _toggleSave(int idx) {
    setState(() {
      feed[idx]['saved'] = !(feed[idx]['saved'] ?? false);
    });
  }

  void _shareFeed(int idx) {
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Shared ${feed[idx]['place']} post!')),
    );
  }

  // Add this method to your state class
  Widget _buildMediaCarousel(Map<String, dynamic> item, int index) {
    final mediaList = item['media'] as List<dynamic>?;
    if (mediaList == null || mediaList.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey.shade900,
        child: const Center(
          child: Icon(Icons.image, color: Colors.white38, size: 40),
        ),
      );
    }

    if (!_pageControllers.containsKey(index)) {
      _pageControllers[index] = PageController();
    }

    return Stack(
      children: [
        // Media Carousel
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageControllers[index],
            itemCount: mediaList.length,
            onPageChanged: (page) {
              setState(() {
                _currentPages[index] = page;
              });
            },
            itemBuilder: (context, mediaIndex) {
              final media = mediaList[mediaIndex] as Map<String, dynamic>;
              if (media['type'] == 'video') {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: media['thumbnail'] as String,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SpinKitDoubleBounce(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade900,
                        child: const Icon(Icons.error, color: Colors.white38, size: 40),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return CachedNetworkImage(
                  imageUrl: media['url'] as String,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: SpinKitDoubleBounce(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade900,
                    child: const Icon(Icons.error, color: Colors.white38, size: 40),
                  ),
                );
              }
            },
          ),
        ),
        // Page Indicator
        if (mediaList.length > 1)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                mediaList.length,
                (i) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (_currentPages[index] ?? 0) == i
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        // Media Type Indicator
        Positioned(
          top: 10,
          right: 10,
          child: Row(
            children: List.generate(
              mediaList.length,
              (i) => Container(
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  (mediaList[i] as Map<String, dynamic>)['type'] == 'video' 
                      ? Icons.play_circle 
                      : Icons.image,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Background Image
          CachedNetworkImage(
            imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            placeholder: (context, url) => const Center(
              child: SpinKitDoubleBounce(color: Colors.white),
            ),
            errorWidget: (context, url, error) => Image.asset(
              'assets/placeholder.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTapDown: (_) => _searchController.forward(),
                    onTapUp: (_) => _searchController.reverse(),
                    onTapCancel: () => _searchController.reverse(),
                    child: ScaleTransition(
                      scale: Tween(begin: 1.0, end: 0.95).animate(_searchController),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Center(
                          child: TextField(
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search destinations...',
                              hintStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(Icons.search, color: Colors.black54, size: 20),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              isDense: true,
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Destinations
                Container(
                  height: 160,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(destinations[index]['image'] as String),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      destinations[index]['name'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      destinations[index]['subtitle'] as String,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Dashboard and Feed
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    itemCount: feed.length,
                    itemBuilder: (context, idx) {
                      final item = feed[idx];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.white.withOpacity(0.12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User info
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(item['avatar']),
                                radius: 22,
                              ),
                              title: Text(item['user'], style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: Text(item['place'], style: TextStyle(color: Colors.black54, fontSize: 12)),
                              trailing: IconButton(
                                icon: Icon(item['saved'] ? Icons.bookmark : Icons.bookmark_border, color: item['saved'] ? Colors.blue.shade800 : Colors.black54),
                                onPressed: () => _toggleSave(idx),
                              ),
                            ),
                            // Photo
                            _buildMediaCarousel(item, idx),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Text(item['text'], style: TextStyle(color: Colors.black87, fontSize: 13)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.thumb_up, color: item['liked'] ? Colors.green.shade800 : Colors.black54),
                                    onPressed: () => _toggleLike(idx),
                                  ),
                                  Text('${item['likes']}', style: TextStyle(color: Colors.black54, fontSize: 12)),
                                  IconButton(
                                    icon: Icon(Icons.thumb_down, color: item['disliked'] ? Colors.red.shade800 : Colors.black54),
                                    onPressed: () => _toggleDislike(idx),
                                  ),
                                  Text('${item['dislikes']}', style: TextStyle(color: Colors.black54, fontSize: 12)),
                                  IconButton(
                                    icon: const Icon(Icons.share, color: Colors.black54),
                                    onPressed: () => _shareFeed(idx),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // FloatingActionButton
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              heroTag: 'homePageFAB',
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post new trip update coming soon!')),
                );
              },
              child: const Icon(Icons.add, size: 30),
            ),
          ),
        ],
      ),
    );
  }
} 