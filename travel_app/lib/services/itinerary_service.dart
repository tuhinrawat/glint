import 'dart:convert';
import 'package:travel_app/models/itinerary.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ItineraryService {
  final FlutterSecureStorage _storage;
  
  ItineraryService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

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
    final days = List.generate(5, (d) => {
      "day": d + 1,
      "activities": [
        "Activity ${d + 1}A in $destination",
        "Activity ${d + 1}B in $destination",
      ],
    });

    return Itinerary(
      destination: destination,
      days: days,
      totalCost: budget.round(),
      travelType: travelType,
      groupSize: groupSize,
      startDate: startDate,
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
    final perPersonBudget = (newBudget / itinerary.groupSize).round();
    final newActivities = _generateActivities(
      itinerary.destination,
      perPersonBudget.toDouble(),
      itinerary.travelType,
    );

    // Create new itinerary with adjusted budget
    final adjustedItinerary = Itinerary(
      destination: itinerary.destination,
      days: newActivities,
      totalCost: newBudget.round(),
      travelType: itinerary.travelType,
      groupSize: itinerary.groupSize,
      startDate: itinerary.startDate,
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
      destination: newDestination ?? currentItinerary.destination,
      days: currentItinerary.days,
      totalCost: (newBudget ?? currentItinerary.totalCost).round(),
      travelType: newTravelType ?? currentItinerary.travelType,
      groupSize: newGroupSize ?? currentItinerary.groupSize,
      startDate: newStartDate ?? currentItinerary.startDate,
    );
  }
} 