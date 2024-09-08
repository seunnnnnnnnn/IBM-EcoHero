import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eco_hero_app/widgets/common_widgets.dart'; // Adjust the import path

void main() {
  testWidgets('CustomBottomNavigationBar displays the correct initial index', (WidgetTester tester) async {
    // Build the CustomBottomNavigationBar widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomBottomNavigationBar(
            currentIndex: 1,
            onTap: (_) {},
          ),
        ),
      ),
    );

    // Verify that the correct item is selected
    final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
    expect(bottomNavBar.currentIndex, 1);
  });

  testWidgets('CustomBottomNavigationBar calls onTap with the correct index when an item is tapped', (WidgetTester tester) async {
    int tappedIndex = -1;

    // Build the CustomBottomNavigationBar widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomBottomNavigationBar(
            currentIndex: 0,
            onTap: (index) {
              tappedIndex = index;
            },
          ),
        ),
      ),
    );

    // Tap on the second item (index 1)
    await tester.tap(find.byIcon(Icons.people));
    await tester.pump();

    // Verify that the onTap callback was called with index 1
    expect(tappedIndex, 1);
  });

  testWidgets('CustomBottomNavigationBar displays all items correctly', (WidgetTester tester) async {
    // Build the CustomBottomNavigationBar widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomBottomNavigationBar(
            currentIndex: 0,
            onTap: (_) {},
          ),
        ),
      ),
    );

    // Verify the presence of each BottomNavigationBarItem
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Community'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
