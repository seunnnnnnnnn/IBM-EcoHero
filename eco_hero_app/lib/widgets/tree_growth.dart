import 'package:flutter/material.dart';

class TreeGrowth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.grey[200],
      child: Center(
        child: Image.asset('assets/tree_growth.png'), // Ensure you have this asset in your project
      ),
    );
  }
}
