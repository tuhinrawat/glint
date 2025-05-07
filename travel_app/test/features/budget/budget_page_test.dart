import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/features/budget/budget_page.dart';
import 'package:travel_app/models/budget.dart';
import 'package:travel_app/services/budget_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([BudgetService])
void main() {
  testWidgets('BudgetPage renders form and calculates budget', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BudgetPage(),
      ),
    );

    // Wait for initial frame
    await tester.pump();

    // Wait for animations
    await tester.pump(const Duration(milliseconds: 500));

    // Verify initial state
    expect(find.text('Budget Allocation'), findsOneWidget);
    expect(find.text('Total Budget (₹)'), findsOneWidget);
    expect(find.text('Enter total budget'), findsOneWidget);

    // Enter budget amount
    await tester.enterText(find.byType(TextFormField).first, '10000');
    await tester.pump();

    // Enter group size
    await tester.enterText(find.byType(TextFormField).last, '4');
    await tester.pump();
  });

  testWidgets('BudgetPage validates form fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BudgetPage(),
      ),
    );

    // Wait for initial frame
    await tester.pump();

    // Wait for animations
    await tester.pump(const Duration(milliseconds: 500));

    // Try to submit without entering values
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify error messages
    expect(find.text('Please enter total budget'), findsOneWidget);
  });

  testWidgets('BudgetPage shows loading state', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BudgetPage(),
      ),
    );

    // Wait for initial frame
    await tester.pump();

    // Wait for animations
    await tester.pump(const Duration(milliseconds: 500));

    // Enter valid values
    await tester.enterText(find.byType(TextFormField).first, '10000');
    await tester.pump();

    // Tap confirm button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('BudgetPage shows success state', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BudgetPage(),
      ),
    );

    // Wait for initial frame
    await tester.pump();

    // Wait for animations
    await tester.pump(const Duration(milliseconds: 500));

    // Enter valid values
    await tester.enterText(find.byType(TextFormField).first, '10000');
    await tester.pump();

    // Tap confirm button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Wait for loading to complete
    await tester.pump(const Duration(seconds: 2));

    // Verify success message
    expect(find.text('Budget saved successfully!'), findsOneWidget);
  });

  testWidgets('BudgetPage shows error state', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BudgetPage(),
      ),
    );

    // Wait for initial frame
    await tester.pump();

    // Wait for animations
    await tester.pump(const Duration(milliseconds: 500));

    // Enter invalid values
    await tester.enterText(find.byType(TextFormField).first, '1000');
    await tester.pump();

    // Tap confirm button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify error message
    expect(find.text('Budget must be between ₹5,000 and ₹1,00,000'), findsOneWidget);
  });
} 