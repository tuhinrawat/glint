import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../models/itinerary.dart';
import '../../models/travel_post.dart';
import '../../models/travel_story.dart';
import '../../models/chat_message.dart';
import '../../services/itinerary_service.dart';
import '../../core/widgets/nav_bar.dart';
import '../../core/widgets/common_styles.dart';
import '../../core/services/currency_service.dart';
import '../../core/theme/color_schemes.dart';

class ItineraryPage extends StatefulWidget {
  final ItineraryService service;

  ItineraryPage({super.key, ItineraryService? service})
      : service = service ?? ItineraryService();

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> with SingleTickerProviderStateMixin {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _pageController = PageController(viewportFraction: 0.88);
  final List<ChatMessage> _messages = [];
  List<Map<String, dynamic>> _suggestedItineraries = [];
  String? _userQuery;
  bool _isLoading = false;
  bool _isChatOpen = false;
  int _currentDay = 0;
  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;

  // Add new properties for social feed
  final List<TravelPost> _socialFeed = [];
  final List<TravelStory> _stories = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _addBotMessage("Hi! I'm your travel planning assistant. Where would you like to go?");
    _generateMockItineraries();
    _generateMockSocialFeed();
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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController?.dispose();
    super.dispose();
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
    });
    _scrollToBottom();
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

  Future<void> _processUserMessage(String message) async {
    if (message.isEmpty) return;
    _addUserMessage(message);
    setState(() {
      _isLoading = true;
      _userQuery = message;
    });
    try {
      // Extract info (simple parsing, can be improved)
      final words = message.split(' ');
      String destination = words.firstWhere((w) => w.toLowerCase() != 'i', orElse: () => 'Goa');
      int groupSize = 2;
      int duration = 6;
      for (var w in words) {
        if (int.tryParse(w) != null) {
          if (int.parse(w) > 3 && int.parse(w) < 30) duration = int.parse(w);
          if (int.parse(w) > 1 && int.parse(w) < 100) groupSize = int.parse(w);
        }
      }
      final itinerary = await widget.service.generateItinerary(
        destination: destination,
        budget: 50000,
        travelType: 'Leisure',
        groupSize: groupSize,
        startDate: DateTime.now(),
      );
      setState(() {
        _suggestedItineraries.add({
          "itinerary": itinerary,
          "likes": 50 + _suggestedItineraries.length * 17,
          "reviews": [
            {"user": "Aditi S.", "review": "Amazing trip! Well planned.", "avatar": "https://randomuser.me/api/portraits/women/44.jpg"},
            {"user": "Rahul V.", "review": "Loved the activities!", "avatar": "https://randomuser.me/api/portraits/men/32.jpg"},
          ],
          "health": [
            "Stay hydrated, especially in summer.",
            "Carry sunscreen and a hat.",
            if (destination == "Ladakh") "Beware of altitude sickness. Acclimatize properly.",
          ],
          "sustainability": [
            "Support local businesses.",
            "Avoid single-use plastics.",
            "Respect local culture and wildlife.",
          ],
          "wellBeing": [
            "Take regular breaks.",
            "Eat healthy local food.",
            "Get enough sleep.",
          ],
        });
        _isLoading = false;
      });
      // Only show a summary card, not chat bubbles for itinerary
    } catch (e) {
      setState(() => _isLoading = false);
      _addBotMessage("I'm sorry, I couldn't process that request. Could you please try again?");
    }
  }

  void _onStartBooking() {
    // Navigate to booking page or trigger booking logic
    Navigator.pushNamed(context, '/booking');
  }

  void _onMakeAdjustment() {
    // Let user adjust budget, group size, etc. For now, just prompt in chat
    _addBotMessage("Please type your new preferences (e.g., 'Change budget to 60000 for 8 people, 5 days').");
  }

  void _showBookingSheet(BuildContext context, String type, Itinerary itinerary) async {
    final destination = itinerary.destination;
    final startDate = itinerary.startDate;
    final endDate = itinerary.startDate.add(Duration(days: itinerary.dayPlans.length));
    final groupSize = itinerary.numberOfPeople;
    
    // Calculate costs as integers
    final flightCost = itinerary.suggestedFlightCost;
    final hotelCost = itinerary.suggestedHotelCostPerNight;
    final cabCost = itinerary.suggestedCabCostPerDay;

    if (type == 'flight') {
      String from = '';
      String to = destination;
      DateTime? depart = startDate;
      int people = groupSize;
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 20, right: 20, top: 24,
            ),
            child: StatefulBuilder(
              builder: (context, setState) => SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Book Flight (Budget: ${CurrencyService.formatAmount(flightCost)})', style: CommonStyles.bookingTitle(context)),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(labelText: 'From'),
                      controller: TextEditingController(text: from),
                      onChanged: (v) => from = v,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(labelText: 'To'),
                      controller: TextEditingController(text: to),
                      onChanged: (v) => to = v,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Departure: '),
                        Text(depart != null ? '${depart!.day}/${depart!.month}/${depart!.year}' : 'Select'),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: depart ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) setState(() => depart = picked);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('People: '),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => setState(() => people = people > 1 ? people - 1 : 1),
                        ),
                        Text('$people'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => people++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showDummyFlightResults(context, from, to, depart, people, flightCost);
                        },
                        child: const Text('Show Flights'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (type == 'hotel') {
      String city = destination;
      DateTime? checkin = startDate;
      DateTime? checkout = endDate;
      int people = groupSize;
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 20, right: 20, top: 24,
            ),
            child: StatefulBuilder(
              builder: (context, setState) => SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Book Hotel (Budget: ${CurrencyService.formatAmount(hotelCost)} per night)', style: CommonStyles.bookingTitle(context)),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(labelText: 'City'),
                      controller: TextEditingController(text: city),
                      onChanged: (v) => city = v,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Check-in: '),
                        Text(checkin != null ? '${checkin!.day}/${checkin!.month}/${checkin!.year}' : 'Select'),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: checkin ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) setState(() => checkin = picked);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Check-out: '),
                        Text(checkout != null ? '${checkout!.day}/${checkout!.month}/${checkout!.year}' : 'Select'),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: checkin ?? DateTime.now(),
                              firstDate: checkin ?? DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 366)),
                            );
                            if (picked != null) setState(() => checkout = picked);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('People: '),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => setState(() => people = people > 1 ? people - 1 : 1),
                        ),
                        Text('$people'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => people++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showDummyHotelResults(context, city, checkin, checkout, people, hotelCost);
                        },
                        child: const Text('Show Hotels'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (type == 'cab') {
      String from = '';
      String to = destination;
      DateTime? date = startDate;
      int people = groupSize;
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 20, right: 20, top: 24,
            ),
            child: StatefulBuilder(
              builder: (context, setState) => SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Book Cab (Budget: ${CurrencyService.formatAmount(cabCost)} per day)', style: CommonStyles.bookingTitle(context)),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(labelText: 'From'),
                      controller: TextEditingController(text: from),
                      onChanged: (v) => from = v,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(labelText: 'To'),
                      controller: TextEditingController(text: to),
                      onChanged: (v) => to = v,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Date: '),
                        Text(date != null ? '${date!.day}/${date!.month}/${date!.year}' : 'Select'),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: date ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) setState(() => date = picked);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('People: '),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => setState(() => people = people > 1 ? people - 1 : 1),
                        ),
                        Text('$people'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => people++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showDummyCabResults(context, from, to, date, people, cabCost);
                        },
                        child: const Text('Show Cabs'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void _showDummyFlightResults(BuildContext context, String from, String to, DateTime? depart, int people, double budget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Flights (Dummy - Skyscanner, Budget ≤ ${CurrencyService.formatAmount(budget)})', style: CommonStyles.sectionTitle(context)),
            const SizedBox(height: 12),
            ...List.generate(3, (i) {
              final price = 4000 + i * 1200;
              if (price > budget) return const SizedBox.shrink();
              return ListTile(
                leading: const Icon(Icons.flight_takeoff),
                title: Text('Flight ${i + 1}: $from → $to'),
                subtitle: Text('Date: ${depart != null ? '${depart.day}/${depart.month}/${depart.year}' : '-'} | ${CurrencyService.formatAmount(price)} | $people people'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Flight booked! (dummy)')));
                  },
                  child: const Text('Book'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showDummyHotelResults(BuildContext context, String city, DateTime? checkin, DateTime? checkout, int people, double budget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Hotels (Dummy, Budget ≤ ${CurrencyService.formatAmount(budget)})', style: CommonStyles.sectionTitle(context)),
            const SizedBox(height: 12),
            ...List.generate(3, (i) {
              final price = 2000 + i * 800;
              if (price > budget) return const SizedBox.shrink();
              return ListTile(
                leading: const Icon(Icons.hotel),
                title: Text('Hotel ${i + 1} in $city'),
                subtitle: Text('Check-in: ${checkin != null ? '${checkin.day}/${checkin.month}/${checkin.year}' : '-'} | Check-out: ${checkout != null ? '${checkout.day}/${checkout.month}/${checkout.year}' : '-'} | ${CurrencyService.formatAmount(price)} | $people people'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hotel booked! (dummy)')));
                  },
                  child: const Text('Book'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showDummyCabResults(BuildContext context, String from, String to, DateTime? date, int people, double budget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Cabs (Dummy, Budget ≤ ${CurrencyService.formatAmount(budget)})', style: CommonStyles.sectionTitle(context)),
            const SizedBox(height: 12),
            ...List.generate(3, (i) {
              final price = 800 + i * 300;
              if (price > budget) return const SizedBox.shrink();
              return ListTile(
                leading: const Icon(Icons.local_taxi),
                title: Text('Cab ${i + 1}: $from → $to'),
                subtitle: Text('Date: ${date != null ? '${date.day}/${date.month}/${date.year}' : '-'} | ${CurrencyService.formatAmount(price)} | $people people'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cab booked! (dummy)')));
                  },
                  child: const Text('Book'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _generateMockItineraries() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    
    final hotelNames = {
      "Goa": ["Taj Resort & Spa", "Marriott Beach Resort", "Grand Hyatt"],
      "Manali": ["The Himalayan", "Apple Country Resort", "Royal Palace"],
      "Kerala": ["Kumarakom Lake Resort", "Taj Malabar", "Le Meridien"],
      "Jaipur": ["Rambagh Palace", "Taj Jai Mahal", "ITC Rajputana"],
      "Ladakh": ["The Grand Dragon", "Ladakh Sarai", "The Zen"],
    };

    final localAttractions = {
      "Goa": ["Calangute Beach", "Basilica of Bom Jesus", "Fort Aguada", "Anjuna Flea Market"],
      "Manali": ["Rohtang Pass", "Hadimba Temple", "Solang Valley", "Mall Road"],
      "Kerala": ["Alleppey Backwaters", "Munnar Tea Gardens", "Varkala Beach", "Fort Kochi"],
      "Jaipur": ["Amber Fort", "Hawa Mahal", "City Palace", "Jantar Mantar"],
      "Ladakh": ["Pangong Lake", "Leh Palace", "Nubra Valley", "Shanti Stupa"],
    };

    // Mock data for 3-5 itineraries
    _suggestedItineraries = List.generate(4, (i) {
      final destinations = ["Goa", "Manali", "Kerala", "Jaipur", "Ladakh"];
      final destination = destinations[i % destinations.length];
      final likes = 50 + i * 17;
      final totalCost = (40000 + i * 8000).toDouble();
      final startDate = DateTime.now().add(Duration(days: i * 3));
      
      // Calculate costs as integers
      final flightCost = (totalCost * 0.4).round();
      final hotelCostPerNight = (totalCost * 0.4 / 5).round();
      final cabCostPerDay = (totalCost * 0.2 / 5).round();
      
      final hotels = hotelNames[destination] ?? ["Local Hotel"];
      final attractions = localAttractions[destination] ?? ["Local Attraction"];

      final reviews = [
        {"user": "Aditi S.", "review": "Amazing trip! Well planned.", "avatar": "https://randomuser.me/api/portraits/women/44.jpg"},
        {"user": "Rahul V.", "review": "Loved the activities!", "avatar": "https://randomuser.me/api/portraits/men/32.jpg"},
      ];

      final health = [
        "Stay hydrated, especially in summer.",
        "Carry sunscreen and a hat.",
        if (destination == "Ladakh") "Beware of altitude sickness. Acclimatize properly.",
      ];

      final sustainability = [
        "Support local businesses.",
        "Avoid single-use plastics.",
        "Respect local culture and wildlife.",
      ];

      final wellBeing = [
        "Take regular breaks.",
        "Eat healthy local food.",
        "Get enough sleep.",
      ];

      final days = List.generate(5, (d) {
        final currentDate = startDate.add(Duration(days: d));
        if (d == 0) {
          // First day - arrival and check-in
          return {
            "day": d + 1,
            "date": currentDate.toIso8601String(),
            "flight": {
              "from": "Mumbai",
              "to": destination,
              "time": "09:00 AM",
              "airline": "IndiGo",
              "cost": flightCost,
            },
            "hotel": {
              "name": hotels[0],
              "checkIn": "02:00 PM",
              "cost": hotelCostPerNight,
            },
            "cab": {
              "from": "$destination Airport",
              "to": hotels[0],
              "type": "SUV",
              "cost": (cabCostPerDay * 0.3).round(),
            },
            "activities": [
              "Airport Transfer",
              "Hotel Check-in",
              "Evening: ${attractions[0]} visit",
            ],
            "totalCost": flightCost + hotelCostPerNight + (cabCostPerDay * 0.3).round(),
          };
        } else if (d == 4) {
          // Last day - checkout and departure
          return {
            "day": d + 1,
            "date": currentDate.toIso8601String(),
            "hotel": {
              "name": hotels[0],
              "checkOut": "11:00 AM",
              "cost": hotelCostPerNight,
            },
            "cab": {
              "from": hotels[0],
              "to": "$destination Airport",
              "type": "SUV",
              "cost": (cabCostPerDay * 0.3).round(),
            },
            "flight": {
              "from": destination,
              "to": "Mumbai",
              "time": "06:00 PM",
              "airline": "IndiGo",
              "cost": flightCost,
            },
            "activities": [
              "Morning: ${attractions[3]} visit",
              "Hotel Check-out",
              "Airport Transfer",
            ],
            "totalCost": flightCost + hotelCostPerNight + (cabCostPerDay * 0.3).round(),
          };
        } else {
          // Middle days - local activities
          return {
            "day": d + 1,
            "date": currentDate.toIso8601String(),
            "hotel": {
              "name": hotels[0],
              "cost": hotelCostPerNight,
            },
            "cab": {
              "type": "SUV",
              "duration": "Full Day",
              "cost": cabCostPerDay,
            },
            "activities": [
              "Morning: ${attractions[d]} exploration",
              "Afternoon: Local cuisine experience",
              "Evening: Cultural show/Local entertainment",
            ],
            "totalCost": hotelCostPerNight + cabCostPerDay,
          };
        }
      });

      return {
        "itinerary": {
          "id": 'dummy_${i}',
          "destination": destination,
          "startDate": startDate.toIso8601String(),
          "days": days,
          "totalCost": totalCost,
          "groupSize": 2 + i,
          "travelType": "Leisure",
          "images": [
            "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
            "https://images.unsplash.com/photo-1512100356356-de1b84283e18"
          ]
        },
        "likes": likes,
        "reviews": reviews,
        "health": health,
        "sustainability": sustainability,
        "wellBeing": wellBeing,
      };
    });
    
    setState(() => _isLoading = false);
  }

  // Add new method to generate mock social feed data
  void _generateMockSocialFeed() {
    _stories.addAll([
      TravelStory(
        username: "sarah_travels",
        userAvatar: "https://randomuser.me/api/portraits/women/1.jpg",
        location: "Bali, Indonesia",
        imageUrl: "https://images.unsplash.com/photo-1537996194471-e657df975ab4",
        isViewed: false,
      ),
      TravelStory(
        username: "mike_explorer",
        userAvatar: "https://randomuser.me/api/portraits/men/2.jpg",
        location: "Santorini, Greece",
        imageUrl: "https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff",
        isViewed: false,
      ),
      // Add more stories...
    ]);

    _socialFeed.addAll([
      TravelPost(
        username: "travel_enthusiast",
        userAvatar: "https://randomuser.me/api/portraits/women/3.jpg",
        location: "Machu Picchu, Peru",
        imageUrl: "https://images.unsplash.com/photo-1587595431973-160d0d94add1",
        caption: "Finally made it to this wonder of the world! The view is breathtaking 😍 #MachuPicchu #Peru #Travel",
        likes: 1234,
        comments: 89,
        timeAgo: "2 hours ago",
      ),
      TravelPost(
        username: "wanderlust_diaries",
        userAvatar: "https://randomuser.me/api/portraits/men/4.jpg",
        location: "Venice, Italy",
        imageUrl: "https://images.unsplash.com/photo-1523906834658-6e24ef2386f9",
        caption: "Getting lost in the beautiful streets of Venice 🇮🇹 #Venice #Italy #TravelLife",
        likes: 2567,
        comments: 156,
        timeAgo: "5 hours ago",
      ),
      // Add more posts...
    ]);
  }

  // Add new widget to build stories section
  Widget _buildStoriesSection() {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _stories.length + 1, // +1 for "Your Story"
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildStoryItem(
              "Your Story",
              "https://randomuser.me/api/portraits/lego/1.jpg",
              "",
              true,
              isAdd: true,
            );
          }
          final story = _stories[index - 1];
          return _buildStoryItem(
            story.username,
            story.userAvatar,
            story.location,
            story.isViewed,
          );
        },
      ),
    );
  }

  Widget _buildStoryItem(String username, String avatar, String location, bool viewed, {bool isAdd = false}) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: !viewed ? LinearGradient(
                    colors: [Colors.purple, Colors.pink, Colors.orange],
                  ) : null,
                  border: viewed ? Border.all(color: Colors.grey, width: 2) : null,
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(avatar),
                ),
              ),
              if (isAdd)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            username.length > 10 ? '${username.substring(0, 8)}...' : username,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: viewed ? FontWeight.normal : FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Add new widget to build social feed posts
  Widget _buildSocialFeedPost(TravelPost post) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF23243B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(post.userAvatar)),
            title: Text(post.username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(post.location, style: const TextStyle(color: Colors.white70)),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              // Handle double tap to like
            },
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(post.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_outlined, color: Colors.white),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${post.likes} likes', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: post.username,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' ${post.caption}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'View all ${post.comments} comments',
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        post.timeAgo,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryCardWithExtras(
    Itinerary itinerary, {
    required int likes,
    required List reviews,
    required List health,
    required List sustainability,
    required List wellBeing,
  }) {
    final dayPlans = itinerary.dayPlans;
    final highlights = dayPlans.expand((d) => d.activities.map((a) => a.name)).toSet().take(4).toList();
    final perPerson = (itinerary.totalCost / itinerary.numberOfPeople).round();
    return StatefulBuilder(
      builder: (context, setState) => Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          child: Card(
            elevation: 16,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            color: const Color(0xFF23243B),
            shadowColor: Colors.black.withOpacity(0.4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Container(
                width: 390,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                  color: const Color(0xFF23243B),
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${itinerary.destination} · ${dayPlans.length} Days · ${itinerary.numberOfPeople} People',
                              style: CommonStyles.itineraryHeading(context),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.favorite, color: Colors.pinkAccent.shade100, size: 22),
                              const SizedBox(width: 4),
                              Text('$likes', style: CommonStyles.itineraryDetails(context)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20, color: Colors.tealAccent.shade100),
                          const SizedBox(width: 8),
                          Text('Start: ${itinerary.startDate.day}/${itinerary.startDate.month}/${itinerary.startDate.year}', style: CommonStyles.itineraryDetails(context)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text('Budget Summary', style: CommonStyles.itineraryHighlight(context)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            _getCurrencyIcon(),
                            color: Colors.greenAccent.shade400
                          ),
                          Text('Total: ${CurrencyService.formatAmount(itinerary.totalCost)}', style: CommonStyles.itineraryDetails(context)),
                          const SizedBox(width: 12),
                          Icon(Icons.person, color: Colors.white54),
                          Text('Per Person: ${CurrencyService.formatAmount(itinerary.totalCost / itinerary.numberOfPeople)}', style: CommonStyles.itineraryDetails(context)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text('Highlights', style: CommonStyles.itineraryHighlight(context)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 10,
                        children: highlights.map((h) => Chip(
                          label: Text(h, style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.white.withOpacity(0.12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: BorderSide(color: Colors.white.withOpacity(0.08)),
                          elevation: 0,
                        )).toList(),
                      ),
                      const SizedBox(height: 18),
                      Text('Plan Overview', style: CommonStyles.itineraryOverview(context)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 280,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: dayPlans.length,
                          onPageChanged: (idx) => setState(() => _currentDay = idx),
                          itemBuilder: (context, idx) {
                            final d = dayPlans[idx];
                            return AnimatedScale(
                              scale: idx == _currentDay ? 1.0 : 0.95,
                              duration: const Duration(milliseconds: 250),
                              child: AnimatedOpacity(
                                opacity: idx == _currentDay ? 1.0 : 0.7,
                                duration: const Duration(milliseconds: 250),
                                child: Card(
                                  color: const Color(0xFF181A20),
                                  elevation: idx == _currentDay ? 10 : 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.today, size: 22, color: Colors.white),
                                            const SizedBox(width: 10),
                                            Text('Day ${d.date.day}/${d.date.month}/${d.date.year}', style: CommonStyles.itineraryDayTitle(context)),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        if (d.flight != null) ...[
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.flight,
                                                size: 18,
                                                color: Theme.of(context).colorScheme.iconPrimary,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  '${d.flight!.airline} - ${d.flight!.from} to ${d.flight!.to} (${d.flight!.time})\n${CurrencyService.formatAmount(d.flight!.cost)}',
                                                  style: CommonStyles.itineraryDayDetails(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                        if (d.hotel != null) ...[
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.hotel,
                                                size: 18,
                                                color: Theme.of(context).colorScheme.iconPrimary,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  '${d.hotel!.name} ${d.hotel!.checkIn != null ? '(Check-in: ${d.hotel!.checkIn})' : d.hotel!.checkOut != null ? '(Check-out: ${d.hotel!.checkOut})' : ''}\n${CurrencyService.formatAmount(d.hotel!.costPerNight)} per night',
                                                  style: CommonStyles.itineraryDayDetails(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                        if (d.cab != null) ...[
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.local_taxi,
                                                size: 18,
                                                color: Theme.of(context).colorScheme.iconPrimary,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  d.cab!.duration != null
                                                      ? '${d.cab!.type} - ${d.cab!.duration}\n${CurrencyService.formatAmount(d.cab!.cost)}'
                                                      : '${d.cab!.type} - ${d.cab!.from} to ${d.cab!.to}\n${CurrencyService.formatAmount(d.cab!.cost)}',
                                                  style: CommonStyles.itineraryDayDetails(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                        const Divider(color: Colors.white24),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Activities:',
                                          style: TextStyle(fontSize: 14, color: Colors.tealAccent.shade100, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 4),
                                        ...List.generate(
                                          d.activities.length,
                                          (i) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 2),
                                            child: Row(
                                              children: [
                                                Icon(Icons.circle, size: 6, color: Colors.tealAccent.shade100),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    d.activities[i].name,
                                                    style: CommonStyles.itineraryDayDetails(context),
                                                  ),
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
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            dayPlans.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _currentDay
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Reviews
                      Text('Reviews', style: CommonStyles.itineraryHighlight(context)),
                      const SizedBox(height: 6),
                      ...reviews.map<Widget>((r) => ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(r['avatar'])),
                        title: Text(r['user'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text(r['review'], style: CommonStyles.itineraryDayDetails(context)),
                      )),
                      const SizedBox(height: 14),
                      // Health, Sustainability, Well-being
                      Text('Health Precautions', style: CommonStyles.itinerarySubheading(context)),
                      ...health.map<Widget>((h) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2),
                        child: Row(
                          children: [
                            Icon(Icons.health_and_safety, color: Colors.redAccent.shade100, size: 18),
                            const SizedBox(width: 6),
                            Expanded(child: Text(h, style: CommonStyles.itineraryDayDetails(context))),
                          ],
                        ),
                      )).toList(),
                      const SizedBox(height: 8),
                      Text('Sustainability', style: CommonStyles.itinerarySubheading(context)),
                      ...sustainability.map<Widget>((s) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2),
                        child: Row(
                          children: [
                            Icon(Icons.eco, color: Colors.greenAccent.shade100, size: 18),
                            const SizedBox(width: 6),
                            Expanded(child: Text(s, style: CommonStyles.itineraryDayDetails(context))),
                          ],
                        ),
                      )).toList(),
                      const SizedBox(height: 8),
                      Text('Well-being', style: CommonStyles.itinerarySubheading(context)),
                      ...wellBeing.map<Widget>((w) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2),
                        child: Row(
                          children: [
                            Icon(Icons.self_improvement, size: 18, color: Theme.of(context).colorScheme.iconPrimary),
                            const SizedBox(width: 6),
                            Expanded(child: Text(w, style: CommonStyles.itineraryDayDetails(context))),
                          ],
                        ),
                      )).toList(),
                      const SizedBox(height: 18),
                      // Booking buttons
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildBookingButton(
                              icon: Icons.flight,
                              label: 'Book Flight',
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () => _showBookingSheet(context, 'flight', itinerary),
                            ),
                            const SizedBox(width: 10),
                            _buildBookingButton(
                              icon: Icons.hotel,
                              label: 'Book Hotel',
                              color: Colors.purpleAccent.shade400,
                              onPressed: () => _showBookingSheet(context, 'hotel', itinerary),
                            ),
                            const SizedBox(width: 10),
                            _buildBookingButton(
                              icon: Icons.local_taxi,
                              label: 'Book Cab',
                              color: Colors.tealAccent.shade400,
                              textColor: Colors.black,
                              onPressed: () => _showBookingSheet(context, 'cab', itinerary),
                            ),
                            const SizedBox(width: 10),
                            _buildBookingButton(
                              icon: Icons.event_available,
                              label: 'Book Activities',
                              color: Colors.orangeAccent.shade200,
                              textColor: Colors.black,
                              onPressed: () => _showBookingSheet(context, 'activities', itinerary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingButton({
    required IconData icon,
    required String label,
    required Color color,
    Color? textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: label == 'Book Activities' ? 160 : 140,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          elevation: 0,
        ),
        onPressed: onPressed,
      ),
    );
  }

  IconData _getCurrencyIcon() {
    return Icons.currency_rupee;  // Default to INR, can be made dynamic based on currency
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Stories section
                _buildStoriesSection(),
                
                // Main content
                Expanded(
                  child: _isLoading
                    ? Center(
                        child: SpinKitPulse(
                          color: Theme.of(context).colorScheme.primary,
                          size: 50.0,
                        ),
                      )
                    : ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // Social feed posts
                          ..._socialFeed.map((post) => _buildSocialFeedPost(post)),
                          
                          // Suggested itineraries
                          ..._suggestedItineraries.map((item) {
                            final itinerary = item['itinerary'];
                            return _buildItineraryCardWithExtras(
                              itinerary,
                              likes: item['likes'],
                              reviews: item['reviews'],
                              health: item['health'],
                              sustainability: item['sustainability'],
                              wellBeing: item['wellBeing'],
                            );
                          }),
                        ],
                      ),
                ),
              ],
            ),
            
            // Chat overlay
            if (_isChatOpen)
              SlideTransition(
                position: _slideAnimation!,
                child: Container(
                  color: const Color(0xFF181A20),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            return Align(
                              alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: message.isUser ? Theme.of(context).colorScheme.primary : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  message.text,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                filled: true,
                                fillColor: Colors.grey[800],
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
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
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleChat,
        child: Icon(_isChatOpen ? Icons.close : Icons.chat),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1,  // My trips tab
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}

// Add new classes for social feed data models
class TravelStory {
  final String username;
  final String userAvatar;
  final String location;
  final String imageUrl;
  final bool isViewed;

  TravelStory({
    required this.username,
    required this.userAvatar,
    required this.location,
    required this.imageUrl,
    required this.isViewed,
  });
}

class TravelPost {
  final String username;
  final String userAvatar;
  final String location;
  final String imageUrl;
  final String caption;
  final int likes;
  final int comments;
  final String timeAgo;

  TravelPost({
    required this.username,
    required this.userAvatar,
    required this.location,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.timeAgo,
  });
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
} 