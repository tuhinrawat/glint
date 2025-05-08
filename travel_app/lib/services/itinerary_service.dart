import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:travel_app/models/itinerary.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ItineraryService {
  final FlutterSecureStorage _storage;
  
  ItineraryService._({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static final ItineraryService _instance = ItineraryService._(storage: const FlutterSecureStorage());
  
  factory ItineraryService({FlutterSecureStorage? storage}) {
    if (storage != null) {
      return ItineraryService._(storage: storage);
    }
    return _instance;
  }

  // Popular destinations with their characteristics
  final Map<String, Map<String, dynamic>> _popularDestinations = {
    'Goa': {
      'subtitle': 'Beaches & Nightlife',
      'image': 'https://images.unsplash.com/photo-1587922546307-776227941871',
      'budget': 35000.0,
      'activities': [
        'Calangute Beach',
        'Basilica of Bom Jesus',
        'Fort Aguada',
        'Anjuna Flea Market',
        'Dudhsagar Falls',
        'Casino Night',
        'Water Sports',
        'Spice Plantation'
      ],
    },
    'Manali': {
      'subtitle': 'Mountains & Adventure',
      'image': 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23',
      'budget': 40000.0,
      'activities': [
        'Rohtang Pass',
        'Solang Valley',
        'Hadimba Temple',
        'Mall Road',
        'River Rafting',
        'Skiing',
        'Hot Springs',
        'Buddhist Monasteries'
      ],
    },
    'Kerala': {
      'subtitle': 'Backwaters & Culture',
      'image': 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944',
      'budget': 45000.0,
      'activities': [
        'Alleppey Backwaters',
        'Munnar Tea Gardens',
        'Varkala Beach',
        'Fort Kochi',
        'Ayurvedic Spa',
        'Kathakali Show',
        'Spice Market Tour',
        'Wildlife Sanctuary'
      ],
    },
    'Ladakh': {
      'subtitle': 'High Altitude & Serenity',
      'image': 'https://images.unsplash.com/photo-1589556264800-08294b7d5337',
      'budget': 50000.0,
      'activities': [
        'Pangong Lake',
        'Nubra Valley',
        'Khardung La',
        'Shanti Stupa',
        'Hemis Monastery',
        'Magnetic Hill',
        'Camel Safari',
        'Local Market'
      ],
    },
  };

  Future<List<Map<String, dynamic>>> getRecommendedItineraries() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    final recommendations = <Map<String, dynamic>>[];
    
    for (var entry in _popularDestinations.entries) {
      final destination = entry.key;
      final details = entry.value;
      
      final startDate = DateTime.now().add(Duration(days: recommendations.length * 5 + 7));
      final itinerary = await generateItinerary(
        destination: destination,
        budget: details['budget'],
        travelType: 'leisure',
        groupSize: 2 + recommendations.length,
        startDate: startDate,
      );

      recommendations.add({
        "itinerary": itinerary.toJson(),
        "personalized_tips": [
          "Perfect for first-time visitors to ${destination}",
          "Curated activities based on traveler favorites",
          "Balanced mix of popular spots and hidden gems",
          details['activities'].take(3).map((activity) => "Don't miss: $activity").join("\n"),
        ],
        "health": [
          "Stay hydrated, especially during ${_getSeasonForDate(startDate)}",
          "Local emergency contacts provided in the app",
          if (details['altitude'] != null) "Acclimatize properly to the altitude",
          "Recommended vaccinations and health precautions",
        ],
        "sustainability": [
          "Support local businesses and communities",
          "Follow responsible tourism guidelines",
          "Minimize environmental impact",
          "Respect local customs and traditions",
        ],
        "wellBeing": [
          "Balanced itinerary with rest periods",
          "Options for dietary preferences",
          "24/7 support through the app",
          "Flexible schedule adjustments",
        ],
        "estimated_savings": "${(details['budget'] * 0.2).round()}₹ compared to booking separately",
      });
    }
    
    return recommendations;
  }

  String _getSeasonForDate(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return "spring";
    if (month >= 6 && month <= 8) return "summer";
    if (month >= 9 && month <= 11) return "autumn";
    return "winter";
  }

  Future<Itinerary> generateItinerary({
    required String destination,
    required double budget,
    required String travelType,
    required int groupSize,
    required DateTime startDate,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock itinerary generation
    final dayPlans = List.generate(5, (d) {
      final date = startDate.add(Duration(days: d));
      return DayPlan(
        day: d + 1,
        date: date,
        activities: [
          Activity(
            name: "Activity ${d + 1}A in $destination",
            description: "Description for activity ${d + 1}A",
            cost: (budget * 0.1).roundToDouble(),
            startTime: TimeOfDay(hour: 9, minute: 0),
            endTime: TimeOfDay(hour: 12, minute: 0),
            location: destination,
            tags: ["morning", "leisure"],
          ),
          Activity(
            name: "Activity ${d + 1}B in $destination",
            description: "Description for activity ${d + 1}B",
            cost: (budget * 0.1).roundToDouble(),
            startTime: TimeOfDay(hour: 14, minute: 0),
            endTime: TimeOfDay(hour: 17, minute: 0),
            location: destination,
            tags: ["afternoon", "leisure"],
          ),
        ],
        totalCost: (budget * 0.2).roundToDouble(),
      );
    });

    return Itinerary(
      id: 'generated_${DateTime.now().millisecondsSinceEpoch}',
      destination: destination,
      startDate: startDate,
      endDate: startDate.add(const Duration(days: 5)),
      dayPlans: dayPlans,
      totalCost: budget,
      numberOfPeople: groupSize,
      travelType: travelType,
      images: ['https://images.unsplash.com/photo-1506744038136-46273834b3fb'],
      suggestedFlightCost: budget * 0.4,
      suggestedHotelCostPerNight: (budget * 0.4) / 5,
      suggestedCabCostPerDay: (budget * 0.2) / 5,
      creatorName: 'Travel Assistant',
      creatorAvatar: null,
      tags: ['generated'],
    );
  }

  Future<Itinerary?> getLatestItinerary() async {
    final itineraryJson = await _storage.read(key: 'latest_itinerary');
    if (itineraryJson == null) return null;
    
    return Itinerary.fromJson(jsonDecode(itineraryJson));
  }

  List<Map<String, dynamic>> _generateActivities(
    String destination,
    double perPersonBudget,
    String travelType,
  ) {
    // This is a mock implementation. In a real app, this would call an API
    // to get real activities based on the destination, budget, and travel type.
    final activities = <Map<String, dynamic>>[];
    
    // Generate 6 days of activities
    for (int day = 1; day <= 6; day++) {
      final dayActivities = <String>[];
      
      // Morning activity
      dayActivities.add(_getActivity(destination, 'morning', perPersonBudget, travelType));
      
      // Afternoon activity
      dayActivities.add(_getActivity(destination, 'afternoon', perPersonBudget, travelType));
      
      // Evening activity
      dayActivities.add(_getActivity(destination, 'evening', perPersonBudget, travelType));
      
      activities.add({
        'day': day,
        'activities': dayActivities,
      });
    }
    
    return activities;
  }

  String _getActivity(
    String destination,
    String timeOfDay,
    double perPersonBudget,
    String travelType,
  ) {
    // This is a mock implementation. In a real app, this would be more sophisticated
    // and would consider the actual destination, budget, and travel type.
    final activities = {
      'morning': [
        'Visit local market',
        'Explore historical sites',
        'Go for a nature walk',
        'Visit museums',
      ],
      'afternoon': [
        'Enjoy local cuisine',
        'Shopping at local stores',
        'Visit popular attractions',
        'Relax at a cafe',
      ],
      'evening': [
        'Sunset viewing',
        'Cultural show',
        'Night market visit',
        'Dinner at local restaurant',
      ],
    };

    final timeActivities = activities[timeOfDay] ?? [];
    return timeActivities[DateTime.now().millisecondsSinceEpoch % timeActivities.length];
  }

  Future<Itinerary> adjustBudget(Itinerary itinerary, double newBudget) async {
    // Recalculate activities based on new budget
    final perPersonBudget = (newBudget / itinerary.numberOfPeople).round();
    
    final dayPlans = List.generate(5, (d) {
      final date = itinerary.startDate.add(Duration(days: d));
      return DayPlan(
        day: d + 1,
        date: date,
        activities: [
          Activity(
            name: "Activity ${d + 1}A in ${itinerary.destination}",
            description: "Description for activity ${d + 1}A",
            cost: (perPersonBudget * 0.1).roundToDouble(),
            startTime: TimeOfDay(hour: 9, minute: 0),
            endTime: TimeOfDay(hour: 12, minute: 0),
            location: itinerary.destination,
            tags: ["morning", "leisure"],
          ),
          Activity(
            name: "Activity ${d + 1}B in ${itinerary.destination}",
            description: "Description for activity ${d + 1}B",
            cost: (perPersonBudget * 0.1).roundToDouble(),
            startTime: TimeOfDay(hour: 14, minute: 0),
            endTime: TimeOfDay(hour: 17, minute: 0),
            location: itinerary.destination,
            tags: ["afternoon", "leisure"],
          ),
        ],
        totalCost: (perPersonBudget * 0.2).roundToDouble(),
      );
    });

    // Create new itinerary with adjusted budget
    final adjustedItinerary = Itinerary(
      id: 'adjusted_${DateTime.now().millisecondsSinceEpoch}',
      destination: itinerary.destination,
      startDate: itinerary.startDate,
      endDate: itinerary.startDate.add(const Duration(days: 5)),
      dayPlans: dayPlans,
      totalCost: newBudget,
      numberOfPeople: itinerary.numberOfPeople,
      travelType: itinerary.travelType,
      images: itinerary.images,
      suggestedFlightCost: newBudget * 0.4,
      suggestedHotelCostPerNight: (newBudget * 0.4) / 5,
      suggestedCabCostPerDay: (newBudget * 0.2) / 5,
      creatorName: itinerary.creatorName,
      creatorAvatar: itinerary.creatorAvatar,
      tags: itinerary.tags,
    );

    // Save adjusted itinerary
    await _storage.write(
      key: 'latest_itinerary',
      value: jsonEncode(adjustedItinerary.toJson()),
    );

    return adjustedItinerary;
  }

  Future<Itinerary> adjustItinerary({
    required Itinerary currentItinerary,
    String? newDestination,
    double? newBudget,
    String? newTravelType,
    int? newGroupSize,
    DateTime? newStartDate,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Create adjusted itinerary
    return Itinerary(
      id: 'adjusted_${DateTime.now().millisecondsSinceEpoch}',
      destination: newDestination ?? currentItinerary.destination,
      startDate: newStartDate ?? currentItinerary.startDate,
      endDate: (newStartDate ?? currentItinerary.startDate).add(const Duration(days: 5)),
      dayPlans: currentItinerary.dayPlans,
      totalCost: newBudget ?? currentItinerary.totalCost,
      numberOfPeople: newGroupSize ?? currentItinerary.numberOfPeople,
      travelType: newTravelType ?? currentItinerary.travelType,
      images: currentItinerary.images,
      suggestedFlightCost: (newBudget ?? currentItinerary.totalCost) * 0.4,
      suggestedHotelCostPerNight: ((newBudget ?? currentItinerary.totalCost) * 0.4) / 5,
      suggestedCabCostPerDay: ((newBudget ?? currentItinerary.totalCost) * 0.2) / 5,
      creatorName: currentItinerary.creatorName,
      creatorAvatar: currentItinerary.creatorAvatar,
      tags: currentItinerary.tags,
    );
  }
} 