import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/services/itinerary_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([FlutterSecureStorage])
import 'itinerary_service_test.mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late ItineraryService service;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = ItineraryService(storage: mockStorage);
  });

  test('ItineraryService generates mock itinerary', () async {
    when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
        .thenAnswer((_) async => null);

    final itinerary = await service.generateItinerary(
      destination: 'Goa',
      budget: 20000,
      travelType: 'Leisure',
      groupSize: 2,
      startDate: DateTime.now(),
    );
    
    expect(itinerary.destination, 'Goa');
    expect(itinerary.days.length, 3);
    expect(itinerary.budget, 20000);
    expect(itinerary.travelType, 'Leisure');
    expect(itinerary.groupSize, 2);
  });

  test('ItineraryService saves and retrieves itinerary', () async {
    final now = DateTime.now();
    final mockItinerary = '''{
      "id": "test_123",
      "destination": "Goa",
      "startDate": "${now.toIso8601String()}",
      "endDate": "${now.add(const Duration(days: 5)).toIso8601String()}",
      "totalCost": 20000.0,
      "numberOfPeople": 2,
      "travelType": "Leisure",
      "images": ["https://example.com/image.jpg"],
      "suggestedFlightCost": 8000.0,
      "suggestedHotelCostPerNight": 1600.0,
      "suggestedCabCostPerDay": 800.0,
      "rating": 5.0,
      "creatorName": "Travel Assistant",
      "tags": ["generated", "leisure"],
      "status": "TripStatus.planning",
      "dayPlans": [
        {
          "day": 1,
          "date": "${now.toIso8601String()}",
          "activities": [
            {
              "name": "Beach visit",
              "description": "Visit the beautiful beach",
              "cost": 1000.0,
              "location": "Calangute Beach",
              "startTime": {"hour": 9, "minute": 0},
              "endTime": {"hour": 14, "minute": 0},
              "tags": ["beach", "relaxation"]
            }
          ],
          "totalCost": 1000.0
        }
      ],
      "isCompleted": false
    }''';

    when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
        .thenAnswer((_) async => null);
    when(mockStorage.read(key: anyNamed('key')))
        .thenAnswer((_) async => mockItinerary);

    final itinerary = await service.generateItinerary(
      destination: 'Goa',
      budget: 20000,
      travelType: 'Leisure',
      groupSize: 2,
      startDate: now,
    );
    
    final savedItinerary = await service.getSavedItinerary('Goa', now);
    expect(savedItinerary, isNotNull);
    expect(savedItinerary!.destination, 'Goa');
    expect(savedItinerary.dayPlans.length, 1);
    expect(savedItinerary.totalCost, 20000.0);
    expect(savedItinerary.travelType, 'Leisure');
    expect(savedItinerary.numberOfPeople, 2);
  });
} 