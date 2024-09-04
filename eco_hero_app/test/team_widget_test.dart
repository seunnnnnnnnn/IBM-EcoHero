import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eco_hero_app/community/team_widget.dart';

void main() {
  group('TeamWidget Tests', () {
    testWidgets('Displays team information', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TeamWidget(
              teamName: 'Test Team',
              members: 5,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Team'), findsOneWidget);
      expect(find.text('Members: 5'), findsOneWidget);
    });

    testWidgets('Calls onTap callback on tap', (WidgetTester tester) async {
      // Arrange
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TeamWidget(
              teamName: 'Test Team',
              members: 5,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(ListTile));
      await tester.pump(); // Rebuild the widget tree

      // Assert
      expect(tapped, true);
    });
  });
}

//explaination:
//In this test file, we are testing the TeamWidget widget. The TeamWidget widget is a simple widget that displays the name of a team and the number of members in that team. It also has a callback function onTap that is called when the widget is tapped.
//In the first test, we test that the widget displays the correct team information. We create a TeamWidget with a team name of 'Test Team' and 5 members, and then assert that the widget displays the correct team name and number of members.
//In the second test, we test that the onTap callback is called when the widget is tapped. We create a TeamWidget with a dummy onTap callback that sets a boolean variable tapped to true. We then tap the widget and assert that the tapped variable is true, indicating that the callback was called.
//These tests ensure that the TeamWidget widget works as expected and displays the correct information and calls the onTap callback when tapped.
//The tests are written using the Flutter test framework and the testWidgets function, which allows us to test widgets in a Flutter app. We use the pumpWidget function to build the widget tree, the tap function to simulate tapping the widget, and the expect function to assert the expected behavior of the widget.
