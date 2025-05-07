import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/features/itinerary/itinerary_page.dart';
import 'package:travel_app/services/itinerary_service.dart';
import 'package:travel_app/models/itinerary.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

@GenerateMocks([ItineraryService])
import 'itinerary_page_test.mocks.dart';

void main() {
  late MockItineraryService mockService;

  setUp(() {
    mockService = MockItineraryService();
  });

  testWidgets('ItineraryPage renders form and generates itinerary', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1080, 2400);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

    final mockItinerary = Itinerary(
      destination: 'Goa',
      days: [
        {'day': 1, 'activities': ['Beach visit', 'Local food']},
        {'day': 2, 'activities': ['Water sports', 'Shopping']},
        {'day': 3, 'activities': ['Sightseeing', 'Nightlife']},
      ],
      budget: 20000,
      travelType: 'Leisure',
      groupSize: 2,
      startDate: DateTime.now(),
    );

    when(mockService.generateItinerary(
      destination: anyNamed('destination'),
      budget: anyNamed('budget'),
      travelType: anyNamed('travelType'),
      groupSize: anyNamed('groupSize'),
      startDate: anyNamed('startDate'),
    )).thenAnswer((_) async => mockItinerary);

    await tester.pumpWidget(
      MaterialApp(
        home: ItineraryPage(service: mockService),
      ),
    );

    await tester.pump();

    expect(find.byType(TextFormField), findsOneWidget, reason: 'Should find destination text field');
    expect(find.byType(Slider), findsOneWidget, reason: 'Should find budget slider');
    expect(find.text('Generate Itinerary'), findsOneWidget, reason: 'Should find generate button');

    await tester.enterText(find.byType(TextFormField).first, 'Goa');
    await tester.pump();

    await tester.tap(find.text('Generate Itinerary'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget, reason: 'Should show loading indicator');

    await tester.pumpAndSettle(const Duration(seconds: 3));

    find.byType(Text).evaluate().forEach((element) {
      final widget = element.widget as Text;
      print('Found text widget: ${widget.data}');
    });

    expect(find.text('Your Itinerary for Goa'), findsOneWidget, reason: 'Should show itinerary header');
    
    expect(find.text('Day 1'), findsOneWidget, reason: 'Should show Day 1');
    expect(find.text('Beach visit, Local food'), findsOneWidget, reason: 'Should show Day 1 activities');
  });

  testWidgets('ItineraryPage validates form fields', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1080, 2400);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

    await tester.pumpWidget(
      MaterialApp(
        home: ItineraryPage(service: mockService),
      ),
    );

    // Scroll to the button
    await tester.dragUntilVisible(
      find.text('Generate Itinerary'),
      find.byType(SingleChildScrollView),
      const Offset(0, -100),
    );
    await tester.pump();

    // Try to generate without filling form
    await tester.tap(find.text('Generate Itinerary'));
    await tester.pump();

    // Wait for button animation
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();

    // Verify error message is shown in SnackBar
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Please fill all fields correctly'), findsOneWidget);
  });
} 