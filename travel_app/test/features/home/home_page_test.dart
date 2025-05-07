import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/features/home/home_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  testWidgets('HomePage renders search bar and destination cards', (WidgetTester tester) async {
    // Set a fixed viewport size
    tester.binding.window.physicalSizeTestValue = const Size(1080, 2400);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(),
      ),
    );

    // Wait for initial frame
    await tester.pump();

    // Wait for animations
    await tester.pump(const Duration(milliseconds: 500));

    // Verify search bar
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search destinations...'), findsOneWidget);

    // Verify destination cards
    expect(find.text('Goa'), findsOneWidget);
    expect(find.text('Beaches & Culture'), findsOneWidget);
    expect(find.text('Himachal'), findsOneWidget);
    expect(find.text('Mountains & Adventure'), findsOneWidget);
    expect(find.text('Kerala'), findsOneWidget);
    expect(find.text('Backwaters & Nature'), findsOneWidget);

    // Verify navigation bar is in the NavBar widget
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
} 