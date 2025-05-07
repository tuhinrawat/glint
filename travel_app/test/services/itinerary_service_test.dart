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
      "destination": "Goa",
      "days": [
        {"day": 1, "activities": ["Beach visit", "Local food"]},
        {"day": 2, "activities": ["Water sports", "Shopping"]},
        {"day": 3, "activities": ["Sightseeing", "Nightlife"]}
      ],
      "budget": 20000,
      "travelType": "Leisure",
      "groupSize": 2,
      "startDate": "${now.toIso8601String()}"
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
    expect(savedItinerary.days.length, 3);
  });
} 