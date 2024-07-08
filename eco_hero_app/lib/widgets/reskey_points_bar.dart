import 'package:flutter/material.dart';

class ReskeyPointsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: LinearProgressIndicator(
        value: 0.7, // Example progress value
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }
}
