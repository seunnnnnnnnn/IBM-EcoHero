// lib/widgets/bin_button.dart

import 'package:flutter/material.dart';

class BinButton extends StatelessWidget {
  final String binColor; // The text label of the button, e.g., 'Black', 'Green', 'Blue'
  final Color color; // The color of the button
  final String selectedBinColor; // The color of the bin to compare against
  final Function(String, String) onSelect; // Callback function to handle button press

  const BinButton(
    this.binColor,
    this.color,
    this.selectedBinColor,
    this.onSelect, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () => onSelect(selectedBinColor, binColor.toLowerCase()), // Call the callback with selected colors
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Set the button's background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          binColor, // Display the bin color name
          style: const TextStyle(
            color: Colors.white, // Set the text color to white for contrast
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
