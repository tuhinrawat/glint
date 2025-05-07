import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/features/booking/booking_page.dart';
import 'package:travel_app/models/booking.dart';
import 'package:travel_app/services/booking_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([BookingService])
void main() {
  testWidgets('BookingPage renders form and books trip', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BookingPage(),
      ),
    );

    // Wait for initial frame
    await tester.pump();

    // Wait for animations
    await tester.pump(const Duration(milliseconds: 500));

    // Verify initial state
    expect(find.text('Book Your Trip'), findsOneWidget);
    expect(find.text('Destination'), findsOneWidget);
    expect(find.text('Travel Date'), findsOneWidget);
    expect(find.text('Enter destination'), findsOneWidget);

    // Enter destination
    await tester.enterText(find.byType(TextFormField).first, 'Mumbai');
    await tester.pump();

    // Select date
    await tester.tap(find.text(DateTime.now().add(const Duration(days: 7)).toString().split(' ')[0]));
    await tester.pump();

    // Verify form is filled
    expect(find.text('Mumbai'), findsOneWidget);
  });

  testWidgets('BookingPage validates form fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BookingPage(),
      ),
    );

    // Wait for initial frame
    await tester.pump();

    // Wait for animations
    await tester.pump(const Duration(milliseconds: 500));

    // Clear destination field
    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.pump();

    // Try to submit
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify error message
    expect(find.text('Please enter a destination'), findsOneWidget);
  });

  testWidgets('BookingPage shows loading state', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BookingPage(),
      ),
    );

    // Wait for initial frame
    await tester.pump();

    // Wait for animations
    await tester.pump(const Duration(milliseconds: 500));

    // Enter valid destination
    await tester.enterText(find.byType(TextFormField).first, 'Mumbai');
    await tester.pump();

    // Submit form
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100)); // Wait for loading indicator

    // Verify loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('BookingPage shows success state', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BookingPage(),
      ),
    );

    // Wait for initial frame
    await tester.pump();

    // Wait for animations
    await tester.pump(const Duration(milliseconds: 500));

    // Enter valid destination
    await tester.enterText(find.byType(TextFormField).first, 'Mumbai');
    await tester.pump();

    // Submit form
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Wait for loading to complete
    await tester.pump(const Duration(seconds: 4));

    // Verify success message
    expect(find.text('Booking successful!'), findsOneWidget);
  });
} 