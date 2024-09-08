// test/widgets/bin_button_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eco_hero_app/widgets/bin_button.dart';

void main() {
  testWidgets('BinButton displays correct label and color', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BinButton('Green', Colors.green, 'green', (correctBin, selectedBin) {}),
    ));

    // Check if the label is correct
    expect(find.text('Green'), findsOneWidget);
    // Check if the button color is correct (using a colored box to detect)
    final coloredBox = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect((coloredBox.style?.backgroundColor?.resolve({}) ?? Colors.transparent), Colors.green);
  });

  testWidgets('BinButton calls onSelect with correct parameters', (WidgetTester tester) async {
    String correctBin = 'green';
    String selectedBin = '';

    await tester.pumpWidget(MaterialApp(
      home: BinButton('Green', Colors.green, correctBin, (correct, selected) {
        selectedBin = selected;
      }),
    ));

    // Simulate button press
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify the onSelect callback is called with correct parameters
    expect(selectedBin, 'green');
  });
}


//explaination:
//In this test file, we are testing the BinButton widget. The BinButton widget is a simple button widget that displays a label and a color. It also has an onSelect callback that is called when the button is pressed.
//In the first test, we test that the widget displays the correct label and color. We create a BinButton with a label of 'Green' and a color of green, and then assert that the widget displays the correct label and color.
//In the second test, we test that the onSelect callback is called with the correct parameters when the button is pressed. We create a BinButton with a dummy onSelect callback that sets a variable selectedBin to the selected bin. We then simulate pressing the button and assert that the selectedBin variable is set to the correct bin.
//These tests ensure that the BinButton widget works as expected and displays the correct label and color, and calls the onSelect callback with the correct parameters when pressed.
//The tests are written using the Flutter test framework and the testWidgets function, which allows us to test widgets in a Flutter app. We use the pumpWidget function to build the widget tree, the tap function to simulate pressing the button, and the expect function to assert the expected behavior of the widget.