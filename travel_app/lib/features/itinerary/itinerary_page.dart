import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../models/itinerary.dart';
import '../../services/itinerary_service.dart';
import '../../core/widgets/nav_bar.dart';

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
  final List<ChatMessage> _messages = [];
  List<Map<String, dynamic>> _suggestedItineraries = [];
  String? _userQuery;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _addBotMessage("Hi! I'm your travel planning assistant. Where would you like to go?");
    _generateMockItineraries();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
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
    final endDate = itinerary.startDate.add(Duration(days: itinerary.days.length));
    final groupSize = itinerary.groupSize;
    final totalBudget = itinerary.totalCost;
    final flightBudget = (totalBudget * 0.4).round();
    final hotelBudget = (totalBudget * 0.4).round();
    final cabBudget = (totalBudget * 0.2).round();

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
                    const Text('Book Flight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                          _showDummyFlightResults(context, from, to, depart, people, flightBudget);
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
                    const Text('Book Hotel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                          _showDummyHotelResults(context, city, checkin, checkout, people, hotelBudget);
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
                    const Text('Book Cab', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                          _showDummyCabResults(context, from, to, date, people, cabBudget);
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

  void _showDummyFlightResults(BuildContext context, String from, String to, DateTime? depart, int people, int budget) {
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
            Text('Available Flights (Dummy - Skyscanner, Budget ≤ ₹$budget)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            ...List.generate(3, (i) {
              final price = 4000 + i * 1200;
              if (price > budget) return const SizedBox.shrink();
              return ListTile(
                leading: const Icon(Icons.flight_takeoff),
                title: Text('Flight ${i + 1}: $from → $to'),
                subtitle: Text('Date: ${depart != null ? '${depart.day}/${depart.month}/${depart.year}' : '-'} | ₹$price | $people people'),
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

  void _showDummyHotelResults(BuildContext context, String city, DateTime? checkin, DateTime? checkout, int people, int budget) {
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
            Text('Available Hotels (Dummy, Budget ≤ ₹$budget)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            ...List.generate(3, (i) {
              final price = 2000 + i * 800;
              if (price > budget) return const SizedBox.shrink();
              return ListTile(
                leading: const Icon(Icons.hotel),
                title: Text('Hotel ${i + 1} in $city'),
                subtitle: Text('Check-in: ${checkin != null ? '${checkin.day}/${checkin.month}/${checkin.year}' : '-'} | Check-out: ${checkout != null ? '${checkout.day}/${checkout.month}/${checkout.year}' : '-'} | ₹$price | $people people'),
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

  void _showDummyCabResults(BuildContext context, String from, String to, DateTime? date, int people, int budget) {
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
            Text('Available Cabs (Dummy, Budget ≤ ₹$budget)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            ...List.generate(3, (i) {
              final price = 800 + i * 300;
              if (price > budget) return const SizedBox.shrink();
              return ListTile(
                leading: const Icon(Icons.local_taxi),
                title: Text('Cab ${i + 1}: $from → $to'),
                subtitle: Text('Date: ${date != null ? '${date.day}/${date.month}/${date.year}' : '-'} | ₹$price | $people people'),
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
    // Mock data for 3-5 itineraries
    _suggestedItineraries = List.generate(4, (i) {
      final destinations = ["Goa", "Manali", "Kerala", "Jaipur", "Ladakh"];
      final destination = destinations[i % destinations.length];
      final likes = 50 + i * 17;
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
      return {
        "itinerary": Itinerary(
          destination: destination,
          days: List.generate(5, (d) => {
            "day": d + 1,
            "activities": [
              "Activity ${d + 1}A in $destination",
              "Activity ${d + 1}B in $destination",
            ],
          }),
          totalCost: 40000 + i * 8000,
          travelType: "Leisure",
          groupSize: 2 + i,
          startDate: DateTime.now().add(Duration(days: i * 3)),
        ),
        "likes": likes,
        "reviews": reviews,
        "health": health,
        "sustainability": sustainability,
        "wellBeing": wellBeing,
      };
    });
    setState(() => _isLoading = false);
  }

  Widget _buildItineraryCardWithExtras(
    Itinerary itinerary, {
    required int likes,
    required List reviews,
    required List health,
    required List sustainability,
    required List wellBeing,
  }) {
    final days = itinerary.days;
    final highlights = days.expand((d) => d['activities'] as List).toSet().take(4).toList();
    final perPerson = (itinerary.totalCost / itinerary.groupSize).round();
    final PageController _pageController = PageController(viewportFraction: 0.88);
    int _currentDay = 0;
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
                              '${itinerary.destination} · ${days.length} Days · ${itinerary.groupSize} People',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.favorite, color: Colors.pinkAccent.shade100, size: 22),
                              const SizedBox(width: 4),
                              Text('$likes', style: const TextStyle(color: Colors.white, fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20, color: Colors.tealAccent.shade100),
                          const SizedBox(width: 8),
                          Text('Start: ${itinerary.startDate.day}/${itinerary.startDate.month}/${itinerary.startDate.year}', style: const TextStyle(fontSize: 15, color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text('Budget Summary', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontSize: 16)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.currency_rupee, color: Colors.greenAccent.shade400),
                          Text('Total: ₹${itinerary.totalCost.round()}  ', style: const TextStyle(fontSize: 16, color: Colors.white)),
                          const SizedBox(width: 12),
                          Icon(Icons.person, color: Colors.white54),
                          Text('Per Person: ₹$perPerson', style: const TextStyle(fontSize: 16, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text('Highlights', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent.shade100, fontSize: 16)),
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
                      Text('Plan Overview', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 16)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 200,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: days.length,
                          onPageChanged: (idx) => setState(() => _currentDay = idx),
                          itemBuilder: (context, idx) {
                            final d = days[idx];
                            return AnimatedScale(
                              scale: idx == _currentDay ? 1.0 : 0.95,
                              duration: const Duration(milliseconds: 250),
                              child: AnimatedOpacity(
                                opacity: idx == _currentDay ? 1.0 : 0.7,
                                duration: const Duration(milliseconds: 250),
                                child: Card(
                                  color: const Color(0xFF181A20),
                                  elevation: idx == _currentDay ? 10 : 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.today, size: 22, color: Colors.white),
                                            const SizedBox(width: 10),
                                            Text('Day ${d['day']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          (d['activities'] as List).join(', '),
                                          style: const TextStyle(fontSize: 16, color: Colors.white70),
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
                            days.length,
                            (idx) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: idx == _currentDay ? 14 : 8,
                              height: idx == _currentDay ? 14 : 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: idx == _currentDay ? Theme.of(context).colorScheme.primary : Colors.white24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Reviews
                      Text('Reviews', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent.shade100, fontSize: 16)),
                      const SizedBox(height: 6),
                      ...reviews.map<Widget>((r) => ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(r['avatar'])),
                        title: Text(r['user'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text(r['review'], style: const TextStyle(color: Colors.white70)),
                      )),
                      const SizedBox(height: 14),
                      // Health, Sustainability, Well-being
                      Text('Health Precautions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent.shade100, fontSize: 15)),
                      ...health.map<Widget>((h) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2),
                        child: Row(children: [Icon(Icons.health_and_safety, color: Colors.redAccent.shade100, size: 18), const SizedBox(width: 6), Expanded(child: Text(h, style: const TextStyle(color: Colors.white70, fontSize: 13)))]),
                      )),
                      const SizedBox(height: 8),
                      Text('Sustainability', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent.shade100, fontSize: 15)),
                      ...sustainability.map<Widget>((s) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2),
                        child: Row(children: [Icon(Icons.eco, color: Colors.greenAccent.shade100, size: 18), const SizedBox(width: 6), Expanded(child: Text(s, style: const TextStyle(color: Colors.white70, fontSize: 13)))]),
                      )),
                      const SizedBox(height: 8),
                      Text('Well-being', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent.shade100, fontSize: 15)),
                      ...wellBeing.map<Widget>((w) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2),
                        child: Row(children: [Icon(Icons.self_improvement, color: Colors.blueAccent.shade100, size: 18), const SizedBox(width: 6), Expanded(child: Text(w, style: const TextStyle(color: Colors.white70, fontSize: 13)))]),
                      )),
                      const SizedBox(height: 18),
                      // Booking buttons
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 140,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.flight),
                                label: const Text('Book Flight'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                  elevation: 0,
                                ),
                                onPressed: () => _showBookingSheet(context, 'flight', itinerary),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 140,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.hotel),
                                label: const Text('Book Hotel'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purpleAccent.shade400,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                  elevation: 0,
                                ),
                                onPressed: () => _showBookingSheet(context, 'hotel', itinerary),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 140,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.local_taxi),
                                label: const Text('Book Cab'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.tealAccent.shade400,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                  elevation: 0,
                                ),
                                onPressed: () => _showBookingSheet(context, 'cab', itinerary),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 160,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.event_available),
                                label: const Text('Book Activities'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent.shade200,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                  elevation: 0,
                                ),
                                onPressed: () => _showBookingSheet(context, 'activities', itinerary),
                              ),
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

  @override
  Widget build(BuildContext context) {
    final List<String> suggestions = [
      "Plan a trip to Goa for 4 people in December",
      "Suggest a 5-day adventure in Manali for 2 friends",
      "What's the best time to visit Kerala?",
      "I want a cultural trip to Jaipur for 6 people",
      "Plan a budget trip to Ladakh for 7 days",
    ];
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade300,
              Colors.purple.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "AI-Suggested Itineraries",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 28),
                    color: Theme.of(context).colorScheme.primary,
                    tooltip: "Refresh suggestions",
                    onPressed: _generateMockItineraries,
                  ),
                ],
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        itemCount: _suggestedItineraries.length,
                        itemBuilder: (context, idx) {
                          final data = _suggestedItineraries[idx];
                          final itinerary = data["itinerary"] as Itinerary;
                          final likes = data["likes"] as int;
                          final reviews = data["reviews"] as List;
                          final health = data["health"] as List;
                          final sustainability = data["sustainability"] as List;
                          final wellBeing = data["wellBeing"] as List;
                          return _buildItineraryCardWithExtras(
                            itinerary,
                            likes: likes,
                            reviews: reviews,
                            health: health,
                            sustainability: sustainability,
                            wellBeing: wellBeing,
                          );
                        },
                      ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              if (_suggestedItineraries.isEmpty) ...[
                // Suggestions section
                Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Suggestions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: suggestions.map((prompt) => ActionChip(
                          label: Text(prompt, style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.white.withOpacity(0.10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.25)),
                          onPressed: () {
                            _messageController.text = prompt;
                            _processUserMessage(prompt);
                          },
                        )).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Tip: You can ask for a trip by destination, group size, days, season, or travel style!",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                          ),
                          onSubmitted: (message) {
                            if (message.isNotEmpty) {
                              _processUserMessage(message);
                              _messageController.clear();
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          final message = _messageController.text;
                          if (message.isNotEmpty) {
                            _processUserMessage(message);
                            _messageController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
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